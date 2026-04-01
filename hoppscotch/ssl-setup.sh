#!/bin/sh
# This script will configure an Apache virtual host with SSL for Hoppscotch deployment

# Fetch domain to use from first provided parameter,
DOMAIN="<domain>" 

# Ensure a domain was provided otherwise display
# an error message and stop the script
if [ -z "$DOMAIN" ]; then
  >&2 echo 'ERROR: A domain must be provided to run this script'
  exit 1
fi

# Install core system packages
apt update

apt install -y apache2 certbot python3-certbot-apache

# Set up Apache virtual host
cat >/etc/apache2/sites-available/${DOMAIN}.conf <<EOL
<VirtualHost *:80>
    ServerName ${DOMAIN}

    # Redirect all HTTP requests to HTTPS
    RewriteEngine On
    RewriteCond %{HTTPS} off
    RewriteRule ^ https://%{HTTP_HOST}%{REQUEST_URI} [L,R=301]

    ErrorLog ${APACHE_LOG_DIR}/error-${DOMAIN}.log
    CustomLog ${APACHE_LOG_DIR}/access-${DOMAIN}.log combined
</VirtualHost>

<VirtualHost *:443>
    ServerName ${DOMAIN}

    # # Enable SSL (will be uncommented after certbot runs)
    # SSLEngine on
    # SSLCertificateFile /etc/letsencrypt/live/${DOMAIN}/fullchain.pem
    # SSLCertificateKeyFile /etc/letsencrypt/live/${DOMAIN}/privkey.pem
    # Include /etc/letsencrypt/options-ssl-apache.conf
    # SSLOpenSSLConfCmd DHParameters /etc/letsencrypt/ssl-dhparams.pem

    # Enable required modules for WebSocket support
    ProxyPreserveHost On
    ProxyRequests Off

    # WebSocket support for GraphQL subscriptions
    RewriteEngine On
    RewriteCond %{HTTP:Upgrade} websocket [NC]
    RewriteCond %{HTTP:Connection} upgrade [NC]
    RewriteRule ^/backend/?(.*) "ws://localhost:3170/\$1" [P,L]

    # Backend API routes - must come before the main proxy
    ProxyPass /backend/ http://localhost:3170/
    ProxyPassReverse /backend/ http://localhost:3170/
    
    # v1 API routes
    ProxyPass /v1/ http://localhost:3170/v1/
    ProxyPassReverse /v1/ http://localhost:3170/v1/

    # Admin interface
    ProxyPass /admin/ http://localhost:3100/
    ProxyPassReverse /admin/ http://localhost:3100/

    # Main frontend (catch-all - must be last)
    ProxyPass / http://localhost:3000/
    ProxyPassReverse / http://localhost:3000/

    # Proxy headers for all requests
    ProxyPassReverse / http://localhost:3000/
    RequestHeader set X-Forwarded-Proto "https"
    RequestHeader set X-Forwarded-Port "443"
    RequestHeader set X-Forwarded-For %{REMOTE_ADDR}s
    
    # Cookie handling
    ProxyPassReverseCookiePath / /
    ProxyPassReverseCookieDomain localhost ${DOMAIN}

    # CORS headers for API requests
    <LocationMatch "^/(backend|v1)/">
        Header always set Access-Control-Allow-Origin "*"
        Header always set Access-Control-Allow-Methods "GET, POST, PUT, DELETE, OPTIONS"
        Header always set Access-Control-Allow-Headers "Content-Type, Authorization, X-Requested-With"
    </LocationMatch>

    # Handle preflight OPTIONS requests
    RewriteCond %{REQUEST_METHOD} OPTIONS
    RewriteRule ^(.*)$ \$1 [R=200,L]

    ErrorLog ${APACHE_LOG_DIR}/error-${DOMAIN}.log
    CustomLog ${APACHE_LOG_DIR}/access-${DOMAIN}.log combined
</VirtualHost>
EOL

# Enable the new virtual host and required modules
a2enmod proxy
a2enmod proxy_http
a2enmod proxy_wstunnel
a2enmod rewrite
a2enmod ssl
a2enmod headers
a2enmod proxy_balancer
a2enmod lbmethod_byrequests

# Test configuration
sudo apache2ctl configtest

# Disable default site and enable our site
a2dissite 000-default.conf
a2ensite ${DOMAIN}.conf

# Restart Apache to apply changes
systemctl restart apache2

# Obtain SSL certificate using Certbot
certbot --apache -d $DOMAIN --non-interactive --agree-tos --email admin@${DOMAIN}

# Set up automatic SSL certificate renewal
echo "0 0 * * * certbot renew --quiet" | crontab -

echo ""
echo "SSL has been configured for the domain: https://$DOMAIN/"
echo ""
echo "URL Mappings:"
echo "Frontend: https://$DOMAIN/ -> http://localhost:3000/"
echo "Admin: https://$DOMAIN/admin/ -> http://localhost:3100/"  
echo "Backend GraphQL: https://$DOMAIN/backend/ -> http://localhost:3170/"
echo "Backend API: https://$DOMAIN/v1/ -> http://localhost:3170/v1/"
echo "WebSocket: wss://$DOMAIN/backend/ -> ws://localhost:3170/"
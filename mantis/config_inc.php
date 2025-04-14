<?php

$g_db_type           = 'mysqli';

$g_hostname          = getenv('MYSQL_HOST') !== false ? getenv('MYSQL_HOST') : 'db';
$g_database_name     = getenv('MYSQL_DATABASE') !== false ? getenv('MYSQL_DATABASE') : 'bugtracker';
$g_db_username       = getenv('MYSQL_USER') !== false ? getenv('MYSQL_USER') : 'mantis';
$g_db_password       = getenv('MYSQL_PASSWORD') !== false ? getenv('MYSQL_PASSWORD') : 'mantis';


$g_crypto_master_salt       = '<generated_salt_id>';
$g_xmlrpc_enabled = ON;
$g_rest_api_enabled = ON;
$g_status_enum_string = '10:new,20:feedback,30:acknowledged,40:confirmed,50:assigned,80:resolved,90:closed,15:not_picked';
$g_status_colors['not_picked'] = '#8B4513';

# Configure email
$g_webmaster_email          = getenv('EMAIL_WEBMASTER') !== false ? getenv('EMAIL_WEBMASTER') : null;
$g_from_email          = getenv('EMAIL_FROM') !== false ? getenv('EMAIL_FROM') : null;
$g_return_path_email          = getenv('EMAIL_RETURN_PATH') !== false ? getenv('EMAIL_RETURN_PATH') : null;

include 'config_inc_addon.php';

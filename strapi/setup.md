# 📟 Strapi

## 📄 Description

Strapi is the leading open-source headless CMS. It's 100% JavaScript/TypeScript, fully customizable, and developer-first.  

---
---


## ⚙️ Installation

### 📦 File: `node-setup.sh`

This script sets up a complete Node.js development environment by installing essential system packages, configuring NVM, installing Node.js v20, setting up Yarn via Corepack, and globally installing PM2 for process management.

Execute
```
chmod +x node-setup.sh
./node-setup.sh
```
---
---
### Create Strapi Project
Execute
```
yarn create strapi
```
This will then ask for device auth on a URL similar to :
https://auth.cloud.strapi.io/device/confirmation?state=mJmJXY6rJ9jKrHhSqFvz74H1SSfdjKfF

and other details like : 

Do you want to use the default database (sqlite) ? No

Choose your default database client postgres

Database name: 

Host: 

Port: 

Username: 

Password: 

Enable SSL connection: No

Start with an example structure & data? Yes

Start with Typescript? Yes

Install dependencies with yarn? Yes

Initialize a git repository? Yes


---
## 🌐 Exposed Server Ports

| Port  | Description                |
|------ |----------------------------|
| 1337  | Strapi Admin               |

> Ensure the listed ports are open (firewall) and available on the instance.

---

## 🔺 DNS Registration
On godaddy register the domain `<domain>`,
and wait for the dns registration to be completed before availing the ssl cert.

---

## 📃 SSL Cert Setup
### 📦 File: `ssl-cert.sh`
The script is already configured to avail the ssl cert for the domain `<domain>`

Execute
```
chmod +x ssl-cert.sh
./ssl-cert.sh
```
---

## 🔒 Access & Authentication

Admin user is created on signing in for the first time.

---
---


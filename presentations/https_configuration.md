# HTTPS and proxying documentation

----

eXist-db apps, such as our hoax app, would normally be accessible at `http://xxx.yyy.com:8080/exist/apps/hoax/`, where `xxx.yyy.com` is the domain name. In pursuit of more user-friendly address, such as `http://hoax.obdurodon.org`, we configure a virtual host, so that requests for this address will be forwarded automatically to the eXist-db app while masking the complex, genuine address from the user. This type of forwarding is called *proxying*.

By default web servers accept regular connections (to addresses that begin `http://`) on port 80 and secure connections (to addresses that begin `https://`) on port 443; the secure connections are encrypted end to end, so that passwords or other sensitive information is not sent over the Internet as plain text. These ports do not have to be specified in a URL because they are the defaults. Secure connections require a certificate, such as those provided at no cost by [Let’s Encrypt](https://letsencrypt.org/).

To improve the general security of our site we configure a certificate and translate insecure requests that arrive on port 80 to secure requests that are handled on port 443. This means that if a user requests a connection to `http://hoax.obdurodon.org`, the connection arrives on port 80, is forwarded automatically to port 443 on the same machine, and is then forwarded to eXist-db on port 8080 on the same machine.

The instructions below assume that 1) you have access to the configuration files on your host, 2) your web server is Apache 2, and 3) that you understand the basics of [configuring virtual hosts](https://httpd.apache.org/docs/2.4/vhosts/). Back up your web configuration files before editing them so that you can restore your original level of functionality should anything go wrong.

----

**Software required:** [eXist-db](http://exist-db.org), [apache2 http server](https://httpd.apache.org/)

----

## Current Apache HTTP configuration (working) 

**Path:** /etc/httpd/conf.d/hoax.conf

```xml
<VirtualHost *:80>
    DocumentRoot /var/www/html/hoax
    ServerName hoax.obdurodon.org
    <Proxy *>
         Order deny,allow
         Allow from all
    </Proxy>
    <Directory /var/www/html/hoax>
         Allow from all
         Require all granted
    </Directory>

    # This proxypass is for hoax.obdurodon.org
    # Virtual host configured in /etc/httpd/conf.d/hoax.conf (here)
    ProxyPass / http://localhost:8080/exist/apps/pr-app/
    ProxyPassReverse / http://localhost:8080/exist/apps/pr-app/
    ProxyPassReverseCookieDomain localhost hoax.obdurodon.org
    ProxyPassReverseCookiePath / /exist/apps/pr-app/
    ProxyPreserveHost On
    RewriteEngine On
    RewriteCond %{REQUEST_URI} ^/\.well-known/acme-challenge
    RewriteRule ^/(.*)$ /$1 [L]
    RewriteCond %{HTTPS} off
    RewriteRule ^ https://hoax.obdurodon.org%{REQUEST_URI} [R=301,L]    
    RewriteCond %{HTTP_HOST} =obdurodon.org [OR]
    RewriteCond %{HTTP_HOST} =hoax.obdurodon.org
    RewriteRule ^ https://hoax.obdurodon.org%{REQUEST_URI} [END,QSA,R=permanent]
    
    RewriteRule ^/$ /index [PT,L]
    RewriteRule ^/(.*)$ /$1 [PT]
</VirtualHost>
```

## Current Apache HTTPS configuration from server (working)

Enabled on the server since 2023-03-09T10:00 CET.

**Path:** /etc/httpd/conf.d/hoax-ssl.conf

**NB:** Some versions of `mod_ssl` (including MacOS Ventura) seem to fail on the test `<IfModule mod_ssl>`, apparently because they use different naming in different distros.

**FIXME:** Forwards all https connections to hoax.obdurodon.org, e.g., <https://dh.obdurodon.org>. Specifically:

1. Enter `https://dh.obdurodon.org` in the browser address bar
2. Receive warning that connection is not secure
3. Tell it to connect anyway
4. Connects to hoax site and shows `https://dh.obdurodon.org in address bar

```xml
#<IfModule mod_ssl>
<VirtualHost *:443>
    SSLProtocol -all +TLSv1.2
    SSLEngine on
    SSLProxyEngine on
    SSLCertificateFile /etc/letsencrypt/live/hoax.obdurodon.org/fullchain.pem
    SSLCertificateKeyFile /etc/letsencrypt/live/hoax.obdurodon.org/privkey.pem
    SSLCipherSuite
"EECDH+ECDSA+AESGCM:EECDH+aRSA+AESGCM:EECDH+ECDSA+SHA256:EECDH+aRSA+SHA256:EECDH+EC
DSA+SHA384:EECDH+ECDSA+SHA256:EECDH+aRSA+SHA384:EDH+aRSA+AESGCM:EDH+aRSA+SHA256:EDH
+aRSA:EECDH:!aNULL:!eNULL:!MEDIUM:!LOW:!3DES:!MD5:!EXP:!PSK:!SRP:!DSS:!RC4:!SEED"
    SSLHonorCipherOrder on
    SSLCertificateFile /etc/letsencrypt/live/hoax.obdurodon.org/fullchain.pem
    SSLCertificateKeyFile /etc/letsencrypt/live/hoax.obdurodon.org/privkey.pem
    Header set Strict-Transport-Security "max-age=31536000"

    DocumentRoot /var/www/html/hoax
    ServerName hoax.obdurodon.org
    <Proxy *>
         Order deny,allow
         Allow from all
    </Proxy>
    <Directory /var/www/html/hoax>
         Allow from all
         Require all granted
    </Directory>

    # This proxypass is for hoax.obdurodon.org
    # Virtual host configured in /etc/httpd/conf.d/hoax.conf (here)
    ProxyPass / http://localhost:8080/exist/apps/pr-app/
    ProxyPassReverse / http://localhost:8080/exist/apps/pr-app/
    ProxyPassReverseCookieDomain localhost hoax.obdurodon.org
    ProxyPassReverseCookiePath / /exist/apps/pr-app/
    ProxyPreserveHost On
    RewriteEngine On
    RewriteCond %{REQUEST_URI} ^/\.well-known/acme-challenge
    RewriteRule ^/(.*)$ /$1 [L]
    RewriteRule ^/$ /index [PT,L]
    RewriteRule ^/(.*)$ /$1 [PT]
</VirtualHost>
#</IfModule>
```

## Guide to creating SSL certificate

Secure (https) connections require an SSL certificate on the server. These certificates are available at no cost from [Let’s Encrypt](https://letsencrypt.org/), and must be renewed every ninety days. The system administrator will be prompted to renew with instructions about how to implement the renewal with a single command on the command line.


### Create a Let’s Encrypt certificate
	
```
certbot-auto certonly --webroot -w /var/www/html --agree-tos --email djbpitt@gmail.com -d obdurodon.org -d www.obdurodon.org 
```

	
**Notes:**

* certonly creates the certificate but does not add it to the virtual host
* --agree-tos accepts terms of service
* --email djbpitt@gmail.com
* -d = domain
	
### Check certificates with

```	
/usr/local/bin/certbot-auto certificates
```

### Add new Virtual Host entry

Add new VirtualHost entry to `/etc/httpd/conf.d/ssl_lets-encrypt.conf`:

```
	<VirtualHost *:443>
	    UseCanonicalName on
    ServerName obdurodon.org
    ServerAlias www.obdurodon.org
    
    DocumentRoot /var/www/html
    SSLCertificateFile /etc/letsencrypt/live/${domain}/fullchain.pem
    SSLCertificateKeyFile /etc/letsencrypt/live/${domain}/privkey.pem
</VirtualHost>
```

For our purposes add additional SSL and proxy directives, see the working configuration in section Current Apache HTTPS configuration from server, above.

----

To test the configuration we also implemented it for local access (only) on a MacOS laptop, using the fake domain name `hoax.org`. The configuration file for https is:

```
# 2022-07-16 djb: Local virtual hosts
# Virtual Hosts
#
# Required modules: mod_log_config

# If you want to maintain multiple domains/hostnames on your
# machine you can setup VirtualHost containers for them. Most configurations
# use only name-based virtual hosts so the server doesn't need to worry about
# IP addresses. This is indicated by the asterisks in the directives below.
#
# Please see the documentation at
# <URL:http://httpd.apache.org/docs/2.4/vhosts/>
# for further details before you try to setup virtual hosts.
#
# You may use the command line option '-S' to verify your virtual host
# configuration.

#
# VirtualHost example:
# Almost any Apache directive may go into a VirtualHost container.
# The first VirtualHost section is used for all requests that do not
# match a ServerName or ServerAlias in any <VirtualHost> block.
#
# 2022-07-16 djb: add hoax.org pointer to localhost in /etc/hosts
<VirtualHost *:80>
    ServerName hoax.org
    ProxyRequests Off
    DirectoryIndex index
    <Proxy *>
         Order deny,allow
         Allow from all
    </Proxy>

    # This proxypass is for hoax.org
    # Virtual host configured in /etc/apache2/extras/local-vhosts.conf (here!)
    # Also configured in /etc/hosts
    ProxyPass / http://localhost:8080/exist/apps/pr-app/
    ProxyPassReverse / http://localhost:8080/exist/apps/pr-app/
    ProxyPassReverseCookieDomain localhost hoax.org
    ProxyPassReverseCookiePath /exist /
    ProxyPreserveHost On
    RewriteEngine On
    RewriteRule ^/$ /index [PT,L]
    RewriteRule ^/(.*)$ /$1 [PT]
</VirtualHost>
<VirtualHost *:80>
    DocumentRoot /Library/WebServer/Documents
    ServerName localhost
</VirtualHost>
```
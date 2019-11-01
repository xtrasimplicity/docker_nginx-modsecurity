# NGinx + ModSecurity for Docker
_NGinx server with ModSecurity support, running in Docker._

# Usage
1) Simply create a configuration file for the NGinx virtual host, as desired. i.e.:
```
# mysite.conf
server {
  listen 80;
  listen [::]:80;
  server_name mysite.local;
  modsecurity on;

  location / {
    root /var/www/html;
    modsecurity_rules_file /etc/nginx/myrules.conf;
  }
}
```
2) Then, create a file containing your ModSecurity rules. i.e.
```
# rules.conf
SecRule REQUEST_METHOD "@streq PUT" \
  [...]
```

3) Then, mount the NGinx config file to any file in `/etc/nginx/conf.d`, and the ModSecurity rules to `/etc/nginx/myrules.conf` (or whatever you specified in the NGinx config file).

#### Docker
```bash
docker run -p 80:80 \
           -v mysite.conf:/etc/nginx/conf.d/mysite.conf \
           -v rules.conf:/etc/nginx/myrules.conf \
           xtrasimplicity/nginx-modsecurity
```
#### Docker-compose
```bash
---
version: '3.5'
services:
  proxy:
    image: xtrasimplicity/nginx-modsecurity
    volumes:
      - mysite.conf:/etc/nginx/conf.d/mysite.conf
      - rules.conf:/etc/nginx/myrules.conf
    ports:
      - 80:80
```
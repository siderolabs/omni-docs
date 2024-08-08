---
description: >-
  This guide will show you how to expose a self-hosted Omni with Nginx and
  secure it with TLS
---

# How to expose Omni with Nginx (HTTPS)

### Omni deployment configuration

You need to deploy an omni instance the [how to deploy omni on prem guide](https://omni.siderolabs.com/docs/how-to-guides/how-to-deploy-omni-on-prem/), with the following flags set:

```bash
--name=$OMNI_NAME
--private-key-source=file:///omni.asc
--advertised-api-url=https://$OMNI_DOMAIN/
--bind-addr=127.0.0.1:8080
--machine-api-bind-addr=127.0.0.1:8090
--siderolink-api-advertised-url=https://api.$OMNI_DOMAIN:443
--k8s-proxy-bind-addr=127.0.0.1:8100
--advertised-kubernetes-proxy-url=https://kube.$OMNI_DOMAIN/
--account-id=$OMNI_UUID
--siderolink-use-grpc-tunnel=true
## Also add the authentication flags according to your setup
```

### Certificates

You can use acme or certbot to generate certificates for your domain. In the following nginx config, the are stored in `/var/lib/acme/omni/` and `/var/lib/acme/omni_api/` and `/var/lib/acme/omni_kube/`. Make sure to change the paths to your own or to output the certificates to those paths.

### Nginx configuration

Use the following configuration to expose omni with nginx. Make sure to change the domain name ($OMNI\_DOMAIN) to your own domain and to update the certificate paths if applicable.

```nginx
http {
	proxy_redirect          off;
	proxy_connect_timeout   60s;
	proxy_send_timeout      60s;
	proxy_read_timeout      60s;
	proxy_http_version      1.1;
	# $connection_upgrade is used for websocket proxying
	map $http_upgrade $connection_upgrade {
		default upgrade;
		''      close;
	}
    server {
		listen 0.0.0.0:80 ;
		listen [::0]:80 ;
		server_name $OMNI_DOMAIN ;
		location / {
			return 301 https://$host$request_uri;
		}
	}
	server {
		listen 0.0.0.0:443 http2 ssl ;
		listen [::0]:443 http2 ssl ;
		server_name $OMNI_DOMAIN ;
		ssl_certificate /var/lib/acme/omni/fullchain.pem;
		ssl_certificate_key /var/lib/acme/omni/key.pem;
		ssl_trusted_certificate /var/lib/acme/omni/chain.pem;
		location / {
			proxy_pass http://127.0.0.1:8080;
			proxy_http_version 1.1;
			proxy_set_header Upgrade $http_upgrade;
			proxy_set_header Connection $connection_upgrade;
			grpc_pass grpc://127.0.0.1:8080;
		}
	}
	server {
		listen 0.0.0.0:443 http2 ssl ;
		listen [::0]:443 http2 ssl ;
		server_name api.$OMNI_DOMAIN ;
		ssl_certificate /var/lib/acme/omni_api/fullchain.pem;
		ssl_certificate_key /var/lib/acme/omni_api/key.pem;
		ssl_trusted_certificate /var/lib/acme/omni_api/chain.pem;
		location / {
			grpc_pass grpc://127.0.0.1:8090;
		}
	}
	server {
		listen 0.0.0.0:443 http2 ssl ;
		listen [::0]:443 http2 ssl ;
		server_name kube.$OMNI_DOMAIN ;
		ssl_certificate /var/lib/acme/omni_kube/fullchain.pem;
		ssl_certificate_key /var/lib/acme/omni_kube/key.pem;
		ssl_trusted_certificate /var/lib/acme/omni_kube/chain.pem;
		location / {
			proxy_pass http://127.0.0.1:8100;
			proxy_http_version 1.1;
			proxy_set_header Upgrade $http_upgrade;
			proxy_set_header Connection $connection_upgrade;
		}
	}
}
```

## How to use

The omni instance will be available at `https://$OMNI_DOMAIN/`, the API at `https://api.$OMNI_DOMAIN/` and the kubernetes proxy at `https://kube.$OMNI_DOMAIN/`.

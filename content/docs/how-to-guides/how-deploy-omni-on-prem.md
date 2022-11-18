---
title: "How Deploy Omni On-prem"
date: 2022-11-17T13:06:13-08:00
draft: false
---

This guide shows you how to deploy Omni on-prem.

First, you will need an Auth0 account.
On the account level, configure "Authentication - Social" to allow GitHub and Google login.
Create an Auth0 application of the type "single page web application".
Configure the Auth0 application with the following:

  - Allowed callback URLs: https://localhost:8099/
  - Allowed web origins: https://localhost:8099/
  - Allowed logout URLs: https://localhost:8099/

Disable username/password auth on "Authentication - Database - Applications" tab.
Enable GitHub and Google login on the "Authentication - Social" tab.
Enable email access in the GitHub settings.
Take note of the following information from the Auth0 application:
  - Domain
  - Client ID

Generate a TLS certificate:

```bash
openssl req -new -newkey rsa:4096 -x509 -sha256 -days 365 -subj '/CN=localhost' -nodes -out /etc/ssl/certs/localhost.pem -keyout /etc/ssl/certs/localhost-key.pem
```

Configure a Nginx:

```nginx
events {}

http {
    map $http_upgrade $connection_upgrade {
        default upgrade;
        '' close;
    }

    map $http_x_request_id $req_id {
        default $http_x_request_id;
        "" $request_id;
    }

    server {
        # API and frontend.
        listen 8099 ssl http2;
        server_name localhost;

        ssl_certificate /etc/ssl/certs/localhost.pem;
        ssl_certificate_key /etc/ssl/certs/localhost-key.pem;

        location / {
            client_max_body_size 4m;

            # Pass the extracted client certificate to the backend

            # Allow websocket connections
            grpc_set_header Upgrade $http_upgrade;

            grpc_set_header Connection $connection_upgrade;

            grpc_set_header X-Request-ID $req_id;
            grpc_set_header X-Real-IP $remote_addr;

            grpc_set_header X-Forwarded-For $remote_addr;

            grpc_set_header X-Forwarded-Host $http_host;
            grpc_set_header X-Forwarded-Port $server_port;
            grpc_set_header X-Forwarded-Proto $scheme;
            grpc_set_header X-Forwarded-Scheme $scheme;

            grpc_set_header X-Scheme $scheme;

            # Pass the original X-Forwarded-For
            grpc_set_header X-Original-Forwarded-For $http_x_forwarded_for;

            # mitigate HTTPoxy Vulnerability
            # https://www.nginx.com/blog/mitigating-the-httpoxy-vulnerability-with-nginx/
            grpc_set_header Proxy "";

            grpc_read_timeout 3600s;

            # Custom headers to proxied server

            proxy_connect_timeout 1200s;
            proxy_send_timeout 1200s;

            proxy_buffering off;
            proxy_buffer_size 4k;
            proxy_buffers 4 4k;

            proxy_max_temp_file_size 0;

            proxy_request_buffering on;
            proxy_http_version 1.1;

            proxy_cookie_domain off;
            proxy_cookie_path off;

            proxy_pass http://localhost:8080;

            proxy_redirect off;
        }
    }

    server {
        # Kubernetes API proxy.
        listen 8098 ssl;
        server_name localhost;

        ssl_certificate /etc/ssl/certs/localhost.pem;
        ssl_certificate_key /etc/ssl/certs/localhost-key.pem;

        location / {
            proxy_pass http://localhost:8095;
            proxy_connect_timeout 1200s;
            proxy_send_timeout 1200s;

            proxy_buffering off;
            proxy_buffer_size 4k;
            proxy_buffers 4 4k;

            proxy_max_temp_file_size 0;

            proxy_request_buffering off;
            proxy_http_version 1.1;

            proxy_cookie_domain off;
            proxy_cookie_path off;
            proxy_redirect off;

            proxy_set_header Connection $http_connection;
            proxy_set_header Upgrade $http_upgrade;
        }
    }

    server {
        # SideroLink API.
        listen 8090 ssl;
        server_name localhost;

        ssl_certificate /etc/ssl/certs/localhost.pem;
        ssl_certificate_key /etc/ssl/certs/localhost-key.pem;

        location / {
            proxy_pass http://localhost:8090;
            proxy_connect_timeout 1200s;
            proxy_send_timeout 1200s;

            proxy_buffering off;
            proxy_buffer_size 4k;
            proxy_buffers 4 4k;

            proxy_max_temp_file_size 0;

            proxy_request_buffering off;
            proxy_http_version 1.1;

            proxy_cookie_domain off;
            proxy_cookie_path off;
            proxy_redirect off;

            proxy_set_header Connection $http_connection;
            proxy_set_header Upgrade $http_upgrade;
        }
    }
}
```

Generate a GPG key with the following:

```bash
gpg --quick-generate-key "Omni (Used for etcd data encryption) <email address>" rsa4096 cert never
```

Ensure that `docker` is installed on the same machine as `omni`.

Finally, run `omni`:

```bash
omni \
  --account-id=<UUID>
  --name=example
  --bind-addr=127.0.0.1:8080
  --advertised-api-url=https://<public ip address of the host running Omni>:8099/
  --advertised-kubernetes-proxy-url=https://<public ip address of the host running Omni>:8098/
  --siderolink-api-advertised-url=https://<public ip address of the host running Omni>:8090/
  --siderolink-api-bind-addr=127.0.0.1:8090
  --k8s-proxy-bind-addr=127.0.0.1:8095
  --siderolink-wireguard-advertised-addr=<public ip address of the host running Omni>:50180
  --private-key-source=file://<path to generated GPG key>
  --public-key-files=/public-keys/break-glass.asc
  --auth-auth0-enabled=true
  --auth-auth0-domain=<Auth0 domain>
  --auth-auth0-client-id=<Auth0 client ID>
  --initial-users=<email addresses>
```

{{% alert title="Note" color="info" %}}
Configuration options are available in the help menu: `omni --help`.
{{% /alert %}}

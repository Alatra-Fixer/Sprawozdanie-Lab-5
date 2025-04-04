# Sprawozdanie-Lab-5


# Logi konsoli Powershell

```powershell
Windows PowerShell
Copyright (C) Microsoft Corporation. All rights reserved.

Install the latest PowerShell for new features and improvements! https://aka.ms/PSWindows

PS C:\Users\Rafał> mkdir C:\multi-stage-app


    Directory: C:\


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----         4.04.2025     10:26                multi-stage-app


PS C:\Users\Rafał> cd C:\multi-stage-app
PS C:\multi-stage-app> notepad app.sh
PS C:\multi-stage-app> notepad Dockerfile

PS C:\multi-stage-app> Get-Content app.sh | Set-Content -NoNewline app-fixed.sh
PS C:\multi-stage-app> mv app-fixed.sh app.sh
mv : Nie można utworzyć pliku, który już istnieje.
At line:1 char:1
+ mv app-fixed.sh app.sh
+ ~~~~~~~~~~~~~~~~~~~~~~
    + CategoryInfo          : WriteError: (C:\multi-stage-app\app-fixed.sh:FileInfo) [Move-Item], IOException
    + FullyQualifiedErrorId : MoveFileInfoItemIOError,Microsoft.PowerShell.Commands.MoveItemCommand


PS C:\multi-stage-app> mv -Force app-fixed.sh app.sh

PS C:\multi-stage-app> ls


    Directory: C:\multi-stage-app


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----         4.04.2025     10:53            329 app.sh
-a----         4.04.2025     10:28            390 Dockerfile



PS C:\multi-stage-app> cat -v Dockerfile
# Etap 1 - Budowanie aplikacji
FROM alpine AS builder
ARG VERSION="1.0.0"
RUN apk add --no-cache bash coreutils
COPY app.sh /app.sh
RUN chmod +x /app.sh

# Etap 2 - Serwer HTTP
FROM nginx:alpine

# Kopiowanie skryptu do kontenera
COPY --from=builder /app.sh /app.sh

# Ustawienie entrypoint, aby generowaÄ‡ stronÄ™ HTML przy starcie kontenera
ENTRYPOINT ["/bin/sh", "-c", "/app.sh $VERSION && exec nginx -g 'daemon off;'"]

# HEALTHCHECK
HEALTHCHECK --interval=30s --timeout=10s \
  CMD wget --spider -q http://localhost || exit 1
PS C:\multi-stage-app> cat -v app.sh
#!/bin/sh

VERSION=$1
IP=$(hostname -i || echo "Unknown IP")
HOST=$(hostname || echo "Unknown Host")

cat <<EOF > /usr/share/nginx/html/index.html
<html>
  <head><title>Info Page</title></head>
  <body>
    <h1>Web App Info</h1>
    <p><strong>IP address:</strong> $IP</p>
    <p><strong>Hostname:</strong> $HOST</p>
    <p><strong>App version:</strong> $VERSION</p>
  </body>
</html>
EOF
PS C:\multi-stage-app> ls -l app.sh


    Directory: C:\multi-stage-app


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----         4.04.2025     11:03            406 app.sh



PS C:\multi-stage-app> docker build -t my-multistage-app --build-arg VERSION=2.1.0 .
[+] Building 1.8s (14/14) FINISHED                                                                                                      docker:desktop-linux
 => [internal] load build definition from Dockerfile                                                                                                    0.0s
 => => transferring dockerfile: 589B                                                                                                                    0.0s
 => [internal] load metadata for docker.io/library/nginx:alpine                                                                                         1.3s
 => [internal] load metadata for docker.io/library/alpine:latest                                                                                        1.3s
 => [auth] library/nginx:pull token for registry-1.docker.io                                                                                            0.0s
 => [auth] library/alpine:pull token for registry-1.docker.io                                                                                           0.0s
 => [internal] load .dockerignore                                                                                                                       0.0s
 => => transferring context: 2B                                                                                                                         0.0s
 => [builder 1/4] FROM docker.io/library/alpine:latest@sha256:a8560b36e8b8210634f77d9f7f9efd7ffa463e380b75e2e74aff4511df3ef88c                          0.0s
 => CACHED [stage-1 1/2] FROM docker.io/library/nginx:alpine@sha256:4ff102c5d78d254a6f0da062b3cf39eaf07f01eec0927fd21e219d0af8bc0591                    0.0s
 => [internal] load build context                                                                                                                       0.0s
 => => transferring context: 424B                                                                                                                       0.0s
 => CACHED [builder 2/4] RUN apk add --no-cache bash coreutils                                                                                          0.0s
 => [builder 3/4] COPY app.sh /app.sh                                                                                                                   0.0s
 => [builder 4/4] RUN chmod +x /app.sh                                                                                                                  0.3s
 => [stage-1 2/2] COPY --from=builder /app.sh /app.sh                                                                                                   0.0s
 => exporting to image                                                                                                                                  0.0s
 => => exporting layers                                                                                                                                 0.0s
 => => writing image sha256:21d7d6f013074bb0299815a4b63976b7ede953b302f8aeeb1dd7d820ab95abae                                                            0.0s
 => => naming to docker.io/library/my-multistage-app                                                                                                    0.0s

View build details: docker-desktop://dashboard/build/desktop-linux/desktop-linux/vpktruni4n4nnov8j7opcnenn
PS C:\multi-stage-app> docker run -d -p 8080:80 my-multistage-app
dea99ee541e62f24f2bbf32ea4b3357c1a8a211e6bc87dc31b1ddc746bdf326f
PS C:\multi-stage-app> docker ps
CONTAINER ID   IMAGE               COMMAND                  CREATED          STATUS                             PORTS                  NAMES
dea99ee541e6   my-multistage-app   "/bin/sh -c '/app.sh…"   17 seconds ago   Up 16 seconds (health: starting)   0.0.0.0:8080->80/tcp   confident_gould
PS C:\multi-stage-app> docker ps
CONTAINER ID   IMAGE               COMMAND                  CREATED          STATUS                             PORTS                  NAMES
dea99ee541e6   my-multistage-app   "/bin/sh -c '/app.sh…"   32 seconds ago   Up 32 seconds (health: starting)   0.0.0.0:8080->80/tcp   confident_gould
PS C:\multi-stage-app> docker ps
CONTAINER ID   IMAGE               COMMAND                  CREATED         STATUS                     PORTS                  NAMES
dea99ee541e6   my-multistage-app   "/bin/sh -c '/app.sh…"   3 minutes ago   Up 3 minutes (unhealthy)   0.0.0.0:8080->80/tcp   confident_gould
```

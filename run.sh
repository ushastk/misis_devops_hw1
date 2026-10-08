
#!/bin/bash
set -e

docker rm -f gromova-09-web gromova-09-db 2>/dev/null || true

docker build --build-arg VERSION=2.0 -t gromova-09/probe:2.0 .

docker volume create gromova-09-data

docker run -d \
  --name gromova-09-db \
  -e POSTGRES_PASSWORD=lab \
  -e POSTGRES_DB=lab \
  -p 8029:5432 \
  -v gromova-09-data:/var/lib/postgresql/data \
  postgres:16-alpine

docker run -d \
  --name gromova-09-web \
  --add-host host.docker.internal:host-gateway \
  -e APP_PORT=5009 \
  -e DATABASE_URL=postgresql://postgres:lab@host.docker.internal:8029/lab \
  -p 8027:5009 \
  gromova-09/probe:2.0

SECONDS=0
until curl -sf -m 3 localhost:8027/notes > /dev/null || [ $SECONDS -ge 60 ]; do
  sleep 2
done

curl -s localhost:8027/notes
echo

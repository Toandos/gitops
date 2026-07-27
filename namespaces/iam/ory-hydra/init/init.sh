#!/bin/sh
set -e

echo "Applying migrations..."
hydra migrate sql -e --yes --config /etc/config/hydra.yml
echo "Migrations applied"

echo "Waiting for Hydra"
until wget -qO- http://hydra:4445/health/ready >/dev/null 2>&1
do
    sleep 1
done
echo "Hydra is ready"

## Create clients

# Dashboard
if ! hydra get oauth2-client dashboard --endpoint http://hydra:4445 >/dev/null 2>&1
then
    echo "Creating Dashboard OAuth client"
    hydra create oauth2-client \
        --endpoint http://hydra:4445 \
        --id dashboard \
        --secret dashboard_secret \
        --name "Dasboard" \
        --grant-type authorization_code \
        --response-type code \
        --scope "openid profile email offline_access" \
        --redirect-uri "https://dash.toando.de/auth/callback" \
        --skip-consent
else
    echo "Dashboard client already exists"
fi
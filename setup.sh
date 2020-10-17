#!/bin/sh

set -x

# ToDo:
# caprover/caprover
# titpetric/netdata:1.8 : TODO LATER
# caprover/caprover-placeholder-app:latest
# nginx:1
# caprover/certbot-sleeping:v1.5.0

#Parameters
PLATFORM_NAME='arm64v8'

CAPROVER_GIT='https://github.com/caprover/caprover.git'
CAPROVER_GIT_BRANCH='release'

CAPROVER_CERTBOT_GIT='https://github.com/caprover/certbot-sleeping.git'
CAPROVER_CERTBOT_GIT_BRANCH='master'

CAPROVER_PLACEHOLDER_GIT='https://github.com/caprover/caprover-placeholder-app.git'
CAPROVER_PLACEHOLDER_GIT_BRANCH='master'

#images
DOCKER_NODEJS="arm64v8/node:14"
DOCKER_NGINX="arm64v8/nginx:1"
DOCKER_NGINX_ALPINE="arm64v8/nginx:1-alpine"
DOCKER_CERTBOT="certbot/certbot:arm64v8-v1.9.0"

DOCKER_CAPROVER_NAME='lowhuhn/caprover'
DOCKER_CAPROVER_VERSION='1.8.0'
DOCKER_CAPROVER="${DOCKER_CAPROVER_NAME}:${DOCKER_CAPROVER_VERSION}"
DOCKER_CAPROVER_CERTBOT='lowhuhn/certbot-sleeping:arm64v8-v1.9.0'
DOCKER_CAPROVER_PLACEHOLDER='lowhuhn/caprover-placeholder-app:latest'


#FOLDERS 
TMP='sources'
TMP_CAPROVER="$TMP/caprover"
TMP_CERTBOT="$TMP/certbot"
TMP_PLACEHOLDER="$TMP/placeholder"


#Setup Stage
mkdir -p $TMP
#Git Stage
git clone -b $CAPROVER_CERTBOT_GIT_BRANCH $CAPROVER_CERTBOT_GIT $TMP_CERTBOT
git clone -b $CAPROVER_GIT_BRANCH $CAPROVER_GIT $TMP_CAPROVER
git clone -b $CAPROVER_PLACEHOLDER_GIT_BRANCH $CAPROVER_PLACEHOLDER_GIT $TMP_PLACEHOLDER

# caprover/certbot-sleeping =====================================================================
DOCKERFILE_CAPROVER_CERTBOT="Dockerfile.arm64v8"
SED_DOCKER_CERTBOT=$(printf '%s\n' "$DOCKER_CERTBOT" | sed -e 's/[]\/$*.^[]/\\&/g');
sed "1s/.*/FROM ${SED_DOCKER_CERTBOT}/" \
    "$TMP_CERTBOT/Dockerfile" \
    > "${TMP_CERTBOT}/${DOCKERFILE_CAPROVER_CERTBOT}"


# caprover/caprover-placeholder-app =============================================================
DOCKERFILE_CAPROVER_PLACEHOLDER="Dockerfile.arm64v8"
SED_DOCKER_NGINX_ALPINE=$(printf '%s\n' "$DOCKER_NGINX_ALPINE" | sed -e 's/[]\/$*.^[]/\\&/g');
sed "1s/.*/FROM ${SED_DOCKER_NGINX_ALPINE}/" \
    "$TMP_PLACEHOLDER/Dockerfile" \
    > "${TMP_PLACEHOLDER}/${DOCKERFILE_CAPROVER_PLACEHOLDER}"


# #CAPROVER / CAPROVER 
DOCKERFILE_CAPROVER="dockerfile-captain.release-arm64v8"
# FILE_DOCKER_CAPROVER_NEW="$TMP_CAPROVER/dockerfile-captain.release.$PLATFORM_NAME"
SED_DOCKER_NODEJS=$(printf '%s\n' "$DOCKER_NODEJS" | sed -e 's/[]\/$*.^[]/\\&/g');

sed "1s/.*/FROM ${SED_DOCKER_NODEJS}/" \
    "$TMP_CAPROVER/dockerfile-captain.release" \
    > "${TMP_CAPROVER}/${DOCKERFILE_CAPROVER}"

SED_DOCKER_CAPROVER_N=$(printf '%s\n' "$DOCKER_CAPROVER_NAME" | sed -e 's/[]\/$*.^[]/\\&/g');
SED_DOCKER_CAPROVER_V=$(printf '%s\n' "$DOCKER_CAPROVER_VERSION" | sed -e 's/[]\/$*.^[]/\\&/g');
SED_DOCKER_CAPROVER_CERTBOT=$(printf '%s\n' "$DOCKER_CAPROVER_CERTBOT" | sed -e 's/[]\/$*.^[]/\\&/g');
SED_DOCKER_CAPROVER_PLACEHOLDER=$(printf '%s\n' "$DOCKER_CAPROVER_PLACEHOLDER" | sed -e 's/[]\/$*.^[]/\\&/g');
SED_DOCKER_NGINX=$(printf '%s\n' "$DOCKER_NGINX" | sed -e 's/[]\/$*.^[]/\\&/g');

sed -i '.bak' \
    "s/.*publishedNameOnDockerHub.*/publishedNameOnDockerHub: \'${SED_DOCKER_CAPROVER_N}\',/" \
    "$TMP_CAPROVER/src/utils/CaptainConstants.ts" 
# sed -i ".bak" \
#     "s/ version.*/version: \'${SED_DOCKER_CAPROVER_V}\',/" \
#     "$TMP_CAPROVER/src/utils/CaptainConstants.ts" 
sed -i '.bak' \
    "s/.*appPlaceholderImageName.*/appPlaceholderImageName: \'${SED_DOCKER_CAPROVER_PLACEHOLDER}\',/" \
    "$TMP_CAPROVER/src/utils/CaptainConstants.ts" 
sed -i '.bak' \
    "s/.*certbotImageName.*/certbotImageName: \'${SED_DOCKER_CAPROVER_CERTBOT}\',/" \
    "$TMP_CAPROVER/src/utils/CaptainConstants.ts" 
sed -i '.bak' \
    "s/.*nginxImageName.*/nginxImageName: \'${SED_DOCKER_NGINX}\',/" \
    "$TMP_CAPROVER/src/utils/CaptainConstants.ts" 

rm -f "$TMP_CAPROVER/src/utils/CaptainConstants.ts.bak"

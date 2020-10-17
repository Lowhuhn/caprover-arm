
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

DOCKERFILE_CAPROVER_CERTBOT="Dockerfile.arm64v8"
DOCKERFILE_CAPROVER_PLACEHOLDER="Dockerfile.arm64v8"
DOCKERFILE_CAPROVER="dockerfile-captain.release-arm64v8"

#FOLDERS 
TMP='sources'
TMP_CAPROVER="$TMP/caprover"
TMP_CERTBOT="$TMP/certbot"
TMP_PLACEHOLDER="$TMP/placeholder"

#Docker Builds
CURRENT_PATH=`pwd`

cd $TMP_CERTBOT
docker build -t $DOCKER_CAPROVER_CERTBOT -f $DOCKERFILE_CAPROVER_CERTBOT .
cd $CURRENT_PATH

cd $TMP_PLACEHOLDER
docker build -t $DOCKER_CAPROVER_PLACEHOLDER -f $DOCKERFILE_CAPROVER_PLACEHOLDER .
cd $CURRENT_PATH

cd $TMP_CAPROVER
docker build -t $DOCKER_CAPROVER -t "$DOCKER_CAPROVER_NAME:latest" -f $DOCKERFILE_CAPROVER .
cd $CURRENT_PATH

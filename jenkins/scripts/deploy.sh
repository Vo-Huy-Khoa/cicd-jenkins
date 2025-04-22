echo "Deploy app - tag $TAG"

#Enable debugging mode
set -x

chmod 400 $SERVER_SSH_KEY_FILE

#Deploy
ssh -i $SERVER_SSH_KEY_FILE $SERVER_USERNAME@$SERVER_URL '
  cd khoacodedao-rebuild
  git pull
  docker compose stop
  docker compose pull
  docker compose up -d
'

OUT=$?

#Disable debugging mode
set +x

if [ $OUT -eq 0 ]; then
  echo 'Deploy: Successful'
  exit 0
else
  echo 'Deploy: Failed'
  exit 1
fi
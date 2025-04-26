echo "Deploy app - tag $TAG"

#Enable debugging mode
set -x

chmod 400 $SERVER_SSH_KEY_FILE


ssh -i $SERVER_SSH_KEY_FILE 'ubuntu@54.169.122.225'

#Upload
scp -i $SERVER_SSH_KEY_FILE build.zip  $SERVER_USERNAME@$SERVICE_NAME://home/$SERVER_USERNAME/cicd-jenkins/build.zip
scp -i $SERVER_SSH_KEY_FILE package.json $SERVER_USERNAME@$SERVICE_NAME://home/$SERVER_USERNAME/cicd-jenkins/package.json
scp -i $SERVER_SSH_KEY_FILE yarn.lock $SERVER_USERNAME@$SERVICE_NAME://home/$SERVER_USERNAME/cicd-jenkins/yarn.lock
# scp -i $SERVER_SSH_KEY_FILE $ENV_FILE $SERVER_USERNAME@$SERVICE_NAME://home/$SERVER_USERNAME/cicd-jenkins/.env

#Deploy
ssh -i $SERVER_SSH_KEY_FILE $SERVER_USERNAME@$SERVICE_NAME '
  cd cicd-jenkins
  export PATH=$PATH:/home/ubuntu/.nvm/versions/node/v20.11.0/bin
  npm install
  pm2 stop cicd-jenkins
  rm -R build
  unzip build.zip
  rm -R build.zip
  pm2 restart cicd-jenkins --update-env --log-date-format "YYYY-MM-DD HH:mm:ss.SSS"
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
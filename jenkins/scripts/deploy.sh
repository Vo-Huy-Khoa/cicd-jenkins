echo "Deploy app - tag $TAG"

# Enable debugging mode
set -x

# Set file permissions for SSH key
chmod 400 $SERVER_SSH_KEY_FILE

# SSH into the server with StrictHostKeyChecking set to no
ssh -i $SERVER_SSH_KEY_FILE -o StrictHostKeyChecking=no ubuntu@54.169.122.225

# Upload files using SCP
scp -i $SERVER_SSH_KEY_FILE output.zip  $SERVER_USERNAME@$SERVICE_NAME:/home/$SERVER_USERNAME/cicd-jenkins/output.zip
scp -i $SERVER_SSH_KEY_FILE package.json $SERVER_USERNAME@$SERVICE_NAME:/home/$SERVER_USERNAME/cicd-jenkins/package.json
scp -i $SERVER_SSH_KEY_FILE yarn.lock $SERVER_USERNAME@$SERVICE_NAME:/home/$SERVER_USERNAME/cicd-jenkins/yarn.lock

# Deploy the app
ssh -i $SERVER_SSH_KEY_FILE $SERVER_USERNAME@$SERVICE_NAME '
  cd cicd-jenkins
  export PATH=$PATH:/home/ubuntu/.nvm/versions/node/v20.11.0/bin
  npm install
  sudo pm2 stop cicd-jenkins
  rm -rf .output
  unzip output.zip
  rm -f output.zip
  sudo pm2 restart cicd-jenkins --update-env --log-date-format "YYYY-MM-DD HH:mm:ss.SSS"
'

OUT=$?

# Disable debugging mode
set +x

# Check if deployment was successful
if [ $OUT -eq 0 ]; then
  echo 'Deploy: Successful'
  exit 0
else
  echo 'Deploy: Failed'
  exit 1
fi

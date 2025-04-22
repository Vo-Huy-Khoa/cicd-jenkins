echo "Deploy app - tag $TAG"

#Enable debugging mode
set -x
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
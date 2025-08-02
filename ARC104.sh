# Materi
# Create all resources based on the information
export HTTP_FUNCTION=
export FUNCTION_NAME=
export REGION=

# Execute the following command to enable all necessary services.
gcloud services enable \
  artifactregistry.googleapis.com \
  cloudfunctions.googleapis.com \
  cloudbuild.googleapis.com \
  eventarc.googleapis.com \
  run.googleapis.com \
  logging.googleapis.com \
  pubsub.googleapis.com

# PROJECT_NUMBER=$(gcloud projects list --filter="project_id:$DEVSHELL_PROJECT_ID" --format='value(project_number)')
# SERVICE_ACCOUNT=$(gsutil kms serviceaccount -p $PROJECT_NUMBER)

# gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID \
#   --member serviceAccount:$SERVICE_ACCOUNT \
#   --role roles/pubsub.publisher

# To use Cloud Storage functions, first grant the pubsub.publisher IAM role to the Cloud Storage service account
export PROJECT_ID=$(gcloud config get-value project)

PROJECT_NUMBER=$(gcloud projects list --filter="project_id:$PROJECT_ID" --format='value(project_number)')
SERVICE_ACCOUNT=$(gsutil kms serviceaccount -p $PROJECT_NUMBER)

gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member serviceAccount:$SERVICE_ACCOUNT \
  --role roles/pubsub.publisher

# Task 1. Create a Cloud Storage bucket
gsutil mb -l $REGION gs://$DEVSHELL_PROJECT_ID

# Task 2. Create, deploy, and test a Cloud Storage function
export BUCKET="gs://$DEVSHELL_PROJECT_ID"

# Run the following command to create the folder and files for the app and navigate to the folder:
mkdir ~/$FUNCTION_NAME && cd $_
touch index.js && touch package.json

# add the following code to the hello-http/index.js file that simply responds to HTTP requests:
cat > index.js <<EOF
const functions = require('@google-cloud/functions-framework');
functions.cloudEvent('$FUNCTION_NAME', (cloudevent) => {
  console.log('A new event in your Cloud Storage bucket has been logged!');
  console.log(cloudevent);
});
EOF

# Add the following content to the hello-http/package.json file to specify the dependencies.
cat > package.json <<EOF
{
  "name": "nodejs-functions-gen2-codelab",
  "version": "0.0.1",
  "main": "index.js",
  "dependencies": {
    "@google-cloud/functions-framework": "^2.0.0"
  }
}
EOF

# In Cloud Shell, run the following command to deploy the function and enter y for the unauthenticated invocations pop-up:
gcloud functions deploy $FUNCTION_NAME \
  --gen2 \
  --runtime nodejs20 \
  --entry-point $FUNCTION_NAME \
  --source . \
  --region $REGION \
  --trigger-bucket $BUCKET \
  --trigger-location $REGION \
  --max-instances 2

# Task 3. Create and deploy a HTTP function with minimum instances
cd ..

mkdir ~/HTTP_FUNCTION && cd $_
touch index.js && touch package.json

cat > index.js <<EOF
const functions = require('@google-cloud/functions-framework');
functions.http('$HTTP_FUNCTION', (req, res) => {
  res.status(200).send('HTTP function (2nd gen) has been called!');
});
EOF

cat > package.json <<EOF
{
  "name": "nodejs-functions-gen2-codelab",
  "version": "0.0.1",
  "main": "index.js",
  "dependencies": {
    "@google-cloud/functions-framework": "^2.0.0"
  }
}
EOF

gcloud functions deploy $HTTP_FUNCTION \
  --gen2 \
  --runtime nodejs20 \
  --entry-point $HTTP_FUNCTION \
  --source . \
  --region $REGION \
  --trigger-http \
  --timeout 600s \
  --max-instances 2 \
  --min-instances 1
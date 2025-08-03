# Task 1. Create a bucket
# 1. Use commands (CLI/SDK) to create a bucket called wild-bucket-qwiklabs-gcp-03-70b7f24b7432 for the storage of the photographs.
export REGION=us-central1
export BUCKET_NAME=wild-bucket-qwiklabs-gcp-03-70b7f24b7432
gsutil mb -l $REGION gs://$BUCKET_NAME


# Task 2. Create a Pub/Sub topic
# 1. Use the command line to create a Pub/Sub topic called wild-topic-810 for the Cloud Function to send messages.
export TOPIC_NAME=wild-topic-810
gcloud pubsub topics create $TOPIC_NAME


# Task 3. Create the thumbnail Cloud Function
# Note: You must upload one JPG or PNG image into the bucket to verify the thumbnail was created (after creating the function successfully). Use this image https://storage.googleapis.com/cloud-training/arc102/wildlife.jpg; download the image to your machine and then upload that file to your bucket. You will see a thumbnail image appear shortly afterwards (use REFRESH in the bucket details).
wget https://storage.googleapis.com/cloud-training/arc102/wildlife.jpg
gsutil cp wildlife.jpg gs://$BUCKET_NAME
gcloud services enable \
  artifactregistry.googleapis.com \
  cloudfunctions.googleapis.com \
  cloudbuild.googleapis.com \
  eventarc.googleapis.com \
  run.googleapis.com \
  logging.googleapis.com \
  pubsub.googleapis.com
export PROJECT_ID=$(gcloud config get-value project)
PROJECT_NUMBER=$(gcloud projects list --filter="project_id:$PROJECT_ID" --format='value(project_number)')
SERVICE_ACCOUNT=$(gsutil kms serviceaccount -p $PROJECT_NUMBER)
gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member serviceAccount:$SERVICE_ACCOUNT \
  --role roles/pubsub.publisher
# 1. Use the command line to create a Cloud Function called wild-thumbnail-maker that executes every time an object is created in the bucket wild-bucket-qwiklabs-gcp-03-70b7f24b7432 you created in task 1.
# 2. Make sure you set the Entry point (Function to execute) to thumbnail and Trigger to Cloud Storage.
# 3. In line 15 of index.js replace the text REPLACE_WITH_YOUR_TOPIC ID with the wild-topic-810 you created in task 2.
nano index.js  # In line 15 of index.js replace the text REPLACE_WITH_YOUR_TOPIC ID
nano package.json
export FUNCTION_NAME=wild-thumbnail-maker
gcloud functions deploy $FUNCTION_NAME \
    --gen2 \
    --runtime nodejs20 \
    --entry-point thumbnail \
    --source . \
    --region $REGION \
    --trigger-bucket $BUCKET_NAME \
    --allow-unauthenticated \
    --trigger-location $REGION \
    --max-instances 5 \
    --quiet
# Task 1. Create a bucket
# 1. Create a bucket called memories-bucket-qwiklabs-gcp-03-8afba2d08b9d for the storage of the photographs. Ensure the resource is created in the us-central1 region.
export REGION=us-central1
export BUCKET_NAME=memories-bucket-qwiklabs-gcp-03-8afba2d08b9d
gsutil mb -l $REGION gs://$BUCKET_NAME


# Task 2. Create a Pub/Sub topic
# 1. Create a Pub/Sub topic called memories-topic-755 for the Cloud Run function to send messages.
export TOPIC_NAME=memories-topic-755
gcloud pubsub topics create $TOPIC_NAME


# Task 3. Create the thumbnail Cloud Run function
# Create a Cloud Run function memories-thumbnail-creator that will to create a thumbnail from an image added to the memories-bucket-qwiklabs-gcp-03-8afba2d08b9d bucket.
# Ensure the Cloud Run function is using the Cloud Run function environment (which is 2nd generation). Ensure the resource is created in the us-central1 region and us-central1-c zone.
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
# 1. Create a Cloud Run function (2nd generation) called memories-thumbnail-creator using Node.js 22 and setting the trigger to Cloud Storage.
# 2. Make sure you set the Entry point (Function to execute) to memories-thumbnail-creator.
# 3. Add the following lab code to the index.js
# 4. Add the following lab code to the package.json
nano index.js
nano package.json
export FUNCTION_NAME=memories-thumbnail-creator
gcloud functions deploy $FUNCTION_NAME \
  --gen2 \
  --runtime nodejs22 \
  --entry-point $FUNCTION_NAME \
  --source . \
  --region $REGION \
  --trigger-bucket $BUCKET_NAME \
  --trigger-location $REGION \
  --max-instances 1 \
  --quiet


# Task 4. Test the Infrastructure
# To test the function, upload a JPG or PNG image into the bucket.
# Note: You need to upload one JPG or PNG image into the bucket to verify the thumbnail was created (after creating the function successfully). Use any JPG or PNG image, or use this image https://storage.googleapis.com/cloud-training/arc101/travel.jpg by downloading the image to your machine and then uploading that file to your bucket.
# 1. Upload a PNG or JPG image to memories-bucket-qwiklabs-gcp-03-8afba2d08b9d bucket.
wget https://storage.googleapis.com/cloud-training/arc101/travel.jpg
gsutil cp travel.jpg gs://$BUCKET_NAME
# 2. You will see a thumbnail image appear shortly afterwards (use REFRESH in the bucket details).

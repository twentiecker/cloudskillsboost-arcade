# export variable
export PROJECT_ID=$(gcloud config get-value project)
export BUCKET_NAME="${PROJECT_ID}-bucket"
export $TOPIC_ID=
export $REGION=
export $MESSAGE=

# re-enabled dataflow api
gcloud services disable dataflow.googleapis.com
gcloud services enable dataflow.googleapis.com

# Task 1. Create a Pub/Sub topic
gcloud pubsub topics create $TOPIC_ID

# Task 2. Create a Cloud Scheduler job
# app engine
gcloud app create --region=$REGION
# buat scheduler jobs (kalao enable api, pilih 'y')
gcloud scheduler jobs create pubsub quicklab --schedule="* * * * *" \
    --topic=$TOPIC_ID --message-body="$MESSAGE"
# running scheduler jobs
gcloud scheduler jobs run quicklab

# Task 3. Create a Cloud Storage bucket
gsutil mb gs://$BUCKET_NAME

# Task 4. Run a Dataflow pipeline to stream data from a Pub/Sub topic to Cloud Storage
# clone java code
git clone https://github.com/GoogleCloudPlatform/java-docs-samples.git
cd java-docs-samples/pubsub/streaming-analytics

# start pipeline
mvn compile exec:java \
-Dexec.mainClass=com.examples.pubsub.streaming.PubSubToGcs \
-Dexec.cleanupDaemonThreads=false \
-Dexec.args=" \
    --project=$PROJECT_ID \
    --region=$REGION \
    --inputTopic=projects/$PROJECT_ID/topics/$TOPIC_ID \
    --output=gs://$BUCKET_NAME/samples/output \
    --runner=DataflowRunner \
    --windowSize=2 \
    --tempLocation=gs://$BUCKET_NAME/temp"
# Streaming Analytics into BigQuery: Challenge Lab

---

## Task 1. Create a Cloud Storage bucket

#### Create a Cloud Storage bucket using your Project ID as the bucket name: qwiklabs-gcp-03-b068a8e32092

```bash
export REGION=<REGION>
```

```bash
export BUCKET_NAME=<BUCKET_NAME>
```

```bash
gsutil mb -l $REGION gs://$BUCKET_NAME
```

---

## Task 2. Create a BigQuery dataset and table

#### 1. Create a BigQuery dataset called sensors_725 in the region named US (multi region).

```bash
export DATASET_NAME=<DATASET_NAME>
```

```bash
bq mk $DATASET_NAME
```

#### 2. In the created dataset, create a table called temperature_653 and add column data with STRING type.

```bash
export TABLE_NAME=<TABLE_NAME>
```

```bash
bq mk --table \
$DEVSHEL_PROJECT_ID:$DATASET_NAME.$TABLE_NAME \
data:string
```

---

## Task 3. Set up a Pub/Sub topic

#### 1. Create a Pub/Sub topic called sensors-temp-57977.

```bash
export TOPIC_NAME=<TOPIC_NAME>
```

```bash
gcloud pubsub topics create $TOPIC_NAME
```

#### Use the default settings, which has enabled the checkbox for Add a default subscription.

```bash
gcloud pubsub subscriptions create $TOPIC_NAME-sub --topic=$TOPIC_NAME
```

---

## Task 4. Run a Dataflow pipeline to stream data from Pub/Sub to BigQuery

#### 1. Create and run a Dataflow job called dfjob-13809 to stream data from Pub/Sub topic to BigQuery, using the Pub/Sub topic and BigQuery table you created in the previous tasks.

#### Use the Custom Template.

#### Use the provided Path for the template file stored in Cloud Storage.

#### Use the Pub/Sub topic that you created in a previous task: sensors-temp-57977

#### Use the Cloud Storage bucket that you created in a previous task as the temporary location: qwiklabs-gcp-03-b068a8e32092

#### Use the BigQuery dataset and table that you created in a previous task as the output table: sensors_725.temperature_653

#### Use us-west1 as the regional endpoint.

```bash
gcloud dataflow jobs run dfjob-13809 --gcs-location gs://dataflow-templates-us-west1/latest/PubSub_to_BigQuery --region us-west1 --staging-location gs://qwiklabs-gcp-03-b068a8e32092/temp --additional-experiments streaming_mode_exactly_once --parameters outputTableSpec=qwiklabs-gcp-03-b068a8e32092:sensors_725.temperature_653,inputTopic=projects/qwiklabs-gcp-03-b068a8e32092/topics/sensors-temp-57977,javascriptTextTransformReloadIntervalMinutes=0
```

---

## Task 5. Publish a test message to the topic and validate data in BigQuery

#### 1. Publish a message to your topic using the following code syntax for Message: {"data": "73.4 F"}

```bash
gcloud pubsub topics publish $TOPIC_NAME --message='{"data": "73.4 F"}'
```

#### 2. Run a SELECT statement in BigQuery to see the test message populated in your table.

```bash
bq query --nouse_legacy_sql "SELECT \* FROM \`$DEVSHELL_PROJECT_ID.$DATASET_NAME.$TABLE_NAME\`"
```

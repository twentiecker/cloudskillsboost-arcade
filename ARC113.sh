# Form 1
# Publish a message to the topic
gcloud pubsub subscriptions create pubsub-subscription-message --topic gcloud-pubsub-topic

gcloud pubsub topics publish gcloud-pubsub-topic --message="Hello World"

# Task 2
# View the message
gcloud pubsub subscriptions pull pubsub-subscription-message --limit 5

# Task 3
# Create a Pub/Sub Snapshot for Pub/Sub topic
gcloud pubsub snapshots create pubsub-snapshot --subscription=gcloud-pubsub-subscription


# Form 2
export REGION=

# Task 1
# Create Pub/Sub schema
gcloud beta pubsub schemas create city-temp-schema \
    --type=avro \
    --definition='{
        "type": "record",
        "name": "Avro",
        "fields": [
            {
                "name": "city",
                "type": "string"
            },
            {
                "name": "temperature",
                "type": "double"
            },
            {
                "name": "pressure",
                "type": "int"
            },
            {
                "name": "time_position",
                "type": "string"
            }
        ]
    }'

# Task 2
# Create Pub/Sub topic using schema
gcloud pubsub topics create temp-topic \
    --message-encoding=JSON \
    --message-storage-policy-allowed-regions=$REGION \
    --schema=projects/$DEVSHELL_PROJECT_ID/schemas/temperature-schema

# Task 3
# Create a trigger cloud function with Pub/Sub topic
mkdir quicklab && cd $_
cat >index.js <<'EOF_END'
    /**
    * Triggered from a message on a Cloud Pub/Sub topic.
    *
    * @param {!Object} event Event payload.
    * @param {!Object} context Metadata for the event.
    */
    exports.helloPubSub = (event, context) => {
    const message = event.data
        ? Buffer.from(event.data, 'base64').toString()
        : 'Hello, World';
    console.log(message);
    };
EOF_END
cat >package.json <<'EOF_END'
    {
    "name": "sample-pubsub",
    "version": "0.0.1",
    "dependencies": {
        "@google-cloud/pubsub": "^0.18.0"
    }
    }
EOF_END
gcloud functions deploy gcf-pubsub \
    --trigger-topic=gcf-topic \
    --runtime=nodejs20 \
    --no-gen2 \
    --entry-point=helloPubSub \
    --source=. \
    --region=$REGION
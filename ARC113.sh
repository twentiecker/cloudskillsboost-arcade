# Task 1
# Publish a message to the topic
gcloud pubsub subscriptions create pubsub-subscription-message --topic gcloud-pubsub-topic

gcloud pubsub topics publish gcloud-pubsub-topic --message="Hello World"

# Task 2
# View the message
gcloud pubsub subscriptions pull pubsub-subscription-message --limit 5

# Task 3
# Create a Pub/Sub Snapshot for Pub/Sub topic
gcloud pubsub snapshots create pubsub-snapshot --subscription=gcloud-pubsub-subscription
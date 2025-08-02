#!/bin/bash

# Task 0. Set region
gcloud config set compute/region us-west1

# Task 1. Clone repo dan enable API
git clone https://github.com/googleapis/synthtool

cd synthtool/tests/fixtures/nodejs-dlp/samples/ || {
  echo "Gagal masuk ke direktori target"
  exit 1
}

npm install

# Set Project ID
read -p "Masukkan Project ID: " PROJECT_ID
export PROJECT_ID

# Set project aktif
gcloud config set project "$PROJECT_ID"

# Enable necessary APIs
gcloud services enable dlp.googleapis.com cloudkms.googleapis.com \
  --project "$PROJECT_ID"

# Task 2. Inspect strings and files
echo "Menjalankan inspectString.js..."
node inspectString.js "$PROJECT_ID" "My email address is jenny@somedomain.com and you can call me at 555-867-5309" > inspected-string.txt

echo "Hasil inspectString:"
cat inspected-string.txt

echo "Isi file accounts.txt:"
cat resources/accounts.txt

echo "Menjalankan inspectFile.js..."
node inspectFile.js "$PROJECT_ID" resources/accounts.txt > inspected-file.txt

echo "Hasil inspectFile:"
cat inspected-file.txt

# Upload hasil inspect ke Cloud Storage
echo "Mengunggah hasil inspect ke Cloud Storage..."
export BUCKET_NAME="${PROJECT_ID}-bucket"
gsutil cp inspected-string.txt gs://$BUCKET_NAME
gsutil cp inspected-file.txt gs://$BUCKET_NAME

# Task 3. De-identification
echo "Menjalankan deidentifyWithMask.js..."
node deidentifyWithMask.js "$PROJECT_ID" "My order number is F12312399. Email me at anthony@somedomain.com" > de-identify-output.txt

echo "Hasil de-identify:"
cat de-identify-output.txt

# Upload hasil de-identify ke Cloud Storage
echo "Mengunggah hasil de-identify ke Cloud Storage..."
gsutil cp de-identify-output.txt gs://$BUCKET_NAME

# Task 4. Redact strings and images
echo "Menjalankan redactText.js..."
node redactText.js "$PROJECT_ID" "Please refund the purchase to my credit card 4012888888881881" CREDIT_CARD_NUMBER > redacted-string.txt

echo "Hasil redactText:"
cat redacted-string.txt

echo "Menjalankan redactImage.js untuk PHONE_NUMBER..."
node redactImage.js "$PROJECT_ID" resources/test.png "" PHONE_NUMBER ./redacted-phone.png

echo "Menjalankan redactImage.js untuk EMAIL_ADDRESS..."
node redactImage.js "$PROJECT_ID" resources/test.png "" EMAIL_ADDRESS ./redacted-email.png

# Upload hasil redact ke Cloud Storage
echo "Mengunggah hasil redact ke Cloud Storage..."
gsutil cp redacted-string.txt gs://$BUCKET_NAME
gsutil cp redacted-phone.png gs://$BUCKET_NAME
gsutil cp redacted-email.png gs://$BUCKET_NAME

echo "Semua tugas selesai!"

# Task 1. Create two Cloud Storage buckets
# Create bucket1.json
cat > bucket1.json <<EOF
{  
   "name": "$DEVSHELL_PROJECT_ID-bucket-1",
   "location": "us",
   "storageClass": "multi_regional"
}
EOF
# Create bucket1
curl -X POST -H "Authorization: Bearer $(gcloud auth print-access-token)" -H "Content-Type: application/json" --data-binary @bucket1.json "https://storage.googleapis.com/storage/v1/b?project=$DEVSHELL_PROJECT_ID"
# Create bucket2.json
cat > bucket2.json <<EOF
{  
   "name": "$DEVSHELL_PROJECT_ID-bucket-2",
   "location": "us",
   "storageClass": "multi_regional"
}
EOF
# Create bucket2
curl -X POST -H "Authorization: Bearer $(gcloud auth print-access-token)" -H "Content-Type: application/json" --data-binary @bucket2.json "https://storage.googleapis.com/storage/v1/b?project=$DEVSHELL_PROJECT_ID"

# Task 2. Upload an image file to a Cloud Storage Bucket
# Download image from the lab and upload it to the cloudshell
curl -X POST -H "Authorization: Bearer $(gcloud auth print-access-token)" -H "Content-Type: image/jpeg" --data-binary @world.jpeg "https://storage.googleapis.com/upload/storage/v1/b/$DEVSHELL_PROJECT_ID-bucket-1/o?uploadType=media&name=quicklab.jpeg"

# Task 3. Copy a file to another bucket
curl -X POST -H "Authorization: Bearer $(gcloud auth print-access-token)" -H "Content-Type: application/json" --data '{"destination": "$DEVSHELL_PROJECT_ID-bucket-2"}' "https://storage.googleapis.com/storage/v1/b/$DEVSHELL_PROJECT_ID-bucket-1/o/quicklab.jpeg/copyTo/b/$DEVSHELL_PROJECT_ID-bucket-2/o/quicklab.jpeg"

# Task 4. Make an object (file) publicly accessible
cat > public_access.json <<EOF
{
  "entity": "allUsers",
  "role": "READER"
}
EOF
curl -X POST --data-binary @public_access.json -H "Authorization: Bearer $(gcloud auth print-access-token)" -H "Content-Type: application/json" "https://storage.googleapis.com/storage/v1/b/$DEVSHELL_PROJECT_ID-bucket-1/o/quicklab.jpeg/acl"

# Task 5. Delete the object file and a Cloud Storage bucket (Bucket 1)
# Delete file
curl -X DELETE -H "Authorization: Bearer $(gcloud auth print-access-token)" "https://storage.googleapis.com/storage/v1/b/$DEVSHELL_PROJECT_ID-bucket-1/o/quicklab.jpeg"
# Delete bucket1
curl -X DELETE -H "Authorization: Bearer $(gcloud auth print-access-token)" "https://storage.googleapis.com/storage/v1/b/$DEVSHELL_PROJECT_ID-bucket-1"
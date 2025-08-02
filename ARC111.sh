#form 2
export Bucket_1=
export Bucket_2=
export Bucket_3=
export USER_EMAIL=

# Task 1
# Create a Cloud storage bucket
gsutil mb -c nearline gs://$Bucket_1

# Task 2
# Publish Cloud Storage files to web
gcloud alpha storage buckets update gs://$Bucket_2 --no-uniform-bucket-level-access
gsutil acl ch -u $USER_EMAIL:OWNER gs://$Bucket_2
gsutil rm gs://$Bucket_2/sample.txt
echo "subscibe to quicklab" > sample.txt
gsutil cp sample.txt gs://$Bucket_2
gsutil acl ch -u allUsers:R gs://$Bucket_2/sample.txt

# Task 3
# Add labels to cloud storage bucket
gcloud storage buckets update gs://$Bucket_3 --update-labels=key=value

#form 3
export Bucket_1=
export Bucket_2=
export Bucket_3=

gsutil mb -c nearline gs://$Bucket_1

echo "This is an example of editing the file content for cloud storage object" | gsutil cp - gs://$Bucket_2/sample.txt

gsutil defstorageclass set ARCHIVE gs://$Bucket_3
#form 3
export Bucket_1=
export Bucket_2=
export Bucket_3=

gsutil mb -c nearline gs://$Bucket_1

echo "This is an example of editing the file content for cloud storage object" | gsutil cp - gs://$Bucket_2/sample.txt

gsutil defstorageclass set ARCHIVE gs://$Bucket_3
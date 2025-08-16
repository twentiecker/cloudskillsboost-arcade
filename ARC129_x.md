# Secure BigLake Data: Challenge Lab

---

## Task 1. Create a BigLake table using a Cloud Resource connection

#### 1. Create a BigQuery dataset named online_shop that is multi-region in the United States.

go to bigquery
click three dot and create dataset
fill name
leave the other defaulf and click create

#### 2. Create a Cloud Resource connection named user_data_connection (multi-region in the United States) and use it to create a BigLake table named user_online_sessions in the online_shop dataset.

click add data
type lake in search box
choose vertex AI > BigQuery Federation
fill connection id

#### Be sure to apply the appropriate service account permissions to read Cloud Storage files in your project.

goto iam
click grant access
paste service account from the connuser_data_connection
choose object storage viewer as role
save

#### When creating the table, load data from the following Cloud Storage file using schema auto-detection:

go to bigquery
go to dataset online_shop
click three dots and create table

---

## Task 2. Apply and verify policy tags on columns containing sensitive data

#### 1. Use the precreated taxonomy named taxonomy name to apply column-level policy tags on the table.

#### Apply the policy tag named sensitive-data-policy to the following columns in the user_online_sessions table:

> zip

> latitude

> ip_address

> longitude

#### 2. Verify the column-level security by running a query that omits the protected columns.

open the query editor
paste the query:

```bash
SELECT * EXCEPT(zip, latitude, ip_address, longitude)
FROM `YOUR_PROJECT_ID.online_shop.user_online_sessions`
```

## Task 3. Remove IAM permissions to Cloud Storage for other users

#### Follow Google best practices after migrating data to BigLake by removing IAM permissions for user 2 (User 2) to Cloud Storage.

1. Leave the IAM role for project viewer.
2. Remove only the IAM role for Cloud Storage

# Optimize Costs for Google Kubernetes Engine: Challenge Lab

---

## Task 1. Create a cluster and deploy your app

#### 1. Before you can deploy the application, you'll need to create a cluster in the us-west1-a zone, and name it as onlineboutique-cluster-288.

#### 2. Start small and make a zonal cluster with only two (2) nodes.

gcloud container clusters create $CLUSTER_NAME --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --machine-type=e2-standard-2 --num-nodes=2

#### 3. Before you deploy the shop, make sure to set up some namespaces to separate resources on your cluster in accordance with the 2 environments - dev and prod.

kubectl create namespace dev

kubectl create namespace prod

#### 4. After that, deploy the application to the dev namespace with the following command:

git clone https://github.com/GoogleCloudPlatform/microservices-demo.git &&
cd microservices-demo && kubectl apply -f ./release/kubernetes-manifests.yaml --namespace dev

---

## Task 2. Migrate to an optimized node pool

#### 1. After successfully deploying the app to the dev namespace, take a look at the node details:

#### You come to the conclusion that you should make changes to the cluster's node pool:

#### There's plenty of left over RAM from the current deployments so you should be able to use a node pool with machines that offer less RAM.

#### Most of the deployments that you might consider increasing the replica count of will require only 100mcpu per additional pod. You could potentially use a node pool with less total CPU if you configure it to use smaller machines. However, you also need to consider how many deployments will need to scale, and how much they need to scale by.

#### 2. Create a new node pool named optimized-pool-3698 with custom-2-3584 as the machine type.

#### 3. Set the number of nodes to 2.

gcloud container node-pools create $POOL_NAME --cluster=$CLUSTER_NAME --machine-type=custom-2-3584 --num-nodes=2 --zone=$ZONE

#### 4. Once the new node pool is set up, migrate your application's deployments to the new nodepool by cordoning off and draining default-pool.

for node in $(kubectl get nodes -l cloud.google.com/gke-nodepool=default-pool -o=name); do  kubectl cordon "$node"; done

for node in $(kubectl get nodes -l cloud.google.com/gke-nodepool=default-pool -o=name); do kubectl drain --force --ignore-daemonsets --delete-local-data --grace-period=10 "$node"; done

kubectl get pods -o=wide --namespace=dev

#### 5. Delete the default-pool once the deployments have safely migrated.

gcloud container node-pools delete default-pool --cluster $CLUSTER_NAME --zone $ZONE --quiet

---

## Task 3. Apply a frontend update

kubectl create poddisruptionbudget onlineboutique-frontend-pdb --selector app=frontend --min-available 1 --namespace dev

kubectl patch deployment frontend -n dev --type=json -p '[
{
"op": "replace",
"path": "/spec/template/spec/containers/0/image",
"value": "gcr.io/qwiklabs-resources/onlineboutique-frontend:v2.1"
},
{
"op": "replace",
"path": "/spec/template/spec/containers/0/imagePullPolicy",
"value": "Always"
}
]'

kubectl autoscale deployment frontend --cpu-percent=50 --min=1 --max=$MAX_REPLICAS --namespace dev

kubectl get hpa --namespace dev
ZONE=$ZONE

gcloud beta container clusters update $CLUSTER_NAME --enable-autoscaling --min-nodes 1 --max-nodes 6 --zone=$ZONE

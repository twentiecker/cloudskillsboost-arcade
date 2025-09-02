# Create a Machine Image for Instance Replication

## Challenge scenario

#### Assume you are a cloud engineer and you have a virtual machine (VM) instance in a zone on Google Cloud Platform. Your goal is to preserve the configuration, metadata, permissions, and disk data of this VM by creating a machine image. This machine image will serve as a snapshot of the current state of your VM and can be used for multiple purposes such as Single disk backup, Multiple disk backup, Differential backup and Instance cloning.

#### So your task is to create the machine image named <IMAGE_NAME> of the Google Compute Engine (GCE) VM instance named <VM_NAME> which is located in <ZONE> zone.

```bash
export IMAGE_NAME=<IMAGE_NAME>
```

```bash
export VM_NAME=<VM_NAME>
```

```bash
export ZONE=<ZONE>
```

```bash
gcloud compute machine-images create $IMAGE_NAME --source-instance=$VM_NAME --source-instance-zone=$ZONE
```

# Challenge scenario
# You work as a cloud administrator for a technology company that utilizes Google Cloud extensively for its operations. Today, you have been tasked with modifying a virtual machine (VM) instance to better align with updated resource requirements by using a specific General purpose Machine type with low cost.
# Currently, you have an existing VM instance named lab-vm with high cost. Your task is to update the machine type with e2-medium suitable for the VM instance with low cost.

# stop the config first
gcloud compute instances stop lab-vm --zone=us-east4-b
# setup machine type (update it)
gcloud compute instances set-machine-type lab-vm --machine-type e2-medium --zone=us-east4-b
# start vm
gcloud compute instances start lab-vm  --zone=us-east4-b
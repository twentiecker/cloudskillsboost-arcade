# Modify VM Instance for Cost Optimization

---

## Challenge scenario

#### You work as a cloud administrator for a technology company that utilizes Google Cloud extensively for its operations. Today, you have been tasked with modifying a virtual machine (VM) instance to better align with updated resource requirements by using a specific General purpose Machine type with low cost.

#### Currently, you have an existing VM instance named lab-vm with high cost. Your task is to update the machine type with e2-medium suitable for the VM instance with low cost.

```bash
export ZONE=<ZONE>
```

#### The VM must be stopped before changing its machine type.

```bash
gcloud compute instances stop lab-vm --zone=$ZONE
```

#### Modify the instance to use the desired machine type (e.g., e2-medium).

```bash
gcloud compute instances set-machine-type lab-vm --machine-type e2-medium --zone=$ZONE
```

#### Restart the instance to apply the changes.

```bash
gcloud compute instances start lab-vm --zone=$ZONE
```

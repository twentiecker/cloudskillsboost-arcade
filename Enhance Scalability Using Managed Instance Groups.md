# Enhance Scalability Using Managed Instance Groups

## Challenge scenario

#### As a cloud infrastructure administrator tasked with optimizing compute resource management on Google Cloud, you are required to create a managed instance group named "dev-instance-group" using a pre-existing instance template named "dev-instance-template". This initiative aims to streamline deployment, enhance scalability, and ensure to use below configurations.

> Autoscaling mode : ON

> Minimum number of instances : 1

> Maximum number of instances : 3

> CPU Utilization : 60%

```bash
gcloud compute instance-groups managed create dev-instance-group --template=dev-instance-template --size=1 --region=<REGION>
```

```bash
gcloud compute instance-groups managed set-autoscaling dev-instance-group --region=<REGION> --min-num-replicas=1 --max-num-replicas=3 --target-cpu-utilization=0.6 --mode=on
```

# Set Up a Google Cloud Network: Challenge Lab

---

## Task 1. Create networks

#### 1. Create a VPC network named vpc-network-kzrs with two subnets: subnet-a-fj9a and subnet-b-tupx. Use a Regional dynamic routing mode.

#### 2. For subnet-a-fj9a set the region to us-east1.

#### Set the IP stack type to IPv4 (single-stack)

#### Set IPv4 range to 10.10.10.0/24

#### 3. For subnet-b-tupx set the region to us-east4.

#### Set the IP stack type to IPv4 (single-stack)

#### Set IPv4 range to 10.10.20.0/24

gcloud compute networks create vpc-network-kzrs --project=qwiklabs-gcp-02-f27fa01197e2 --subnet-mode=custom --mtu=1460 --bgp-routing-mode=regional --bgp-best-path-selection-mode=legacy && gcloud compute networks subnets create subnet-a-fj9a --project=qwiklabs-gcp-02-f27fa01197e2 --range=10.10.10.0/24 --stack-type=IPV4_ONLY --network=vpc-network-kzrs --region=us-east1 && gcloud compute networks subnets create subnet-b-tupx --project=qwiklabs-gcp-02-f27fa01197e2 --range=10.10.20.0/24 --stack-type=IPV4_ONLY --network=vpc-network-kzrs --region=us-east4

---

## Task 2. Add firewall rules

#### On this network your team will need to be able to connect to Linux and Windows machines using SSH and RDP, as well as diagnose network communication issues via ICMP.

#### 1. Create a firewall rule named petm-firewall-ssh.

#### For the network, use vpc-network-kzrs.

#### Set the priority to 1000, the traffic to Ingress and action to Allow

#### The targets should be set to all instances in the network and the IPv4 ranges to 0.0.0.0/0

#### Set the Protocol to TCP and port to 22

gcloud compute --project=qwiklabs-gcp-02-f27fa01197e2 firewall-rules create petm-firewall-ssh --direction=INGRESS --priority=1000 --network=vpc-network-kzrs --action=ALLOW --rules=tcp:22 --source-ranges=0.0.0.0/0

#### 2. Create a firewall rule named lfng-firewall-rdp.

#### For the network, use vpc-network-kzrs.

#### Set the priority to 65535, the traffic to Ingress and action to Allow

#### The targets should be set to all instances in the network and the IPv4 ranges to 0.0.0.0/24

#### Set the Protocol to TCP and port to 3389

gcloud compute --project=qwiklabs-gcp-02-f27fa01197e2 firewall-rules create lfng-firewall-rdp --direction=INGRESS --priority=65535 --network=vpc-network-kzrs --action=ALLOW --rules=tcp:3389 --source-ranges=0.0.0.0/24

#### 3. Create a firewall rule named tukw-firewall-icmp.

#### For the network, use vpc-network-kzrs.

#### Set the priority to 1000, the traffic to Ingress and action to Allow

#### The targets should be set to all instances in the network and the IPv4 ranges to 10.10.10.0/24 and 10.10.20.0/24

#### Set the Protocol to icmp

gcloud compute --project=qwiklabs-gcp-02-f27fa01197e2 firewall-rules create tukw-firewall-icmp --direction=INGRESS --priority=1000 --network=vpc-network-kzrs --action=ALLOW --rules=PROTOCOL:PORT,... --source-ranges=10.10.10.0/24,10.10.20.0/24

---

## Task 3. Add VMs to your network

#### Create a virtual machine in each subnet, and confirm that the machines can communicate with each other using a protocol that you already set up. Each machine will use network tags that the firewall rules need to allow network traffic.

#### 1. Create an instance name us-test-01 in subnet-a-fj9a and set the zone to us-east1-d.

gcloud compute instances create us-test-01 --project=qwiklabs-gcp-02-f27fa01197e2 --zone=us-east1-d --machine-type=e2-medium --network-interface=network-tier=PREMIUM,stack-type=IPV4_ONLY,subnet=subnet-a-fj9a --metadata=enable-osconfig=TRUE,enable-oslogin=true --maintenance-policy=MIGRATE --provisioning-model=STANDARD --service-account=744529946695-compute@developer.gserviceaccount.com --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/trace.append --create-disk=auto-delete=yes,boot=yes,device-name=us-test-01,disk-resource-policy=projects/qwiklabs-gcp-02-f27fa01197e2/regions/us-east1/resourcePolicies/default-schedule-1,image=projects/debian-cloud/global/images/debian-12-bookworm-v20250812,mode=rw,size=10,type=pd-balanced --no-shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring --labels=goog-ops-agent-policy=v2-x86-template-1-4-0,goog-ec-src=vm_add-gcloud --reservation-affinity=any && printf 'agentsRule:\n packageState: installed\n version: latest\ninstanceFilter:\n inclusionLabels:\n - labels:\n goog-ops-agent-policy: v2-x86-template-1-4-0\n' > config.yaml && gcloud compute instances ops-agents policies create goog-ops-agent-v2-x86-template-1-4-0-us-east1-d --project=qwiklabs-gcp-02-f27fa01197e2 --zone=us-east1-d --file=config.yaml

#### 2. Create an instance name us-test-02 in subnet-b-tupx and set the zone to us-east4-c.

gcloud compute instances create us-test-02 --project=qwiklabs-gcp-02-f27fa01197e2 --zone=us-east4-c --machine-type=e2-medium --network-interface=network-tier=PREMIUM,stack-type=IPV4_ONLY,subnet=subnet-b-tupx --metadata=enable-osconfig=TRUE,enable-oslogin=true --maintenance-policy=MIGRATE --provisioning-model=STANDARD --service-account=744529946695-compute@developer.gserviceaccount.com --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/trace.append --create-disk=auto-delete=yes,boot=yes,device-name=us-test-02,image=projects/debian-cloud/global/images/debian-12-bookworm-v20250812,mode=rw,size=10,type=pd-balanced --no-shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring --labels=goog-ops-agent-policy=v2-x86-template-1-4-0,goog-ec-src=vm_add-gcloud --reservation-affinity=any && printf 'agentsRule:\n packageState: installed\n version: latest\ninstanceFilter:\n inclusionLabels:\n - labels:\n goog-ops-agent-policy: v2-x86-template-1-4-0\n' > config.yaml && gcloud compute instances ops-agents policies create goog-ops-agent-v2-x86-template-1-4-0-us-east4-c --project=qwiklabs-gcp-02-f27fa01197e2 --zone=us-east4-c --file=config.yaml && gcloud compute resource-policies create snapshot-schedule default-schedule-1 --project=qwiklabs-gcp-02-f27fa01197e2 --region=us-east4 --max-retention-days=14 --on-source-disk-delete=keep-auto-snapshots --daily-schedule --start-time=18:00 && gcloud compute disks add-resource-policies us-test-02 --project=qwiklabs-gcp-02-f27fa01197e2 --zone=us-east4-c --resource-policies=projects/qwiklabs-gcp-02-f27fa01197e2/regions/us-east4/resourcePolicies/default-schedule-1

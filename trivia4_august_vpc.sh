# Challenge scenario
# As a network administrator, you have been assigned with the responsibility of connecting two Virtual Private Clouds (VPCs) workspace_vpc and private_vpc in your project. This peering connection will establish a direct and secure communication pathway between the resources residing in each VPC, allowing them to interact seamlessly with each other.
# Your task is :
# Create Peering connection workspace-vpc with private-vpc
# Create Peering connection private-vpc with workspace-vpc

# create networks peering
gcloud compute networks peerings create workspace-to-private --network=workspace-vpc --peer-network=private-vpc --auto-create-routes
gcloud compute networks peerings create private-to-workspace --network=private-vpc --peer-network=workspace-vpc --auto-create-routes

# i got warning like this
# WARNING: Flag --auto-create-routes is deprecated and will be removed in a future release.
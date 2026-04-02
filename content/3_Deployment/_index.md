---
title: "Deployment"
chapter: false
menuTitle: "Deployment"
weight: 30
---

Once the prerequisites have been satisfied proceed with the deployment steps below.

1.  Clone this repo with the command below.
```
git clone https://github.com/FortinetCloudCSE/fortigate-aws-tgwconnect-ha-dualaz-terraform.git
```

2.  Change directories and modify the terraform.tfvars file with your credentials and deployment information. 

{{% notice note %}} In the terraform.tfvars file, the comments explain what inputs are expected for the variables. For further details on a given variable or to see all possible variables, reference the variables.tf file. {{% /notice %}}
```
cd fortigate-aws-tgwconnect-ha-dualaz-terraform/terraform
nano terraform.tfvars
```

3.  When ready to deploy, use the commands below to run through the deployment.
```
terraform init
terraform validate
terraform apply --auto-approve
```

4.  When the deployment is complete, you will see login information for the FortiGates like so.
```
Apply complete! Resources: 68 added, 0 changed, 0 destroyed.

Outputs:

fgt_login_info = <<EOT
-=-=-=-=-=-=-=-=-=-=-
fgt username: admin
fgt initial password: i-030587371a178ab9b
cluster login url: https://54.188.162.232
fgt1 login url: https://44.252.247.54
fgt2 login url: https://16.146.218.128
-=-=-=-=-=-=-=-=-=-=-

EOT
tgw_info = <<EOT
-=-=-=-=-=-=-=-=-=-=-
tgw id: tgw-09bfd7efd39295d81
tgw spoke route table id: tgw-rtb-0cfb479fad59cd178
tgw security route table id: tgw-rtb-0ca014252edf68f74
-=-=-=-=-=-=-=-=-=-=-

EOT
```
# gcp-nginx-plus-with-consul
This project is to create GCP infrastructure with NGINXplus, Consul Server and Consult client usign Terraform to deploy nginx plus as API Gateway and load balanced with NLB
## Multi region GCP using Terraform 
    https://www.terraform.io/docs/enterprise/before-installing/reference-architecture/gcp.html.
    https://stackoverflow.com/questions/54143754/how-do-i-specify-different-regions-per-resource-for-terraform-gcp-module.
    https://medium.com/technopanti/automating-the-deployment-of-infrastructure-using-terraform-on-gcp-7d8f2a8400b3.

## Pre-requisite 
    1. Build the nginxplus image using packer ,follow the instructions
       here https://github.com/b-rajesh/nginxplus-packer-image-builder
    2. Build the following microservices image using packer, follow the instructions on each
       1. https://github.com/b-rajesh/hello-nginxplus
       2. https://github.com/b-rajesh/hello-f1
       3. https://github.com/b-rajesh/weather-api

    3. Replace `terraform.tfvars` values with your `project_id` , `region` and other variables. Your  `project_id` &  `region`  must match the project you've initialized gcloud with.

## Base nginx plus project used 
    You don't have to check-out this project(explicitly) as it would be automatically used while building the nginx plus vm image
    https://github.com/b-rajesh/diy-nginx-plus-api-gateway

## Consul Help
    CONSUL_HTTP_ADDR
    curl -s http://127.0.0.1:8500/v1/agent/members | jq
    curl -s http://127.0.0.1:8500/v1/status/leader | jq
    curl -s http://127.0.0.1:8500/v1/agent/self | jq
## Install appropriate GCP tools
First, install the Google Cloud CLI
    Install gcloud sdk  - <Google Cloud SDK 284.0.0>

Initialize it...
```sh
$ gcloud init
```

gcloud Configure
```sh
$ gcloud auth login
```

Configure glcoud to work with your Terraform.
```sh
$ gcloud auth application-default login
```


## Initialize Terraform workspace
Initalize your Terraform workspace, which will download the provider and initialize it with the values provided in the terraform.tfvars file.

```sh

$ terraform init

Initializing the backend...

Initializing provider plugins...

The following providers do not have any version constraints in configuration,
so the latest version was installed.

To prevent automatic upgrades to new major versions that may contain breaking
changes, it is recommended to add version = "..." constraints to the
corresponding provider blocks in configuration, with the constraint strings
suggested below.

```

Then, run plan terraform plan.
```sh
$ terraform plan

# Output truncated...

Plan: 33 to add, 0 to change, 0 to destroy.
```

Run terraform apply. This will take approximately 10 minutes after your type yes - depends where you are running
```sh
# Output truncated...

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value:
```

Output of the successful apply will look like this
```sh
# Output truncated...

Apply complete! Resources: 38 added, 0 changed, 0 destroyed.

Outputs:
# Output truncated...
```

## Highlevel Architecture
![alt text](image/NGINX-Plus-Consul-GCP.png)

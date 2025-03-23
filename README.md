# TerraformDeployments

After cloning execute initialize terraform inside LambdaWebApi-Infra
    terraform init


Before deploying to AWS make sure to add AWS profile in every new console app session (i.e. powershell)

    $env:AWS_PROFILE = "My-AWS-Profile"

    echo $env:AWS_PROFILE

Execute commands below to view if worspace is empty.  If emtpy, create one. You don't have to this in every console session if it is already created previously

    terraform workspace list

    terraform workspace new dev

    terraform workspace select dev 

Then you can deploy using this command after creating workspace

    terraform apply -var-file="terraform.tfvars.dev"

Teardown command

    terraform destroy -var-file="terraform.tfvars.dev"

make sure to create the terraform.tfvars.dev base off of terraform.tfvars.example


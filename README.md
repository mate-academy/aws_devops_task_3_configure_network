# AWS Essentials: Deploy the Network

We will run our Grafana deployment on an EC2 virtual machine, and before we deploy it, we have to prepare the network resources! Luckily, we already deployed a VPC in [previous task](https://github.com/mate-academy/aws_devops_task_1_test_lab_setup) — now we need to add some resources.

## Prerequirements

Before completing any task in the module, make sure that you followed all the steps described in the **Environment Setup** topic, in particular:

1. Make sure you have an [AWS](https://aws.amazon.com/free/) account.

2. Install [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html).

3. Install [PowerShell Core](https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell?view=powershell-7.4).

4. Install [Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli).

5. Log in to AWS CLI on your computer by running the command:
   
    ```
    aws configure
    ```

## Task Requirements 

In this task, you will prepare the network infrastructure for the EC2 instance we will use to run Grafana. 

To complete this task: 

1. Edit `terraform.tfvars` — fill out the `tfvars` file with the previous modules' outputs and your configuration variables. You should use those variables as parameters for the resources in this task. This task requires only one variable — `vpc_id`, you can get if as terraform module output in the [first task](https://github.com/mate-academy/aws_devops_task_1_test_lab_setup). 

2. Edit `main.tf` — add resources, required for this task: 
    
    - Use the [`aws_subnet`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) resource to deploy a subnet with the `grafana` name tag. You can use any IP address range as a subnet range, valid for your VPC.

    - Use the [`aws_internet_gateway`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) resource to deploy an Internet Gateway with the `mate-aws-grafana-lab` name tag. Make sure that the Internet Gateway resource is associated with your VPC. 

    - Use the [`aws_route_table`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) resource to deploy a new route table with the `mate-aws-grafana-lab` name tag. Route table should be associated with the VPC you deployed earlier, and it has to have a route, which forwards all traffic through the Internet Gateway you have just added. 

    - Use the [`aws_route_table_association`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) resource to attach your route table to the `grafana` subnet. 

    - Use the [`aws_security_group`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group.html) resource to create a security group with the `mate-aws-grafana-lab` name (and a name tag). Make sure the security group is associated with your VPC. 

    - Use the [`aws_vpc_security_group_ingress_rule`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule) resource to create security group rules, which allow HTTP and HTTPS traffic from all source IPs, and SSH traffic from your public IP. To get your public IP, you can use an [online tool](https://whatismyipaddress.com/). Please note that when creating a security rule with this terraform resource, you have to specify the destination port range rather than a single port. For example, to allow connections to TCP ports from 255 to 512, you have to set `from_port` to 255 and `to_port` to 512. If you want to whitelist a single TCP port 8080, you have to set both resource properties `from_port` and `to_port` to 8080.  
   
    - Uncommend (and update if required) the outbound security group rule, which allows all traffic from the virtual machine. It required by the VM to have an Internet access.

3. After adding the code to the `main.tf` file, review the `outputs.tf` file and make sure that all output variables are valid and can output relevant values, as described in the output variable descriptions. 

4. Run the following commands to generate a Terraform execution plan in **JSON** format: 

    ```
    terraform init
    terraform plan -out=tfplan
    terraform show -json tfplan > tfplan.json
    ```

5. Run an automated test to check yourself:
 
    ```
    pwsh ./tests/test-tf-plan.ps1
    ```

💡 If any test fails, please check your task code and repeat step 4 to generate a new `tfplan.json` file.

6. Deploy infrastructure using the following command: 
    
    ```
    terraform apply
    ```
    
Make sure to collect module outputs — we will use those values in the next tasks. 

5. Commit the `tfplan.json` file and submit your solution for review. 

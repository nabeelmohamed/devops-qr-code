# devops-qr-code

This is the sample application for the DevOps Capstone Project.
It generates QR Codes for the provided URL, the front-end is in NextJS and the API is written in Python using FastAPI.

## Application

**Front-End** - A web application where users can submit URLs.

**API**: API that receives URLs and generates QR codes. The API stores the QR codes in cloud storage(AWS S3 Bucket).

## Running locally

### API

The API code exists in the `api` directory. You can run the API server locally:

- Clone this repo
- Make sure you are in the `api` directory
- Create a virtualenv by typing in the following command: `python -m venv .venv`
- Install the required packages: `pip install -r requirements.txt`
- Create a `.env` file, and add you AWS Access and Secret key, check  `.env.example`
- Also, change the BUCKET_NAME to your S3 bucket name in `main.py`
- Run the API server: `uvicorn main:app --reload`
- Your API Server should be running on port `http://localhost:8000`

### Front-end

The front-end code exits in the `front-end-nextjs` directory. You can run the front-end server locally:

- Clone this repo
- Make sure you are in the `front-end-nextjs` directory
- Install the dependencies: `npm install`
- Run the NextJS Server: `npm run dev`
- Your Front-end Server should be running on `http://localhost:3000`

# Infrastructure Setup with Terraform

## Step 1: Provision Infrastructure using Terraform

Use Terraform to create all the necessary infrastructure components for your project. This includes:

- **EKS Cluster**: Managed Kubernetes service for container orchestration.
- **IAM Roles**: Define permissions for AWS resources.
- **VPC**: Virtual Private Cloud for network isolation.
- **Subnets**: Divide the VPC into smaller segments.
- **Jump Server or jenkins server**: A bastion host to access your infrastructure securely.
- User data scripts for the **jump server** are defined in the `terraform` directory. These scripts:
 - Install **Jenkins**, **SonarQube**, **Docker**, and other dependencies.

The `eks.tf` resource in Terraform will automatically handle the creation of the EKS cluster.

### Provision the Infrastructure

To provision all resources, execute the following commands in your terminal:

```bash
terraform init
terraform plan
terraform apply
```
## step 2: SSH into the Jump Server
Once the infrastructure is provisioned, SSH into the Jump Server to perform the necessary configuration steps.
 **Steps:**
- Configure AWS CLI on Jump Server
On the Jump Server, configure the AWS CLI with the following command to ensure it is authenticated with the necessary AWS credentials:
```bash
aws configure
```
These steps are crucial for interacting with your EKS cluster from outside world.
1. Downloaded the required IAM policy:
   ```bash
   aws eks update-kubeconfig --region us-east-1 --name devops-qr-code-cluster
   curl -O https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.5.4/docs/install/iam_policy.json
   aws iam create-policy --policy-name AWSLoadBalancerControllerIAMPolicy --policy-document file://iam_policy.json
   ```
2. Associated an OIDC provider:

  ```bash
eksctl utils associate-iam-oidc-provider --region us-east-1 --cluster devops-qr-code-cluster --approve
  ```
3. Created an IAM service account for the controller:
   
  ```bash
eksctl create iamserviceaccount \
--cluster=devops-qr-code-cluster \
--namespace=kube-system \
--name=aws-load-balancer-controller \
--role-name AmazonEKSLoadBalancerControllerRole \
--attach-policy-arn=arn:aws:iam::<your_account_id>:policy/AWSLoadBalancerControllerIAMPolicy \
--approve \
--region=us-east-1
  ```
4. Installed the load balancer controller using Helm:

  ```bash
helm repo add eks https://aws.github.io/eks-charts
helm repo update
helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
-n kube-system \
--set clusterName=devops-qr-code-cluster \
--set serviceAccount.create=false \
--set serviceAccount.name=aws-load-balancer-controller
  ```
5. Verified the deployment:

  ```bash
kubectl get deployment -n kube-system aws-load-balancer-controller
  ```
In case of errors or a CrashLoopBackOff, use the following command to upgrade the deployment:
```bash
helm upgrade -i aws-load-balancer-controller eks/aws-load-balancer-controller \
--set clusterName=Three-Tier-K8s-EKS-Cluster \
--set serviceAccount.create=false \
--set serviceAccount.name=aws-load-balancer-controller \
--set region=us-west-1 --set vpcId=<vpc#> -n kube-system
```
**SonarQube Setup**
- Set up SonarQube for code quality analysis. Create a project in SonarQube for both frontend and backend as a single repositories.
-  Add a sonar-project.properties file to the root directory to configure SonarQube analysis with the workflow file.
-  The CI pipeline should trigger when changes are detected in the /frontend or /backend directories. The pipeline will execute:

 - SonarQube analysis
 - OWASP security scans
 - Trivy security scans
 - Docker images will be built and pushed to DockerHub.
   (Ensure that your two microserives have separate directories)

### Update Docker Image in the deployment Manifest
Use a sed command in the workflow to update the Docker image tag in the Kubernetes deployment configuration file:
### Continuous Delivery Setup

## Jenkins Pipeline to Deploy Using Helm

 - Ensures your Jenkins have the nexessary plugins and credentials for the pipeline to be successfull.
 - The Jenkins pipeline is responsible for deploying the newly updated Docker images to Kubernetes cluster in aws using Helm. This ensures that your applications are always up-to-date with the latest code changes.

---

### Workflow Dispatch for Terraform Updates

## Step 5: Future Terraform Updates

Create a separate GitHub Actions workflow file specifically for Terraform updates. This workflow will be triggered when there is changes in the `.tf ` ,and target is set by the input method using the `workflow_dispatch` method.
### Final Notes
Helm deployment is handled in the Jenkins pipeline, while Terraform is utilized for infrastructure provisioning.
The CI/CD setup ensures that every change in the repository is automatically built, tested, and deployed.
The workflow_dispatch method allows for setting target resource and also the maintanence of Terraform updates, providing flexibility for infrastructure management.
By following these steps, you can efficiently set up and manage your infrastructure and application deployment using Terraform, AWS, Helm,github actions and jenkins
## Goal

The goal is to get hands-on with DevOps practices like Containerization, CICD.

Look at the capstone project for more detials.

## Author

[Rishab Kumar](https://github.com/rishabkumar7)

## License

[MIT](./LICENSE)

# Azure DevOps Setup Commands & Configurations

## 🔧 Azure CLI Setup (Optional but Recommended)

### Install Azure CLI
```bash
# For Ubuntu/Debian
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# For macOS
brew install azure-cli

# For Windows
# Download from: https://aka.ms/installazurecliwindows
```

### Login to Azure DevOps
```bash
az login
az extension add --name azure-devops
az devops configure --defaults organization=https://dev.azure.com/YOUR_ORG project=YOUR_PROJECT
```

---

## 📦 Create Service Connection via CLI

### AWS Service Connection
```bash
# Note: Service connections are typically created via UI
# But you can use REST API if needed

# Set variables
ORG_URL="https://dev.azure.com/YOUR_ORG"
PROJECT="YOUR_PROJECT"
PAT="YOUR_PERSONAL_ACCESS_TOKEN"

# Create service connection (requires REST API call)
# Easier to do via UI: Project Settings → Service Connections → New → AWS
```

---

## 🔐 IAM Policy for AWS Service Connection

Create an IAM user in AWS with this policy:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "ECRAccess",
      "Effect": "Allow",
      "Action": [
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
        "ecr:PutImage",
        "ecr:InitiateLayerUpload",
        "ecr:UploadLayerPart",
        "ecr:CompleteLayerUpload"
      ],
      "Resource": "*"
    },
    {
      "Sid": "EC2Access",
      "Effect": "Allow",
      "Action": [
        "ec2:*",
        "vpc:*"
      ],
      "Resource": "*"
    },
    {
      "Sid": "TerraformStateAccess",
      "Effect": "Allow",
      "Action": [
        "s3:ListBucket",
        "s3:GetObject",
        "s3:PutObject",
        "s3:DeleteObject"
      ],
      "Resource": [
        "arn:aws:s3:::YOUR-TERRAFORM-STATE-BUCKET",
        "arn:aws:s3:::YOUR-TERRAFORM-STATE-BUCKET/*"
      ]
    }
  ]
}
```

---

## 🚀 Pipeline Creation via CLI

### Create Pipeline
```bash
# Set your organization and project
az devops configure --defaults organization=https://dev.azure.com/YOUR_ORG project=YOUR_PROJECT

# Create pipeline
az pipelines create \
  --name "Java Maven App Pipeline" \
  --description "CI/CD pipeline for Java Maven application" \
  --repository YOUR_REPO_NAME \
  --repository-type tfsgit \
  --branch main \
  --yml-path azure-pipelines.yml
```

### Run Pipeline
```bash
# List pipelines
az pipelines list --output table

# Run pipeline
az pipelines run --name "Java Maven App Pipeline"

# Check pipeline status
az pipelines runs list --pipeline-ids PIPELINE_ID --output table
```

---

## 🌍 Create Environment via CLI

```bash
# Create environment
az devops invoke \
  --area distributedtask \
  --resource environments \
  --route-parameters project=YOUR_PROJECT \
  --http-method POST \
  --api-version 6.0-preview \
  --in-file environment.json

# environment.json content:
{
  "name": "production",
  "description": "Production environment for Java Maven App"
}
```

---

## 📊 Variable Group Creation via CLI

```bash
# Create variable group
az pipelines variable-group create \
  --name "java-maven-app-vars" \
  --variables \
    AWS_REGION=us-east-1 \
    DOCKER_REPO_SERVER=004380138556.dkr.ecr.us-east-1.amazonaws.com \
    IMAGE_NAME=java-maven-1.0 \
    TF_VAR_env_prefix=test

# Add secret variable
az pipelines variable-group variable create \
  --group-id GROUP_ID \
  --name AWS_SECRET_ACCESS_KEY \
  --value "YOUR_SECRET" \
  --secret true
```

---

## 🔑 Generate Personal Access Token (PAT)

1. Go to Azure DevOps → User Settings (top right) → Personal Access Tokens
2. Click **"New Token"**
3. Configure:
   - **Name**: `Pipeline-CLI-Access`
   - **Organization**: Select your org
   - **Expiration**: 90 days (or custom)
   - **Scopes**: 
     - ✅ Build (Read & Execute)
     - ✅ Code (Read)
     - ✅ Service Connections (Read, Query, & Manage)
     - ✅ Variable Groups (Read, Create, & Manage)
4. Click **"Create"**
5. **Copy the token** (you won't see it again!)

---

## 🔍 Useful Azure DevOps CLI Commands

### Pipeline Management
```bash
# List all pipelines
az pipelines list --output table

# Show pipeline details
az pipelines show --name "Java Maven App Pipeline"

# Delete pipeline
az pipelines delete --id PIPELINE_ID --yes

# Update pipeline
az pipelines update --id PIPELINE_ID --new-name "New Pipeline Name"
```

### Build/Run Management
```bash
# List recent runs
az pipelines runs list --top 10 --output table

# Show run details
az pipelines runs show --id RUN_ID

# Show run logs
az pipelines runs show --id RUN_ID --open

# Cancel a run
az pipelines runs cancel --run-id RUN_ID
```

### Repository Management
```bash
# List repositories
az repos list --output table

# Show repository details
az repos show --repository YOUR_REPO_NAME
```

---

## 🐳 Docker Compose Update for ECR

Update your `docker-compose.yml` to use ECR image:

```yaml
version: "3.8"
services:
  java-maven-app:
    image: 004380138556.dkr.ecr.us-east-1.amazonaws.com/java-maven-app:java-maven-1.0
    ports:
      - "8080:8080"
  postgres:
    image: postgres:13
    ports:
      - "5432:5432"
    environment:
      POSTGRES_PASSWORD: my-pass
```

---

## 📝 Terraform Backend Configuration (Recommended)

Add to `terraform/main.tf`:

```hcl
terraform {
  backend "s3" {
    bucket         = "your-terraform-state-bucket"
    key            = "java-maven-app/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-state-lock"
  }
}
```

Create S3 bucket and DynamoDB table:
```bash
# Create S3 bucket
aws s3 mb s3://your-terraform-state-bucket --region us-east-1

# Enable versioning
aws s3api put-bucket-versioning \
  --bucket your-terraform-state-bucket \
  --versioning-configuration Status=Enabled

# Create DynamoDB table for state locking
aws dynamodb create-table \
  --table-name terraform-state-lock \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST \
  --region us-east-1
```

---

## 🎯 Quick Start Script

Save as `setup-azure-pipeline.sh`:

```bash
#!/bin/bash
set -e

echo "🚀 Azure Pipeline Setup Script"

# Variables
ORG_URL="https://dev.azure.com/YOUR_ORG"
PROJECT="YOUR_PROJECT"

# Login
echo "📝 Logging in to Azure DevOps..."
az login
az extension add --name azure-devops

# Configure defaults
az devops configure --defaults organization=$ORG_URL project=$PROJECT

# Create pipeline
echo "🔧 Creating pipeline..."
az pipelines create \
  --name "Java Maven App Pipeline" \
  --repository YOUR_REPO_NAME \
  --branch main \
  --yml-path azure-pipelines.yml

echo "✅ Setup complete!"
echo "🌐 Visit: $ORG_URL/$PROJECT/_build"
```

---

**Ready to migrate! 🎉**


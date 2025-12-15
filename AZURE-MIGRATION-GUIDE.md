# Azure Pipelines Migration Guide

## 📋 Overview
This guide will help you migrate from Jenkins to Azure Pipelines for your Java Maven application.

---

## 🚀 Step 1: Azure DevOps Setup

### 1.1 Create Azure DevOps Project
1. Go to [Azure DevOps](https://dev.azure.com)
2. Click **"New Project"**
3. Enter project name (e.g., `java-maven-app`)
4. Set visibility (Private/Public)
5. Click **"Create"**

### 1.2 Import Your Repository
Choose one of these options:

**Option A: Azure Repos**
1. Go to **Repos** → **Files**
2. Click **"Import"**
3. Enter your Git repository URL
4. Click **"Import"**

**Option B: Connect to GitHub/GitLab**
1. Go to **Project Settings** → **Service Connections**
2. Click **"New Service Connection"** → **GitHub** or **GitLab**
3. Authorize and connect your repository

---

## 🔐 Step 2: Configure Service Connections

### 2.1 AWS Service Connection
1. Go to **Project Settings** → **Service Connections**
2. Click **"New Service Connection"** → **AWS**
3. Fill in:
   - **Connection Name**: `AWS-Service-Connection`
   - **Access Key ID**: Your AWS Access Key
   - **Secret Access Key**: Your AWS Secret Key
   - **Region**: `us-east-1`
4. Click **"Verify and Save"**

### 2.2 Upload SSH Key for EC2
1. Go to **Pipelines** → **Library**
2. Click **"Secure Files"**
3. Click **"+ Secure File"**
4. Upload your EC2 SSH private key file (e.g., `ec2-ssh-key.pem`)
5. Note the filename for use in pipeline

---

## 📦 Step 3: Configure Pipeline Variables

### 3.1 Create Variable Group (Optional but Recommended)
1. Go to **Pipelines** → **Library**
2. Click **"+ Variable Group"**
3. Name it: `java-maven-app-vars`
4. Add these variables:

| Variable Name | Value | Secret? |
|--------------|-------|---------|
| `AWS_REGION` | `us-east-1` | No |
| `DOCKER_REPO_SERVER` | `004380138556.dkr.ecr.us-east-1.amazonaws.com` | No |
| `IMAGE_NAME` | `java-maven-1.0` | No |
| `TF_VAR_env_prefix` | `test` | No |

5. Click **"Save"**

### 3.2 Link Variable Group to Pipeline
In `azure-pipelines.yml`, add at the top:
```yaml
variables:
  - group: java-maven-app-vars
```

---

## 🔧 Step 4: Update azure-pipelines.yml

### 4.1 Replace Placeholder Values
Open `azure-pipelines.yml` and update:

1. **Line 82**: Replace `'AWS-Service-Connection'` with your actual AWS service connection name
2. **Line 119**: Replace `'AWS-Service-Connection'` with your actual AWS service connection name
3. **Line 148**: Replace `'ec2-ssh-key.pem'` with your actual SSH key filename
4. **Line 143**: Update environment name if needed (default: `production`)

### 4.2 Adjust Trigger Branches
Update lines 2-6 to match your branching strategy:
```yaml
trigger:
  branches:
    include:
      - main        # Your main branch
      - develop     # Your dev branch
```

---

## 🌍 Step 5: Create Environment

1. Go to **Pipelines** → **Environments**
2. Click **"New Environment"**
3. Name: `production` (or match what's in your YAML)
4. Resource: **None**
5. Click **"Create"**

This enables deployment tracking and approvals.

---

## ✅ Step 6: Create and Run Pipeline

### 6.1 Create Pipeline
1. Go to **Pipelines** → **Pipelines**
2. Click **"New Pipeline"**
3. Select your repository source (Azure Repos/GitHub/etc.)
4. Select **"Existing Azure Pipelines YAML file"**
5. Choose `/azure-pipelines.yml`
6. Click **"Continue"**

### 6.2 Review and Run
1. Review the pipeline YAML
2. Click **"Run"**
3. Monitor the pipeline execution

---

## 🔍 Step 7: Verify Each Stage

### Stage 1: Build ✅
- Maven builds the JAR file
- Artifact is published

### Stage 2: Docker ✅
- Docker image is built
- Image is pushed to AWS ECR

### Stage 3: Provision ✅
- Terraform provisions EC2 infrastructure
- EC2 Public IP is captured

### Stage 4: Deploy ✅
- Application is deployed to EC2
- Accessible at `http://<EC2_IP>:8080`

---

## 🛠️ Troubleshooting

### Issue: AWS Authentication Failed
**Solution**: Verify AWS service connection credentials and permissions

### Issue: SSH Connection Failed
**Solution**: 
- Ensure SSH key is uploaded to Secure Files
- Verify EC2 security group allows SSH (port 22)
- Check key permissions: `chmod 600`

### Issue: Terraform State Conflicts
**Solution**: 
- Configure remote backend (S3) in `terraform/main.tf`
- Or ensure only one pipeline runs at a time

### Issue: Docker Build Fails
**Solution**: 
- Verify JAR file exists in target directory
- Check Dockerfile path and syntax

---

## 📊 Key Differences: Jenkins vs Azure Pipelines

| Feature | Jenkins | Azure Pipelines |
|---------|---------|-----------------|
| **Configuration** | Jenkinsfile (Groovy) | azure-pipelines.yml (YAML) |
| **Credentials** | Jenkins Credentials | Service Connections + Library |
| **Agents** | Jenkins nodes | Microsoft-hosted or self-hosted agents |
| **Artifacts** | Archive artifacts | Publish/Download Build Artifacts |
| **Environment Variables** | `environment {}` | `variables:` section |
| **SSH** | `sshagent` plugin | Secure Files + script |
| **AWS** | `withAWS` plugin | AWS service connection |

---

## 🎯 Next Steps

1. ✅ Test the pipeline end-to-end
2. ✅ Set up branch policies and PR triggers
3. ✅ Configure approval gates for production environment
4. ✅ Add automated tests to the pipeline
5. ✅ Set up notifications (email, Slack, Teams)
6. ✅ Configure pipeline retention policies
7. ✅ Decommission Jenkins after successful migration

---

## 📚 Additional Resources

- [Azure Pipelines Documentation](https://docs.microsoft.com/azure/devops/pipelines/)
- [YAML Schema Reference](https://docs.microsoft.com/azure/devops/pipelines/yaml-schema)
- [AWS Tasks for Azure Pipelines](https://docs.aws.amazon.com/vsts/latest/userguide/welcome.html)

---

## 🆘 Need Help?

If you encounter issues:
1. Check pipeline logs in Azure DevOps
2. Review service connection permissions
3. Verify AWS IAM policies
4. Test Terraform locally first
5. Validate SSH connectivity manually

---

**Migration Complete! 🎉**


# Jenkins to Azure Pipelines Migration Summary

## 📦 What Has Been Created

I've created a complete Azure Pipelines setup for your Java Maven application with the following files:

### 1. **azure-pipelines.yml** ⭐
The main pipeline configuration file with 4 stages:
- **Build**: Maven build with caching
- **Docker**: Build and push to AWS ECR
- **Provision**: Terraform infrastructure provisioning
- **Deploy**: SSH deployment to EC2

### 2. **AZURE-MIGRATION-GUIDE.md** 📖
Comprehensive step-by-step migration guide covering:
- Azure DevOps project setup
- Service connections configuration
- Pipeline variables setup
- Environment creation
- Troubleshooting tips

### 3. **MIGRATION-CHECKLIST.md** ✅
Interactive checklist to track your migration progress with:
- Pre-migration tasks
- Setup steps
- Testing validation
- Post-migration activities

### 4. **AZURE-SETUP-COMMANDS.md** 💻
Technical reference with:
- Azure CLI commands
- IAM policies for AWS
- Pipeline management commands
- Terraform backend configuration

---

## 🎯 Quick Start (5 Minutes)

### Step 1: Azure DevOps Setup
1. Go to https://dev.azure.com
2. Create new project
3. Import your Git repository

### Step 2: Configure AWS Connection
1. Project Settings → Service Connections
2. New Service Connection → AWS
3. Name: `AWS-Service-Connection`
4. Add your AWS credentials

### Step 3: Upload SSH Key
1. Pipelines → Library → Secure Files
2. Upload your EC2 SSH key (e.g., `ec2-ssh-key.pem`)

### Step 4: Create Environment
1. Pipelines → Environments
2. New Environment → Name: `production`

### Step 5: Create Pipeline
1. Pipelines → New Pipeline
2. Select your repository
3. Choose "Existing Azure Pipelines YAML file"
4. Select `/azure-pipelines.yml`
5. Run!

---

## 🔄 Pipeline Stages Comparison

### Jenkins → Azure Pipelines Mapping

| Jenkins Stage | Azure Stage | Status |
|--------------|-------------|--------|
| Checkout Code | Build → Checkout | ✅ Migrated |
| Build Application | Build → Maven Build | ✅ Migrated |
| Build & Push Docker | Docker → Build & Push | ✅ Migrated |
| Provision Server | Provision → Terraform | ✅ Migrated |
| Deploy | Deploy → SSH Deploy | ✅ Migrated |

---

## 🔐 Required Secrets & Credentials

### In Azure DevOps, you need:

1. **AWS Service Connection**
   - AWS Access Key ID
   - AWS Secret Access Key
   - Region: us-east-1

2. **Secure Files**
   - EC2 SSH private key (`.pem` file)

3. **Variables** (optional, can be in YAML)
   - IMAGE_NAME: `java-maven-1.0`
   - DOCKER_REPO_SERVER: `004380138556.dkr.ecr.us-east-1.amazonaws.com`
   - AWS_REGION: `us-east-1`

---

## ✨ Key Improvements Over Jenkins

### 1. **Built-in Caching**
```yaml
- task: Cache@2
  inputs:
    key: 'maven | "$(Agent.OS)" | **/pom.xml'
```
Faster builds by caching Maven dependencies.

### 2. **Better Artifact Management**
```yaml
- task: PublishBuildArtifacts@1
- task: DownloadBuildArtifacts@1
```
Cleaner artifact handling between stages.

### 3. **Environment Tracking**
```yaml
environment: 'production'
```
Built-in deployment history and approvals.

### 4. **Output Variables**
```yaml
echo "##vso[task.setvariable variable=EC2_PUBLIC_IP;isOutput=true]$EC2_PUBLIC_IP"
```
Better variable passing between stages.

### 5. **YAML-First Approach**
- Version controlled pipeline
- Easy to review changes
- No UI configuration needed

---

## 🚨 Important Notes

### Before First Run:
- ⚠️ Update service connection name in YAML (lines 82, 119)
- ⚠️ Update SSH key filename in YAML (line 148)
- ⚠️ Verify AWS credentials have ECR + EC2 permissions
- ⚠️ Ensure SSH key matches Terraform EC2 key pair

### Cost Considerations:
- 💰 Each run provisions new EC2 instance
- 💰 Consider Terraform remote state (S3) for team collaboration
- 💰 Remember to destroy resources when testing

### Security:
- 🔒 Use least-privilege IAM policies
- 🔒 Rotate credentials regularly
- 🔒 Enable branch policies for main branch
- 🔒 Set up approval gates for production

---

## 📊 Expected Pipeline Duration

| Stage | Duration | Notes |
|-------|----------|-------|
| Build | ~2-3 min | Maven build + caching |
| Docker | ~3-5 min | Build + push to ECR |
| Provision | ~5-7 min | Terraform apply |
| Deploy | ~2-3 min | SSH + docker-compose |
| **Total** | **~12-18 min** | First run may be slower |

---

## 🐛 Common Issues & Solutions

### Issue 1: "AWS Service Connection not found"
**Solution**: Update service connection name in `azure-pipelines.yml` lines 82 and 119

### Issue 2: "SSH key permission denied"
**Solution**: Ensure SSH key is uploaded to Secure Files and filename matches YAML

### Issue 3: "Terraform state locked"
**Solution**: Configure S3 backend or ensure only one pipeline runs at a time

### Issue 4: "Docker image not found on EC2"
**Solution**: Update `docker-compose.yml` to use ECR image URL

---

## 🎓 Learning Resources

- [Azure Pipelines Docs](https://docs.microsoft.com/azure/devops/pipelines/)
- [YAML Schema](https://docs.microsoft.com/azure/devops/pipelines/yaml-schema)
- [AWS Tasks](https://docs.aws.amazon.com/vsts/latest/userguide/welcome.html)
- [Terraform in Azure Pipelines](https://docs.microsoft.com/azure/devops/pipelines/tasks/deploy/terraform)

---

## 📞 Next Steps

1. ✅ Review all created files
2. ✅ Follow **AZURE-MIGRATION-GUIDE.md** step-by-step
3. ✅ Use **MIGRATION-CHECKLIST.md** to track progress
4. ✅ Test pipeline in non-production environment first
5. ✅ Set up notifications and monitoring
6. ✅ Train team on Azure Pipelines
7. ✅ Keep Jenkins running for 2-4 weeks as backup
8. ✅ Decommission Jenkins after successful validation

---

## 🎉 Success Criteria

Your migration is successful when:
- ✅ Pipeline runs without errors
- ✅ Docker image appears in ECR
- ✅ EC2 instance is provisioned
- ✅ Application is accessible at `http://<EC2_IP>:8080`
- ✅ Team is comfortable with Azure Pipelines
- ✅ All Jenkins functionality is replicated

---

**Ready to start? Open AZURE-MIGRATION-GUIDE.md and begin! 🚀**

**Questions? Check AZURE-SETUP-COMMANDS.md for technical details.**

**Track progress? Use MIGRATION-CHECKLIST.md!**


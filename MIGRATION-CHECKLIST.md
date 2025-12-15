# Azure Pipelines Migration Checklist

## Pre-Migration
- [ ] Review current Jenkins pipeline functionality
- [ ] Document all Jenkins credentials and secrets
- [ ] Identify all Jenkins plugins used
- [ ] Export Jenkins build history (if needed)
- [ ] Backup Jenkins configuration

## Azure DevOps Setup
- [ ] Create Azure DevOps organization (if not exists)
- [ ] Create new project in Azure DevOps
- [ ] Import/connect Git repository
- [ ] Invite team members to project

## Service Connections
- [ ] Create AWS service connection
  - Name: `AWS-Service-Connection`
  - Access Key ID: `_______________`
  - Secret Access Key: `_______________`
  - Region: `us-east-1`
- [ ] Test AWS connection

## Secure Files & Secrets
- [ ] Upload EC2 SSH private key to Secure Files
  - Filename: `ec2-ssh-key.pem`
- [ ] Create variable group (optional): `java-maven-app-vars`
- [ ] Add pipeline variables:
  - [ ] AWS_REGION
  - [ ] DOCKER_REPO_SERVER
  - [ ] IMAGE_NAME
  - [ ] TF_VAR_env_prefix

## Pipeline Configuration
- [ ] Copy `azure-pipelines.yml` to repository root
- [ ] Update AWS service connection name in YAML (lines 82, 119)
- [ ] Update SSH key filename in YAML (line 148)
- [ ] Update trigger branches to match your workflow
- [ ] Commit and push `azure-pipelines.yml`

## Environment Setup
- [ ] Create `production` environment in Azure DevOps
- [ ] Configure approval gates (optional)
- [ ] Set up environment-specific variables (optional)

## Pipeline Creation
- [ ] Create new pipeline in Azure DevOps
- [ ] Select repository source
- [ ] Choose existing YAML file: `/azure-pipelines.yml`
- [ ] Save pipeline

## Testing & Validation
- [ ] Run pipeline manually for first time
- [ ] Verify Build stage completes successfully
- [ ] Verify Docker image pushed to ECR
- [ ] Verify Terraform provisions infrastructure
- [ ] Verify deployment to EC2 succeeds
- [ ] Test application: `http://<EC2_IP>:8080`
- [ ] Check application logs on EC2

## Post-Migration
- [ ] Set up branch policies for main/master branch
- [ ] Configure PR build validation
- [ ] Set up build notifications (email/Slack/Teams)
- [ ] Configure pipeline retention policies
- [ ] Update team documentation
- [ ] Train team on Azure Pipelines
- [ ] Monitor first few production deployments
- [ ] Archive Jenkins configuration
- [ ] Decommission Jenkins server (after validation period)

## Rollback Plan (If Needed)
- [ ] Keep Jenkins server running for 2-4 weeks
- [ ] Document rollback procedure
- [ ] Maintain Jenkins credentials during transition

## Optional Enhancements
- [ ] Add unit tests to pipeline
- [ ] Add integration tests
- [ ] Add code quality checks (SonarQube)
- [ ] Add security scanning
- [ ] Set up multi-stage deployments (dev/staging/prod)
- [ ] Configure auto-scaling for agents
- [ ] Set up pipeline analytics and reporting

---

## Quick Reference

### AWS ECR Repository
```
004380138556.dkr.ecr.us-east-1.amazonaws.com/java-maven-app
```

### Image Tag
```
java-maven-1.0
```

### Application Port
```
8080
```

### Terraform Directory
```
./terraform
```

### Deployment Scripts
- `server-cmnds.sh` - EC2 deployment script
- `docker-compose.yml` - Docker Compose configuration

---

## Important Notes

⚠️ **Before First Run:**
1. Ensure AWS credentials have ECR push permissions
2. Ensure AWS credentials have EC2/VPC creation permissions
3. Verify SSH key matches EC2 key pair in Terraform
4. Check security group rules allow ports 22, 8080

⚠️ **Cost Considerations:**
- Each pipeline run provisions new EC2 instance
- Remember to destroy resources when not needed
- Consider using Terraform remote state (S3)

⚠️ **Security Best Practices:**
- Rotate AWS credentials regularly
- Use least-privilege IAM policies
- Enable MFA for Azure DevOps
- Review pipeline permissions regularly
- Use separate AWS accounts for dev/prod

---

**Status:** [ ] Not Started | [ ] In Progress | [ ] Complete

**Migration Date:** _______________

**Validated By:** _______________


# export IMAGE = "$1"
# docker-compose up -d
# echo "success"
#!/bin/bash
set -e

IMAGE_NAME=$1
ECR_URL="004380138556.dkr.ecr.us-east-1.amazonaws.com/java-maven-app"
AWS_REGION="us-east-1"

echo "=============================================================="
echo "🚀 Starting deployment for image: ${ECR_URL}:${IMAGE_NAME}"
echo "=============================================================="

# -------------------------------
# 1️⃣ Check and install Docker
# -------------------------------
if ! command -v docker &> /dev/null
then
  echo "🐳 Docker not found. Installing Docker..."
  sudo yum update -y
  sudo yum install -y docker
  sudo systemctl start docker
  sudo systemctl enable docker
  sudo usermod -aG docker ec2-user
  echo "✅ Docker installed successfully."
else
  echo "✅ Docker already installed."
fi

# -------------------------------
# 2️⃣ Check and install Docker Compose
# -------------------------------
if ! command -v docker-compose &> /dev/null
then
  echo "⚙️ Installing Docker Compose..."
  sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose
  echo "✅ Docker Compose installed successfully."
else
  echo "✅ Docker Compose already installed."
fi

# -------------------------------
# 3️⃣ Start Docker if not running
# -------------------------------
if ! sudo systemctl is-active --quiet docker
then
  echo "🔄 Starting Docker service..."
  sudo systemctl start docker
  sudo systemctl enable docker
  echo "✅ Docker service started."
fi

# -------------------------------
# 4️⃣ Login to AWS ECR
# -------------------------------
echo "🔐 Logging into AWS ECR..."
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_URL

# -------------------------------
# 5️⃣ Pull & Run Docker Container
# -------------------------------
echo "📦 Pulling Docker image: ${ECR_URL}:${IMAGE_NAME}"
docker pull ${ECR_URL}:${IMAGE_NAME}

echo "🛑 Stopping any existing container..."
docker rm -f java-maven-app || true

echo "🚀 Running container..."
docker run -d -p 8080:8080 --name java-maven-app ${ECR_URL}:${IMAGE_NAME}

echo "✅ Application deployed successfully!"
echo "🌐 Access your app at: http://$(curl -s ifconfig.me):8080"

echo "=============================================================="
echo "🎉 Deployment complete!"
echo "=============================================================="

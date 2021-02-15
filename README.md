# NodeJS CI/CD with Kops
- 1 - Launch EC2 instance.
- 2 - Create IAM Role with EC2, IAM, S3 and VPC Full Access permission.
- 3 - Attach role that you create to EC2 instance.
- 4 - Create a S3 bucket. Follow the steps from link https://kops.sigs.k8s.io/getting_started/aws/
    - aws s3api create-bucket --bucket <bucket-name> --region us-east-1
- 5 - Verify if bucket is created --> aws s3 ls
- 6 - Enable bucket versioning to prevent accidentally deletion.
    - aws s3api put-bucket-versioning --bucket <bucket-name> --versioning-configuration Status=Enabled
- 7 - Enable bucket encryption
    - aws s3api put-bucket-encryption --bucket <bucket-name> --server-side-encryption-configuration '{"Rules":[{"ApplyServerSideEncryptionByDefault":{"SSEAlgorithm":"AES256"}}]}'

# Install KOPS
- 1 - Download kubectl
    - curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
- 2 - Install kubectl 
    - sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
- 3 - Verify kubectl
    - kubectl version --client --short
- 4 - Download kops
    - curl -LO https://github.com/kubernetes/kops/releases/download/$(curl -s https://api.github.com/repos/kubernetes/kops/releases/latest | grep tag_name | cut -d '"' -f 4)/kops-linux-amd64
- 5 - Make the kops binary executable
    - chmod +x kops-linux-amd64
- 6 - Move the kops binary in to your PATH.
    - sudo mv kops-linux-amd64 /usr/local/bin/kops

# Create Cluster
- 1 - First set up environment variables to make the process easier.
    - export NAME=<cluster-name>.k8s.local
    - export KOPS_STATE_STORE=s3://<s3-bucket-name>
- 2 - Create ssh key (You have to create ssh key before you create a cluster)
    - ssh-keygen
- 3 - Create cluster
    - kops create cluster --zones=us-east-1a,us-east-1b ${NAME}
- 4 - Create kops secret
    - kops create secret --name ${NAME} sshpublickey admin -i ~/.ssh/id_rsa.pub 
- 5 - kops update cluster ${NAME} --yes --admin
    - kops rolling-update cluster

# Install Jenkins, Git and Docker
- 1 - You can install Jenkins to your Bootstrap(kops) instance or you can launch new instance.
- 2 - Install Java in order to install Jenkins.
    - sudo yum install java-1.8.0-openjdk.x86_64 -y
- 3 - Download and Install Jenkins
    - sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
    - sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
    - sudo yum install jenkins -y
- 4 - Start and Enable Jenkins service.
    - sudo systemctl start jenkins
    - sudo systemctl enable jenkins
- 5 - Install Git
    - yum install git -y
- 6 - Install Docker
    - yum install docker -y
- 7 - Add docker to "jenkins" and "ec2-user" users
    - usermod -aG docker jenkins
- 8 - Restart Jenkins service in order to apply changes.
    - systemctl restart jenkins
- 9 - Push image to DockerHub. In order to push image DockerHub we have to create Jenkins Credentials with docker username and password.
- 10 - Install Docker and Docker Pipeline plugins

# Nodejs Deployment and Service
- 1 - Create deployment file. See nodejs-deployment.yml
- 2 - Create service file. See nodejs-service.yml
- 3 - Install ssh agent plugin in order to connect from Jenkins to Kuburnetes cluster.
- 4 - 
SWARM_IP=$1
SWARM_USER=$2
SSH_PRIVATE_KEY=$3
DEPLOY_FILE=docker-compose.yml
STACK_NAME=t1
# loading section
echo "/-\|/-\|/-\|/-\|/-\|/-\|/-\|"
# end

echo $SSH_PRIVATE_KEY
mkdir -p ~/.ssh
echo "$SSH_PRIVATE_KEY" >> ~/.ssh/id_rsa
chmod 600 ~/.ssh/id_rsa

# Copy Docker configuration to Node manager
scp -i ~/.ssh/id_rsa ./deploy/$DEPLOY_FILE $SWARM_USER@$SWARM_IP:/home/ubuntu

ssh -tt -o StrictHostKeyChecking=no -i ~/.ssh/id_rsa $SWARM_USER@$SWARM_IP "sudo docker stack deploy -c /home/ubuntu/$DEPLOY_FILE $STACK_NAME"
echo "Deploy successfully"
SWARM_IP=$1
SWARM_USER=$2
SSH_PRIVATE_KEY=$3
DEPLOY_FILE=docker-compose.yml
STACK_NAME=t1

echo "/-\|/-\|/-\|/-\|/-\|/-\|/-\|"
mkdir -p ~/.ssh
echo "$SSH_PRIVATE_KEY" > ~/.ssh/id_rsa
chmod 600 ~/.ssh/id_rsa

sed -i "s/SWARM_IP/$SWARM_IP/g" ./deploy/$DEPLOY_FILE

scp -o StrictHostKeyChecking=no -i ~/.ssh/id_rsa ./deploy/$DEPLOY_FILE $SWARM_USER@$SWARM_IP:/home/$SWARM_USER
ssh -tt -o StrictHostKeyChecking=no -i ~/.ssh/id_rsa $SWARM_USER@$SWARM_IP "sudo docker stack deploy -c /home/$SWARM_USER/$DEPLOY_FILE $STACK_NAME"
echo "Deploy successfully"
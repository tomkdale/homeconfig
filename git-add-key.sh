ssh git@github.com 2>&1 >/dev/null | grep 'successfully' -q
if [ $? ]; then
  echo 'Github ssh already successful'
  exit 0
fi

read -p "Enter github email : " email
echo "Using email $email"
ssh-keygen -t rsa -b 4096 -C "$email"
ssh-add ~/.ssh/id_rsa
pub=`cat ~/.ssh/id_rsa.pub`
read -p "Enter github username: " githubuser
echo "Using username $githubuser"
read -s -p "Enter github password for user $githubuser: " githubpass
curl -u "$githubuser:$githubpass" -X POST -d "{\"title\":\"`hostname`\",\"key\":\"$pub\"}" https://api.github.com/user/keys

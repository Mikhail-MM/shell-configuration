##########################################
# Add User/Machine SSH Key to GitHub via API
##########################################

# Check number of lines in the file -- error if no file
# OAUTH_TOKEN' .env.github-auth | wc -l

read -p "Enter Github Developer Token: " OAUTH_TOKEN
touch .env.github-auth
echo "OAUTH_TOKEN='$OAUTH_TOKEN'" >> .env.github-auth
    
read -p 'Github Email:' GITHUB_EMAIL_ADDRESS
read -sp 'Github PW:' GITHUB_PASSWORD

## TODO - Check validity of .env file
source .env.github-auth

curl -H "Accept: application/vnd.github.v3+json"  -u "$GITHUB_ACCOUNT_EMAIL:$GITHUB_PW" https://api.github.com
read -p "Checking API Information. Press Enter to Continue."

RSA_KEY_PUBLIC="$(cat ~/.ssh/id_rsa.pub)"

read -p "Github SSH Key Title: " GITHUB_KEY_TITLE

formattedJson=$(cat <<EOF
    {
        "title": "$GITHUB_KEY_TITLE",
        "key": "$RSA_KEY_PUBLIC"
    }
EOF
)

echo $formattedJson

read -p "What is your GitHub username?" OAUTH_USER

curl --user "$OAUTH_USER=:$OAUTH_TOKEN" --data "$formattedJson" https://api.github.com/user/keys
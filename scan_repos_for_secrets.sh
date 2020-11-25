#!/usr/bin/env bash

installGitSecrets() {
  curl -sL https://raw.githubusercontent.com/awslabs/git-secrets/master/git-secrets >> git-secrets
  chmod +x git-secrets
  git config --global --unset secrets.patterns
}

scanRepository() {
  cd $1
  ./../git-secrets --add-provider -- cat ../git-secrets-pattern.txt > /dev/null
  ./../git-secrets --scan --recursive
}

fetchRepository() {
  git clone git@github.com:ThoughtWorks-DPS/$1.git $1
}

installGitSecrets
echo "Scanning secrets for repository: $1"
echo "------------------------"
fetchRepository $1
scanRepository $1
exitCode=$?
if [ $exitCode -ne 0 ]; then
  echo "Secrets found in $1! Sound the alarm!"
else
  echo "No secrets found in $1. Nothing to see here."
fi



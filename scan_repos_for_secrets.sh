#!/usr/bin/env bash

NUM_FAILED=0
ROOT_PATH=$(pwd)

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
  git clone -q git@github.com:ThoughtWorks-DPS/$1.git $1
}

checkScanOutput() {
  if [ $1 -ne 0 ]; then
    echo "Secrets found in $2! Sound the alarm!"
    NUM_FAILED=1
  else
    echo "No secrets found in $2. Nothing to see here."
  fi
}

fetchAndScanRepository() {
  echo "Scanning for secrets in repository: $1"
  echo "======================================"
  fetchRepository $1
  scanRepository $1
  checkScanOutput $? $1
}

installGitSecrets
for repo in "$@"
do
  fetchAndScanRepository $repo
  cd $ROOT_PATH
done

exit $NUM_FAILED
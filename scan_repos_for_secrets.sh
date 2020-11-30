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
  cd ..
}

fetchRepository() {
  git clone -q git@github.com:ThoughtWorks-DPS/$1.git $1
}

checkScanOutput() {
  if [ $1 -ne 0 ]; then
    echo "Secrets found! Sound the alarm!"
  else
    echo "No secrets found. Nothing to see here."
  fi
}

fetchAndScanRepository() {
  echo "Scanning repository: $1 for secrets"
  echo "======================================"
  fetchRepository $1
  scanRepository $1
  checkScanOutput $?
}

installGitSecrets
fetchAndScanRepository $1




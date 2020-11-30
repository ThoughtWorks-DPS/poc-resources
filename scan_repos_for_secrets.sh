#!/usr/bin/env bash

NUM_FAILED=0
ROOT_PATH=$(pwd)

setupGitSecrets() {
  curl -sL https://raw.githubusercontent.com/awslabs/git-secrets/master/git-secrets >>git-secrets
  chmod +x git-secrets
  git config --global --unset secrets.patterns
}

scanRecursively() {
  cd $1
  ./../git-secrets --add-provider -- cat ../git-secrets-pattern.txt >/dev/null
  ./../git-secrets --scan --recursive
}

fetchRepository() {
  git clone -q git@github.com:ThoughtWorks-DPS/$1.git $1
}

checkScanOutput() {
  if [ $1 -ne 0 ]; then
    echo "Secrets found in $2! Sound the alarm!"
    NUM_FAILED=$((NUM_FAILED + 1))
  else
    echo "No secrets found in $2. Nothing to see here."
  fi
}

scanRepository() {
  echo "======================================"
  echo "Scanning for secrets in repository: $1"
  fetchRepository $1
  scanRecursively $1
  checkScanOutput $? $1
  echo "======================================"
}

scanRepositories() {
  for repo in "$@"; do
    cd $ROOT_PATH
    scanRepository $repo
    cd $ROOT_PATH
  done
}

setupGitSecrets
scanRepositories "$@"

exit $NUM_FAILED

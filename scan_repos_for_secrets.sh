#!/usr/bin/env bash

NUM_FAILED=0
failed_repos=()
ROOT_PATH=$(pwd)
GITHUB_TOKEN=$(secrethub read vapoc/platform/svc/github/access-token)

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
  git clone -q https://$GITHUB_TOKEN@github.com/ThoughtWorks-DPS/$1 $1
}

checkScanOutput() {
  if [ $1 -ne 0 ]; then
    echo "Secrets found in $2! Sound the alarm!"
    failed_repos+=($2)
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

echo "Repos that failed:" ${failed_repos[*]}
exit $NUM_FAILED

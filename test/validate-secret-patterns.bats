#!/usr/bin/env bats

function setup {
  run bash -c "curl -sL https://raw.githubusercontent.com/awslabs/git-secrets/master/git-secrets >> git-secrets"
  run bash -c "chmod +x git-secrets"
}

@test "validate pem file matching" {
  run bash -c "touch bad.pem"
  run bash -c "echo BEGIN RSA PRIVATE KEY >> bad.pem"
  run bash -c "echo random text stuff thats encoded >> bad.pem"
  run bash -c "echo END RSA PRIVATE KEY >> bad.pem"

  run bash -c "./git-secrets --add-provider -- cat git-secrets-pattern.txt"
  run bash -c "./git-secrets --scan"
  [[ "${status}" -ne 0 ]]
}
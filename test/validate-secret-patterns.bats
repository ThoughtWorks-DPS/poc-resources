#!/usr/bin/env bats

function setup {
  run bash -c "curl -sL https://raw.githubusercontent.com/awslabs/git-secrets/master/git-secrets >> git-secrets"
  run bash -c "chmod +x git-secrets"
  run bash -c "./git-secrets --add-provider -- cat git-secrets-pattern.txt"
}

function teardown {
  run bash -c "rm git-secrets"
}

scanAndAssertNotZero() {
  run bash -c "./git-secrets --scan --untracked $1"
  [[ "${status}" -ne 0 ]]
}

scanAndAssertBadFile() {
  run bash -c "touch bad.txt"
  run bash -c "echo $1 > bad.txt"
  scanAndAssertNotZero "bad.txt"
}

@test "validate pem file matching" {
  run bash -c "touch bad.pem"
  run bash -c "echo BEGIN RSA PRIVATE KEY >> bad.pem"
  run bash -c "echo random text stuff thats encoded >> bad.pem"
  run bash -c "echo END RSA PRIVATE KEY >> bad.pem"

  scanAndAssertNotZero "bad.pem"
}

@test "validate AWS_ACCESS_KEY_ID prefix AKIA" { scanAndAssertBadFile "AKIA1234567890123456"; }
@test "validate AWS_ACCESS_KEY_ID prefix AGPA" { scanAndAssertBadFile "AGPA1234567890123456"; }
@test "validate AWS_ACCESS_KEY_ID prefix AIDA" { scanAndAssertBadFile "AIDA1234567890123456"; }
@test "validate AWS_ACCESS_KEY_ID prefix AROA" { scanAndAssertBadFile "AROA1234567890123456"; }
@test "validate AWS_ACCESS_KEY_ID prefix AIPA" { scanAndAssertBadFile "AIPA1234567890123456"; }
@test "validate AWS_ACCESS_KEY_ID prefix ANPA" { scanAndAssertBadFile "ANPA1234567890123456"; }
@test "validate AWS_ACCESS_KEY_ID prefix ANVA" { scanAndAssertBadFile "ANVA1234567890123456"; }
@test "validate AWS_ACCESS_KEY_ID prefix ASIA" { scanAndAssertBadFile "ASIA1234567890123456"; }

@test "validate aws_secret_access_key" { scanAndAssertBadFile "aws_secret_access_key"; }
@test "validate AWS_secret_access_key" { scanAndAssertBadFile "AWS_secret_access_key"; }
@test "validate aws_SECRET_access_key" { scanAndAssertBadFile "aws_SECRET_access_key"; }
@test "validate aws_secret_ACCESS_key" { scanAndAssertBadFile "aws_secret_ACCESS_key"; }
@test "validate aws_secret_access_KEY" { scanAndAssertBadFile "aws_secret_access_KEY"; }
@test "validate AWS_SECRET_access_key" { scanAndAssertBadFile "AWS_SECRET_access_key"; }
@test "validate AWS_secret_ACCESS_key" { scanAndAssertBadFile "AWS_secret_ACCESS_key"; }
@test "validate AWS_secret_access_KEY" { scanAndAssertBadFile "AWS_secret_access_KEY"; }
@test "validate aws_SECRET_ACCESS_key" { scanAndAssertBadFile "AWS_secret_access_KEY"; }
@test "validate aws_secret_ACCESS_KEY" { scanAndAssertBadFile "AWS_secret_access_KEY"; }
@test "validate aws_SECRET_access_KEY" { scanAndAssertBadFile "aws_SECRET_access_KEY"; }
@test "validate AWS_SECRET_ACCESS_key" { scanAndAssertBadFile "AWS_SECRET_ACCESS_key"; }
@test "validate AWS_SECRET_access_KEY" { scanAndAssertBadFile "AWS_SECRET_access_KEY"; }
@test "validate AWS_secret_ACCESS_KEY" { scanAndAssertBadFile "AWS_secret_ACCESS_KEY"; }
@test "validate aws_SECRET_ACCESS_KEY" { scanAndAssertBadFile "aws_SECRET_ACCESS_KEY"; }
@test "validate AWS_SECRET_ACCESS_KEY" { scanAndAssertBadFile "AWS_SECRET_ACCESS_KEY"; }

@test "validate kubeconfig token" {
  run bash -c "touch bad.kubeconfig"
  run bash -c "clusters: >> bad.kubeconfig"
  run bash -c "- cluster: >> bad.kubeconfig"
  run bash -c "contexts: >> bad.kubeconfig"
  run bash -c "- context: >> bad.kubeconfig"
  run bash -c "current_context: >> bad.kubeconfig"
  run bash -c "users: >> bad.kubeconfig"
  run bash -c "- name: >> bad.kubeconfig"
  [[ "${status}" -ne 0 ]]
}

@test "validate AWS_ACCOUNT_ID with numeric value of size 12 without spaces" { scanAndAssertBadFile "AWS_ACCOUNT_ID=012345678901"; }
@test "validate AWS_ACCOUNT_ID with numeric value of size 12 with spaces" { scanAndAssertBadFile "AWS_ACCOUNT_ID = 012345678901"; }
@test "validate AWS_ACCOUNT_ID with numeric value of size 12 with =" { scanAndAssertBadFile "AWS_ACCOUNT_ID = 012345678901"; }
@test "validate AWS_ACCOUNT_ID with numeric value of size 12 with :" { scanAndAssertBadFile "AWS_ACCOUNT_ID :012345678901"; }

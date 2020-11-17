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
  run bash -c "./git-secrets --scan"
  [[ "${status}" -ne 0 ]]
}

createBadFile() {
  run bash -c "touch bad.file"
  run bash -c "$1 > bad.file"
}

scanAndAssertBadFile() {
  createBadFile $1
  scanAndAssertNotZero
}

@test "validate pem file matching" {
  run bash -c "touch bad.pem"
  run bash -c "echo BEGIN RSA PRIVATE KEY >> bad.pem"
  run bash -c "echo random text stuff thats encoded >> bad.pem"
  run bash -c "echo END RSA PRIVATE KEY >> bad.pem"

  scanAndAssertNotZero
}

@test "validate AWS_ACCESS_KEY_ID prefix AKIA" { scanAndAssertBadFile "AKIA123456789012"; }
@test "validate AWS_ACCESS_KEY_ID prefix AGPA" { scanAndAssertBadFile "AGPA123456789012"; }
@test "validate AWS_ACCESS_KEY_ID prefix AIDA" { scanAndAssertBadFile "AIDA123456789012"; }
@test "validate AWS_ACCESS_KEY_ID prefix AROA" { scanAndAssertBadFile "AROA123456789012"; }
@test "validate AWS_ACCESS_KEY_ID prefix AIPA" { scanAndAssertBadFile "AIPA123456789012"; }
@test "validate AWS_ACCESS_KEY_ID prefix ANPA" { scanAndAssertBadFile "ANPA123456789012"; }
@test "validate AWS_ACCESS_KEY_ID prefix ANVA" { scanAndAssertBadFile "ANVA123456789012"; }
@test "validate AWS_ACCESS_KEY_ID prefix ASIA" { scanAndAssertBadFile "ASIA123456789012"; }

@test "validate AWS_ACCOUNT_ID pattern" { scanAndAssertBadFile "AWS_ACCOUNT_ID"; }
@test "validate AWS_ACCOUNT_id pattern" { scanAndAssertBadFile "AWS_ACCOUNT_id"; }
@test "validate AWS_ACCOUNT_Id pattern" { scanAndAssertBadFile "AWS_ACCOUNT_Id"; }
@test "validate AWS_account_ID pattern" { scanAndAssertBadFile "AWS_account_ID"; }
@test "validate AWS_account_id pattern" { scanAndAssertBadFile "AWS_account_id"; }
@test "validate AWS_account_Id pattern" { scanAndAssertBadFile "AWS_account_Id"; }
@test "validate AWS_Account_ID pattern" { scanAndAssertBadFile "AWS_Account_ID"; }
@test "validate AWS_Account_id pattern" { scanAndAssertBadFile "AWS_Account_id"; }
@test "validate AWS_Account_Id pattern" { scanAndAssertBadFile "AWS_Account_Id"; }
@test "validate aws_ACCOUNT_ID pattern" { scanAndAssertBadFile "aws_ACCOUNT_ID"; }
@test "validate aws_ACCOUNT_id pattern" { scanAndAssertBadFile "aws_ACCOUNT_id"; }
@test "validate aws_ACCOUNT_Id pattern" { scanAndAssertBadFile "aws_ACCOUNT_Id"; }
@test "validate aws_account_ID pattern" { scanAndAssertBadFile "aws_account_ID"; }
@test "validate aws_account_id pattern" { scanAndAssertBadFile "aws_account_id"; }
@test "validate aws_account_Id pattern" { scanAndAssertBadFile "aws_account_Id"; }
@test "validate aws_Account_ID pattern" { scanAndAssertBadFile "aws_Account_ID"; }
@test "validate aws_Account_id pattern" { scanAndAssertBadFile "aws_Account_id"; }
@test "validate aws_Account_Id pattern" { scanAndAssertBadFile "aws_Account_Id"; }
@test "validate Aws_ACCOUNT_ID pattern" { scanAndAssertBadFile "Aws_ACCOUNT_ID"; }
@test "validate Aws_ACCOUNT_id pattern" { scanAndAssertBadFile "Aws_ACCOUNT_id"; }
@test "validate Aws_ACCOUNT_Id pattern" { scanAndAssertBadFile "Aws_ACCOUNT_Id"; }
@test "validate Aws_account_ID pattern" { scanAndAssertBadFile "Aws_account_ID"; }
@test "validate Aws_account_id pattern" { scanAndAssertBadFile "Aws_account_id"; }
@test "validate Aws_account_Id pattern" { scanAndAssertBadFile "Aws_account_Id"; }
@test "validate Aws_Account_ID pattern" { scanAndAssertBadFile "Aws_Account_ID"; }
@test "validate Aws_Account_id pattern" { scanAndAssertBadFile "Aws_Account_id"; }
@test "validate Aws_Account_Id pattern" { scanAndAssertBadFile "Aws_Account_Id"; }

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
@test "validate AWS_ACCOUNT_ID with numeric value of size 12 with =" { scanAndAssertBadFile "AWS_ACCOUNT_ID 012345678901"; }
@test "validate AWS_ACCOUNT_ID with numeric value of size 12 with empty" { scanAndAssertBadFile "AWS_ACCOUNT_ID 012345678901"; }
@test "validate AWS_ACCOUNT_ID with numeric value of size 12 with => " { scanAndAssertBadFile "AWS_ACCOUNT_ID=> 012345678901"; }
@test "validate AWS_ACCOUNT_ID with numeric value of size 12 with :" { scanAndAssertBadFile "AWS_ACCOUNT_ID :012345678901"; }
@test "validate AWS_ACCOUNT_ID with numeric value of size 12 with single quote" { scanAndAssertBadFile "AWS_ACCOUNT_ID='012345678901'"; }
@test "validate AWS_ACCOUNT_ID with numeric value of size 12 with double quote" { scanAndAssertBadFile "AWS_ACCOUNT_ID \"012345678901\""; }

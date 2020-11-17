#!/usr/bin/env bats

function setup {
  run bash -c "curl -sL https://raw.githubusercontent.com/awslabs/git-secrets/master/git-secrets >> git-secrets"
  run bash -c "chmod +x git-secrets"
  run bash -c "./git-secrets --add-provider -- cat git-secrets-pattern.txt"
}
scanAndAssertNotZero() {
  run bash -c "./git-secrets --scan"
  [[ "${status}" -ne 0 ]]
}

createBadFile() {
  run bash -c "touch bad.file"
  run bash -c "$1 > bad.file"
}

@test "validate pem file matching" {
  run bash -c "touch bad.pem"
  run bash -c "echo BEGIN RSA PRIVATE KEY >> bad.pem"
  run bash -c "echo random text stuff thats encoded >> bad.pem"
  run bash -c "echo END RSA PRIVATE KEY >> bad.pem"

  scanAndAssertNotZero
}

@test "validate AWS_ACCESS_KEY_ID prefix AKIA" {
  createBadFile "AKIA123456789012"
  scanAndAssertNotZero
}

@test "validate AWS_ACCESS_KEY_ID prefix AGPA" {
  createBadFile "AGPA123456789012"
  scanAndAssertNotZero
}

@test "validate AWS_ACCESS_KEY_ID prefix AIDA" {
  createBadFile "AIDA123456789012"
  scanAndAssertNotZero
}

@test "validate AWS_ACCESS_KEY_ID prefix AROA" {
  createBadFile "AROA123456789012"
  scanAndAssertNotZero
}

@test "validate AWS_ACCESS_KEY_ID prefix AIPA" {
  createBadFile "AIPA123456789012"
  scanAndAssertNotZero
}

@test "validate AWS_ACCESS_KEY_ID prefix ANPA" {
  createBadFile "ANPA123456789012"
  scanAndAssertNotZero
}

@test "validate AWS_ACCESS_KEY_ID prefix ANVA" {
  createBadFile "ANVA123456789012"
  scanAndAssertNotZero
}

@test "validate AWS_ACCESS_KEY_ID prefix ASIA" {
  createBadFile "ASIA123456789012"
  scanAndAssertNotZero
}

@test "validate AWS_ACCOUNT_ID pattern" {
  createBadFile "AWS_ACCOUNT_ID";
  scanAndAssertNotZero;
}

@test "validate AWS_ACCOUNT_id pattern" {
  createBadFile "AWS_ACCOUNT_id";
  scanAndAssertNotZero;
}

@test "validate AWS_ACCOUNT_Id pattern" {
  createBadFile "AWS_ACCOUNT_Id";
  scanAndAssertNotZero;
}

@test "validate AWS_account_ID pattern" {
  createBadFile "AWS_account_ID";
  scanAndAssertNotZero;
}

@test "validate AWS_account_id pattern" {
  createBadFile "AWS_account_id";
  scanAndAssertNotZero;
}

@test "validate AWS_account_Id pattern" {
  createBadFile "AWS_account_Id";
  scanAndAssertNotZero;
}

@test "validate AWS_Account_ID pattern" {
  createBadFile "AWS_Account_ID";
  scanAndAssertNotZero;
}

@test "validate AWS_Account_id pattern" {
  createBadFile "AWS_Account_id";
  scanAndAssertNotZero;
}

@test "validate AWS_Account_Id pattern" {
  createBadFile "AWS_Account_Id";
  scanAndAssertNotZero;
}

@test "validate aws_ACCOUNT_ID pattern" {
  createBadFile "aws_ACCOUNT_ID";
  scanAndAssertNotZero;
}

@test "validate aws_ACCOUNT_id pattern" {
  createBadFile "aws_ACCOUNT_id";
  scanAndAssertNotZero;
}

@test "validate aws_ACCOUNT_Id pattern" {
  createBadFile "aws_ACCOUNT_Id";
  scanAndAssertNotZero;
}

@test "validate aws_account_ID pattern" {
  createBadFile "aws_account_ID";
  scanAndAssertNotZero;
}

@test "validate aws_account_id pattern" {
  createBadFile "aws_account_id";
  scanAndAssertNotZero;
}

@test "validate aws_account_Id pattern" {
  createBadFile "aws_account_Id";
  scanAndAssertNotZero;
}

@test "validate aws_Account_ID pattern" {
  createBadFile "aws_Account_ID";
  scanAndAssertNotZero;
}

@test "validate aws_Account_id pattern" {
  createBadFile "aws_Account_id";
  scanAndAssertNotZero;
}

@test "validate aws_Account_Id pattern" {
  createBadFile "aws_Account_Id";
  scanAndAssertNotZero;
}

@test "validate Aws_ACCOUNT_ID pattern" {
  createBadFile "Aws_ACCOUNT_ID";
  scanAndAssertNotZero;
}

@test "validate Aws_ACCOUNT_id pattern" {
  createBadFile "Aws_ACCOUNT_id";
  scanAndAssertNotZero;
}

@test "validate Aws_ACCOUNT_Id pattern" {
  createBadFile "Aws_ACCOUNT_Id";
  scanAndAssertNotZero;
}

@test "validate Aws_account_ID pattern" {
  createBadFile "Aws_account_ID";
  scanAndAssertNotZero;
}

@test "validate Aws_account_id pattern" {
  createBadFile "Aws_account_id";
  scanAndAssertNotZero;
}

@test "validate Aws_account_Id pattern" {
  createBadFile "Aws_account_Id";
  scanAndAssertNotZero;
}

@test "validate Aws_Account_ID pattern" {
  createBadFile "Aws_Account_ID";
  scanAndAssertNotZero;
}

@test "validate Aws_Account_id pattern" {
  createBadFile "Aws_Account_id";
  scanAndAssertNotZero;
}

@test "validate Aws_Account_Id pattern" {
  createBadFile "Aws_Account_Id";
  scanAndAssertNotZero;
}

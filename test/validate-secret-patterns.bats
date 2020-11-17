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
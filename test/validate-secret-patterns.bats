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

@test "validate pem file matching" {
  run bash -c "touch bad.pem"
  run bash -c "echo BEGIN RSA PRIVATE KEY >> bad.pem"
  run bash -c "echo random text stuff thats encoded >> bad.pem"
  run bash -c "echo END RSA PRIVATE KEY >> bad.pem"

  scanAndAssertNotZero
}

@test "validate AWS_ACCESS_KEY_ID prefix AKIA" {
  run bash -c "touch bad.credentials"
  run bash -c "AKIA123456789012 >> bad.credentials"

  scanAndAssertNotZero
}

@test "validate AWS_ACCESS_KEY_ID prefix AGPA" {
  run bash -c "touch bad.credentials"
  run bash -c "AGPA123456789012 >> bad.credentials"

  scanAndAssertNotZero
}

@test "validate AWS_ACCESS_KEY_ID prefix AIDA" {
  run bash -c "touch bad.credentials"
  run bash -c "AIDA123456789012 >> bad.credentials"

  scanAndAssertNotZero
}

@test "validate AWS_ACCESS_KEY_ID prefix AROA" {
    createBadFile "AROA123456789012"
  run bash -c "touch bad.credentials"
  run bash -c "AROA123456789012 >> bad.credentials"

  scanAndAssertNotZero
}

@test "validate AWS_ACCESS_KEY_ID prefix AIPA" {
  run bash -c "touch bad.credentials"
  run bash -c "AIPA123456789012 >> bad.credentials"

  scanAndAssertNotZero
}

@test "validate AWS_ACCESS_KEY_ID prefix ANPA" {
  run bash -c "touch bad.credentials"
  run bash -c "ANPA123456789012 >> bad.credentials"

  scanAndAssertNotZero
}

@test "validate AWS_ACCESS_KEY_ID prefix ANVA" {
  run bash -c "touch bad.credentials"
  run bash -c "ANVA123456789012 >> bad.credentials"

  scanAndAssertNotZero
}

@test "validate AWS_ACCESS_KEY_ID prefix ASIA" {
  run bash -c "touch bad.credentials"
  run bash -c "ASIA123456789012 >> bad.credentials"

  scanAndAssertNotZero
}
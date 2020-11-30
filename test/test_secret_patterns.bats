#!/usr/bin/env bats

function setup {
  run bash -c "curl -sL https://raw.githubusercontent.com/awslabs/git-secrets/master/git-secrets >> git-secrets"
  run bash -c "chmod +x git-secrets"
  run bash -c "git config --global --unset secrets.patterns"
  run bash -c "./git-secrets --add-provider -- cat git-secrets-pattern.txt"
}

function teardown {
  run bash -c "rm git-secrets"
}

scanAndAssertNotZero() {
  run bash -c "./git-secrets --scan --untracked bad.file"
  [[ "${status}" -ne 0 ]]
}

scanAndAssertZero(){
  run bash -c "./git-secrets --scan --untracked bad.file"
  [[ "${status}" = 0 ]]
}

scanAndAssertZeroBadFile() {
    createBadFile $1
    scanAndAssertZero
}

createBadFile() {
  run bash -c "touch bad.file"
  run bash -c "echo $1 > bad.file"
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
  run bash -c "./git-secrets --scan --untracked bad.pem"
  [[ "${status}" -ne 0 ]]
}

@test "validate password matching" { scanAndAssertBadFile "password=****"; }

@test "validate ssh-key matching" { scanAndAssertBadFile "^ssh-rsa"; }

@test "validate AWS_ACCESS_KEY_ID prefix AKIA" { scanAndAssertBadFile "AKIA1234567890123456"; }
@test "validate AWS_ACCESS_KEY_ID prefix AGPA" { scanAndAssertBadFile "AGPA1234567890123456"; }
@test "validate AWS_ACCESS_KEY_ID prefix AIDA" { scanAndAssertBadFile "AIDA1234567890123456"; }
@test "validate AWS_ACCESS_KEY_ID prefix AROA" { scanAndAssertBadFile "AROA1234567890123456"; }
@test "validate AWS_ACCESS_KEY_ID prefix AIPA" { scanAndAssertBadFile "AIPA1234567890123456"; }
@test "validate AWS_ACCESS_KEY_ID prefix ANPA" { scanAndAssertBadFile "ANPA1234567890123456"; }
@test "validate AWS_ACCESS_KEY_ID prefix ANVA" { scanAndAssertBadFile "ANVA1234567890123456"; }
@test "validate AWS_ACCESS_KEY_ID prefix ASIA" { scanAndAssertBadFile "ASIA1234567890123456"; }

@test "validate AWS_ACCOUNT_ID pattern" { scanAndAssertBadFile "AWS_ACCOUNT_ID:232372980378"; }
@test "validate AWS_ACCOUNT_id pattern" { scanAndAssertBadFile "AWS_ACCOUNT_id:232372980378"; }
@test "validate AWS_ACCOUNT_Id pattern" { scanAndAssertBadFile "AWS_ACCOUNT_Id:232372980378"; }
@test "validate AWS_account_ID pattern" { scanAndAssertBadFile "AWS_account_ID:232372980378"; }
@test "validate AWS_account_id pattern" { scanAndAssertBadFile "AWS_account_id:232372980378"; }
@test "validate AWS_account_Id pattern" { scanAndAssertBadFile "AWS_account_Id:232372980378"; }
@test "validate AWS_Account_ID pattern" { scanAndAssertBadFile "AWS_Account_ID:232372980378"; }
@test "validate AWS_Account_id pattern" { scanAndAssertBadFile "AWS_Account_id:232372980378"; }
@test "validate AWS_Account_Id pattern" { scanAndAssertBadFile "AWS_Account_Id=232372980378"; }
@test "validate aws_ACCOUNT_ID pattern" { scanAndAssertBadFile "aws_ACCOUNT_ID=232372980378"; }
@test "validate aws_ACCOUNT_id pattern" { scanAndAssertBadFile "aws_ACCOUNT_id=232372980378"; }
@test "validate aws_ACCOUNT_Id pattern" { scanAndAssertBadFile "aws_ACCOUNT_Id=232372980378"; }
@test "validate aws_account_ID pattern" { scanAndAssertBadFile "aws_account_ID=232372980378"; }
@test "validate aws_account_id pattern" { scanAndAssertBadFile "aws_account_id=232372980378"; }
@test "validate aws_account_Id pattern" { scanAndAssertBadFile "aws_account_Id=232372980378"; }
@test "validate aws_Account_ID pattern" { scanAndAssertBadFile "aws_Account_ID=232372980378"; }
@test "validate aws_Account_id pattern" { scanAndAssertBadFile "aws_Account_id=232372980378"; }
@test "validate aws_Account_Id pattern" { scanAndAssertBadFile "aws_Account_Id=232372980378"; }
@test "validate Aws_ACCOUNT_ID pattern" { scanAndAssertBadFile "Aws_ACCOUNT_ID=232372980378"; }
@test "validate Aws_ACCOUNT_id pattern" { scanAndAssertBadFile "Aws_ACCOUNT_id=232372980378"; }
@test "validate Aws_ACCOUNT_Id pattern" { scanAndAssertBadFile "Aws_ACCOUNT_Id=232372980378"; }
@test "validate Aws_account_ID pattern" { scanAndAssertBadFile "Aws_account_ID=232372980378"; }
@test "validate Aws_account_id pattern" { scanAndAssertBadFile "Aws_account_id=232372980378"; }
@test "validate Aws_account_Id pattern" { scanAndAssertBadFile "Aws_account_Id=232372980378"; }
@test "validate Aws_Account_ID pattern" { scanAndAssertBadFile "Aws_Account_ID=232372980378"; }
@test "validate Aws_Account_id pattern" { scanAndAssertBadFile "Aws_Account_id=232372980378"; }
@test "validate Aws_Account_Id pattern" { scanAndAssertBadFile "Aws_Account_Id=232372980378"; }

@test "validate aws_secret_access_key with value" { scanAndAssertBadFile "aws_secret_access_key=fak=AccessKeyfa7eA+cessKey5akeAcc/ssKeyf"; }
@test "validate AWS_secret_access_key with value" { scanAndAssertBadFile "AWS_secret_access_key=fak=AccessKeyfa7eA+cessKey5akeAcc/ssKeyf"; }
@test "validate aws_SECRET_access_key with value" { scanAndAssertBadFile "aws_SECRET_access_key=fak=AccessKeyfa7eA+cessKey5akeAcc/ssKeyf"; }
@test "validate aws_secret_ACCESS_key with value" { scanAndAssertBadFile "aws_secret_ACCESS_key=fak=AccessKeyfa7eA+cessKey5akeAcc/ssKeyf"; }
@test "validate aws_secret_access_KEY with value" { scanAndAssertBadFile "aws_secret_access_KEY=fak=AccessKeyfa7eA+cessKey5akeAcc/ssKeyf"; }
@test "validate AWS_SECRET_access_key with value" { scanAndAssertBadFile "AWS_SECRET_access_key=fak=AccessKeyfa7eA+cessKey5akeAcc/ssKeyf"; }
@test "validate AWS_secret_ACCESS_key with value" { scanAndAssertBadFile "AWS_secret_ACCESS_key=fak=AccessKeyfa7eA+cessKey5akeAcc/ssKeyf"; }
@test "validate AWS_secret_access_KEY with value" { scanAndAssertBadFile "AWS_secret_access_KEY=fak=AccessKeyfa7eA+cessKey5akeAcc/ssKeyf"; }
@test "validate aws_SECRET_ACCESS_key with value" { scanAndAssertBadFile "AWS_secret_access_KEY=fak=AccessKeyfa7eA+cessKey5akeAcc/ssKeyf"; }
@test "validate aws_secret_ACCESS_KEY with value" { scanAndAssertBadFile "AWS_secret_access_KEY=fak=AccessKeyfa7eA+cessKey5akeAcc/ssKeyf"; }
@test "validate aws_SECRET_access_KEY with value" { scanAndAssertBadFile "aws_SECRET_access_KEY=fak=AccessKeyfa7eA+cessKey5akeAcc/ssKeyf"; }
@test "validate AWS_SECRET_ACCESS_key with value" { scanAndAssertBadFile "AWS_SECRET_ACCESS_key=fak=AccessKeyfa7eA+cessKey5akeAcc/ssKeyf"; }
@test "validate AWS_SECRET_access_KEY with value" { scanAndAssertBadFile "AWS_SECRET_access_KEY=fak=AccessKeyfa7eA+cessKey5akeAcc/ssKeyf"; }
@test "validate AWS_secret_ACCESS_KEY with value" { scanAndAssertBadFile "AWS_secret_ACCESS_KEY=fak=AccessKeyfa7eA+cessKey5akeAcc/ssKeyf"; }
@test "validate aws_SECRET_ACCESS_KEY with value" { scanAndAssertBadFile "aws_SECRET_ACCESS_KEY=fak=AccessKeyfa7eA+cessKey5akeAcc/ssKeyf"; }
@test "validate AWS_SECRET_ACCESS_KEY with value" { scanAndAssertBadFile "AWS_SECRET_ACCESS_KEY=fak=AccessKeyfa7eA+cessKey5akeAcc/ssKeyf"; }

@test "validate KEY with value" { scanAndAssertBadFile "KEY=fak=AccessKeyfa7eA+cessKey5akeAcc/ssKeyf"; }
@test "validate Key with value" { scanAndAssertBadFile "Key=fak=AccessKeyfa7eA+cessKey5akeAcc/ssKeyf"; }
@test "validate key with value" { scanAndAssertBadFile "key=fak=AccessKeyfa7eA+cessKey5akeAcc/ssKeyf"; }

#There is another story to make these tests pass.
#Currently our patterns do not allow whitespaces
#and will not fail on GNU(linux distros) but will fail on BSD(macOS)

#@test "validate aws_secret_access_key value without setter" { scanAndAssertBadFile "aws_secret_access_key fak=AccessKeyfa7eA+cessKey5akeAcc/ssKeyf"; }
#@test "validate aws_secret_access_key value setter | :" { scanAndAssertBadFile "aws_secret_access_key : fak=AccessKeyfa7eA+cessKey5akeAcc/ssKeyf"; }
#@test "validate aws_secret_access_key value setter | =>" { scanAndAssertBadFile "aws_secret_access_key => fak=AccessKeyfa7eA+cessKey5akeAcc/ssKeyf"; }
#@test "validate aws_secret_access_key value setter | anything" { scanAndAssertBadFile "aws_secret_access_key > fak=AccessKeyfa7eA+cessKey5akeAcc/ssKeyf"; }
#@test "validate AWS_secret_ACCESS_KEY with space after key" { scanAndAssertBadFile "AWS_secret_ACCESS_KEY =fak=AccessKeyfa7eA+cessKey5akeAcc/ssKeyf"; }

@test "validate client-certificate-data kubeconfig token" { scanAndAssertBadFile "client-certificate-data:"; }
@test "validate certificate-authority-data kubeconfig token" { scanAndAssertBadFile "certificate-authority-data:"; }
@test "validate client-key-data kubeconfig token" { scanAndAssertBadFile "client-key-data:"; }

#sanity checks because we're only catching for non 0 exit status. git secrets can throw Invalid preceding regular expression which would make all the
#test pass since it is throwing an error.
@test "validate regular strings will not get caught" { scanAndAssertZeroBadFile "abcedfg"; }
@test "validate strings with 40 characters will not get caught" { scanAndAssertZeroBadFile "1234567890abcdefghijklmnopqrstuvwxyzfake"; }
@test "validate strings with only access key will not get caught" { scanAndAssertZeroBadFile "fak=AccessKeyfa7eA+cessKey5akeAcc/ssKeyf"; }

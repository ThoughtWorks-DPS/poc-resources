#!/usr/bin/env bats

function teardown() {
  run bash -c "git clean -dff"
}

@test "fetches git-secrets executable" {
  run bash -c "./scan_repos_for_secrets.sh"
  run bash -c "test -x git-secrets"

  [[ ${status} -eq 0 ]]
}

@test "unset any secrets that exist in git config" {
  run bash -c "./scan_repos_for_secrets.sh"
  run bash -c "git config --get secrets.patterns"

  [[ ${output} -eq "" ]]
}

@test "fetches git repository" {
  run bash -c "./scan_repos_for_secrets.sh poc-va-api"
  run bash -c "cd poc-va-api; git config --local remote.origin.url"

  [[ ${status} -eq 0 ]]
  [[ ${output} =~ "poc-va-api" ]]
}

@test "add scanning provider to fetched repository" {
  run bash -c "./scan_repos_for_secrets.sh poc-va-api"
  run bash -c "cd poc-va-api; git config --get --local secrets.providers"

  [[ ${status} -eq 0 ]]
  [[ ${output} =~ "cat ../git-secrets-pattern.txt" ]]
}

@test "passes when no secrets are found" {
  run bash -c "./scan_repos_for_secrets.sh poc-va-api"

  [[ ${status} -eq 0 ]]
  [[ ${output} =~ "No secrets found in poc-va-api. Nothing to see here." ]]
}

@test "passes when no secrets are found on multiple repositories" {
  run bash -c "./scan_repos_for_secrets.sh poc-va-api poc-va-cli poc-platform-servicemesh"

  [[ ${status} -eq 0 ]]
  [[ "${output}" =~ "No secrets found in poc-va-api. Nothing to see here." ]]
  [[ "${output}" =~ "No secrets found in poc-va-cli. Nothing to see here." ]]
  [[ "${output}" =~ "No secrets found in poc-platform-servicemesh. Nothing to see here." ]]
}

makeFakeRepo() {
  run bash -c "mkdir $1; cd $1; git init; echo aws_secret_access_key=fak=AccessKeyfa7eA+cessKey5akeAcc/ssKeyf > fakeKey.txt; git add fakeKey.txt; cd .."
}

@test "fails when secrets are found" {
  makeFakeRepo fake-repo
  run bash -c "./scan_repos_for_secrets.sh fake-repo"

  [[ ${output} =~ "Secrets found in fake-repo! Sound the alarm!" ]]
  [[ ${status} -eq 1 ]]
}

@test "fail when one out of multiple repos reports a secret" {
  makeFakeRepo fake-repo
  run bash -c "./scan_repos_for_secrets.sh poc-va-api poc-va-cli fake-repo"

  [[ "${output}" =~ "No secrets found in poc-va-api. Nothing to see here." ]]
  [[ "${output}" =~ "No secrets found in poc-va-cli. Nothing to see here." ]]
  [[ "${output}" =~ "Secrets found in fake-repo! Sound the alarm!" ]]
  [[ ${status} -eq 1 ]]
}

@test "exit code contains total failed repositories" {
  makeFakeRepo fake-repo
  run bash -c "./scan_repos_for_secrets.sh poc-resources poc-resources"

  [[ ${status} -eq 2 ]]
}
#!/usr/bin/env bats

function teardown() {
  run bash -c "git clean -dff"
}

@test "fetches executable git-secrets" {
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

@test "scans and finds no secrets" {
  run bash -c "./scan_repos_for_secrets.sh poc-va-api"

  [[ ${status} -eq 0 ]]
  [[ ${output} =~ "No secrets found in poc-va-api. Nothing to see here." ]]
}

@test "scans and finds secrets" {
  run bash -c "./scan_repos_for_secrets.sh poc-resources"

  [[ ${output} =~ "Secrets found in poc-resources! Sound the alarm!" ]]
  [[ ${status} -eq 1 ]]
}

@test "scans multiple repos based on input" {
  run bash -c "./scan_repos_for_secrets.sh poc-va-api poc-va-cli poc-platform-servicemesh"

  [[ ${status} -eq 0 ]]
  [ "${lines[2]}" = "No secrets found in poc-va-api. Nothing to see here." ]
  [ "${lines[5]}" = "No secrets found in poc-va-cli. Nothing to see here." ]
  [ "${lines[8]}" = "No secrets found in poc-platform-servicemesh. Nothing to see here." ]
}

@test "fail when one out of several repos reports a secret" {
  run bash -c "./scan_repos_for_secrets.sh poc-va-api poc-va-cli poc-resources"

  [[ "${output}" =~ "No secrets found in poc-va-api. Nothing to see here." ]]
  [[ "${output}" =~ "No secrets found in poc-va-cli. Nothing to see here." ]]
  [[ "${output}" =~ "Secrets found in poc-resources! Sound the alarm!" ]]
  [[ ${status} -eq 1 ]]
}
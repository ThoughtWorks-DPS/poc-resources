#!/usr/bin/env bats

#function setup { }
#function teardown { }

@test "validate echo statement" {
  run bash -c "./scan_repos_for_secrets.sh"

  [[ "${output}" =~ "scanning repository" ]]
}
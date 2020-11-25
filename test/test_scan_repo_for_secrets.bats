#!/usr/bin/env bats

#function setup { }
#function teardown { }

@test "validate echo statement" {
  run bash -c "./scan_repo_for_secrets.sh"

  [[ "${output}" =~ "scanning repository" ]]
}
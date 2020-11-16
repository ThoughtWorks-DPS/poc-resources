#!/usr/bin/env bats

@test "echo hello" {
  run bash -c "echo hello"
  [[ "${output}" == "hello" ]]
}
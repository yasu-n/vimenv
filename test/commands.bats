#!/usr/bin/env bats

load test_helper

@test "commands" {
  run vimenv-commands
  assert_success
  assert_line "init"
  assert_line "rehash"
  assert_line "shell"
  refute_line "sh-shell"
  assert_line "echo"
}

@test "commands --sh" {
  run vimenv-commands --sh
  assert_success
  refute_line "init"
  assert_line "shell"
}

@test "commands --no-sh" {
  run vimenv-commands --no-sh
  assert_success
  assert_line "init"
  refute_line "shell"
}

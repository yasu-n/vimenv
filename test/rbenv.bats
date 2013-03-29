#!/usr/bin/env bats

load test_helper

@test "blank invocation" {
  run vimenv
  assert_success
  assert [ "${lines[0]}" = "vimenv 0.4.0" ]
}

@test "invalid command" {
  run vimenv does-not-exist
  assert_failure
  assert_output "vimenv: no such command \`does-not-exist'"
}

@test "default VIMENV_ROOT" {
  VIMENV_ROOT="" HOME=/home/mislav run vimenv root
  assert_success
  assert_output "/home/mislav/.vimenv"
}

@test "inherited VIMENV_ROOT" {
  VIMENV_ROOT=/opt/vimenv run vimenv root
  assert_success
  assert_output "/opt/vimenv"
}

@test "default VIMENV_DIR" {
  run vimenv echo VIMENV_DIR
  assert_output "$(pwd)"
}

@test "inherited VIMENV_DIR" {
  dir="${BATS_TMPDIR}/myproject"
  mkdir -p "$dir"
  VIMENV_DIR="$dir" run vimenv echo VIMENV_DIR
  assert_output "$dir"
}

@test "invalid VIMENV_DIR" {
  dir="${BATS_TMPDIR}/does-not-exist"
  assert [ ! -d "$dir" ]
  VIMENV_DIR="$dir" run vimenv echo VIMENV_DIR
  assert_failure
  assert_output "vimenv: cannot change working directory to \`$dir'"
}

#!/usr/bin/env bats

load test_helper

@test "no shims" {
  run vimenv-shims
  assert_success
  assert [ -z "$output" ]
}

@test "shims" {
  mkdir -p "${VIMENV_ROOT}/shims"
  touch "${VIMENV_ROOT}/shims/vim"
  run vimenv-shims
  assert_success
  assert_line "${VIMENV_ROOT}/shims/vim"
}

@test "shims --short" {
  mkdir -p "${VIMENV_ROOT}/shims"
  touch "${VIMENV_ROOT}/shims/vim"
  run vimenv-shims --short
  assert_success
  assert_line "vim"
}

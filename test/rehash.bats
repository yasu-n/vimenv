#!/usr/bin/env bats

load test_helper

@test "empty rehash" {
  assert [ ! -d "${VIMENV_ROOT}/shims" ]
  run vimenv-rehash
  assert_success
  assert [ -d "${VIMENV_ROOT}/shims" ]
  rmdir "${VIMENV_ROOT}/shims"
}

@test "non-writable shims directory" {
  mkdir -p "${VIMENV_ROOT}/shims"
  chmod -w "${VIMENV_ROOT}/shims"
  run vimenv-rehash
  assert_failure
  assert_output "vimenv: cannot rehash: ${VIMENV_ROOT}/shims isn't writable"
}

@test "rehash in progress" {
  mkdir -p "${VIMENV_ROOT}/shims"
  touch "${VIMENV_ROOT}/shims/.vimenv-shim"
  run vimenv-rehash
  assert_failure
  assert_output "vimenv: cannot rehash: ${VIMENV_ROOT}/shims/.vimenv-shim exists"
}

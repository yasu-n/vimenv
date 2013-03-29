#!/usr/bin/env bats

load test_helper

@test "creates shims and versions directories" {
  assert [ ! -d "${VIMENV_ROOT}/shims" ]
  assert [ ! -d "${VIMENV_ROOT}/versions" ]
  run vimenv-init -
  assert_success
  assert [ -d "${VIMENV_ROOT}/shims" ]
  assert [ -d "${VIMENV_ROOT}/versions" ]
}

@test "auto rehash" {
  run vimenv-init -
  assert_success
  assert_line "vimenv rehash 2>/dev/null"
}

@test "setup shell completions" {
  export SHELL=/bin/bash
  root="$(cd $BATS_TEST_DIRNAME/.. && pwd)"
  run vimenv-init -
  assert_success
  assert_line 'source "'${root}'/libexec/../completions/vimenv.bash"'
}

@test "option to skip rehash" {
  run vimenv-init - --no-rehash
  assert_success
  refute_line "vimenv rehash 2>/dev/null"
}

@test "adds shims to PATH" {
  export PATH="${BATS_TEST_DIRNAME}/../libexec:/usr/bin:/bin"
  run vimenv-init -
  assert_success
  assert_line 0 'export PATH="'${VIMENV_ROOT}'/shims:${PATH}"'
}

@test "doesn't add shims to PATH more than once" {
  export PATH="${VIMENV_ROOT}/shims:$PATH"
  run vimenv-init -
  assert_success
  refute_line 'export PATH="'${VIMENV_ROOT}'/shims:${PATH}"'
}

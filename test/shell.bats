#!/usr/bin/env bats

load test_helper

@test "no shell version" {
  mkdir -p "${VIMENV_TEST_DIR}/myproject"
  cd "${VIMENV_TEST_DIR}/myproject"
  echo "1.2.3" > .vim-version
  VIMENV_VERSION="" run vimenv-sh-shell
  assert_failure "vimenv: no shell-specific version configured"
}

@test "shell version" {
  VIMENV_VERSION="1.2.3" run vimenv-sh-shell
  assert_success 'echo "$VIMENV_VERSION"'
}

@test "shell unset" {
  run vimenv-sh-shell --unset
  assert_success "unset VIMENV_VERSION"
}

@test "shell change invalid version" {
  run vimenv-sh-shell 1.2.3
  assert_failure
  assert_line "vimenv: version \`1.2.3' not installed"
  assert_line "return 1"
}

@test "shell change version" {
  mkdir -p "${VIMENV_ROOT}/versions/1.2.3"
  run vimenv-sh-shell 1.2.3
  assert_success 'export VIMENV_VERSION="1.2.3"'
  refute_line "return 1"
}

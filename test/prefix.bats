#!/usr/bin/env bats

load test_helper

@test "prefix" {
  mkdir -p "${VIMENV_TEST_DIR}/myproject"
  cd "${VIMENV_TEST_DIR}/myproject"
  echo "1.2.3" > .vim-version
  mkdir -p "${VIMENV_ROOT}/versions/1.2.3"
  run vimenv-prefix
  assert_success "${VIMENV_ROOT}/versions/1.2.3"
}

@test "prefix for invalid version" {
  VIMENV_VERSION="1.2.3" run vimenv-prefix
  assert_failure "vimenv: version \`1.2.3' not installed"
}

@test "prefix for system" {
  mkdir -p "${VIMENV_TEST_DIR}/bin"
  touch "${VIMENV_TEST_DIR}/bin/vim"
  chmod +x "${VIMENV_TEST_DIR}/bin/vim"
  VIMENV_VERSION="system" run vimenv-prefix
  assert_success "$VIMENV_TEST_DIR"
}

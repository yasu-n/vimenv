#!/usr/bin/env bats

load test_helper

setup() {
  mkdir -p "${VIMENV_TEST_DIR}/myproject"
  cd "${VIMENV_TEST_DIR}/myproject"
}

@test "no version" {
  assert [ ! -e "${PWD}/.vim-version" ]
  run vimenv-local
  assert_failure "vimenv: no local version configured for this directory"
}

@test "local version" {
  echo "1.2.3" > .vim-version
  run vimenv-local
  assert_success "1.2.3"
}

@test "ignores version in parent directory" {
  echo "1.2.3" > .vim-version
  mkdir -p "subdir" && cd "subdir"
  run vimenv-local
  assert_failure
}

@test "ignores VIMENV_DIR" {
  echo "1.2.3" > .vim-version
  mkdir -p "$HOME"
  echo "2.0-home" > "${HOME}/.vim-version"
  VIMENV_DIR="$HOME" run vimenv-local
  assert_success "1.2.3"
}

@test "sets local version" {
  mkdir -p "${VIMENV_ROOT}/versions/1.2.3"
  run vimenv-local 1.2.3
  assert_success ""
  assert [ "$(cat .vim-version)" = "1.2.3" ]
}

@test "changes local version" {
  echo "1.0-pre" > .vim-version
  mkdir -p "${VIMENV_ROOT}/versions/1.2.3"
  run vimenv-local
  assert_success "1.0-pre"
  run vimenv-local 1.2.3
  assert_success ""
  run vimenv-local
  assert_success "1.2.3"
}

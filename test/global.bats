#!/usr/bin/env bats

load test_helper

@test "default" {
  run vimenv global
  assert_success
  assert_output "system"
}

@test "read VIMENV_ROOT/version" {
  mkdir -p "$VIMENV_ROOT"
  echo "1.2.3" > "$VIMENV_ROOT/version"
  run vimenv-global
  assert_success
  assert_output "1.2.3"
}

@test "set VIMENV_ROOT/version" {
  mkdir -p "$VIMENV_ROOT/versions/1.2.3"
  run vimenv-global "1.2.3"
  assert_success
  run vimenv global
  assert_success "1.2.3"
}

@test "fail setting invalid VIMENV_ROOT/version" {
  mkdir -p "$VIMENV_ROOT"
  run vimenv-global "1.2.3"
  assert_failure "vimenv: version \`1.2.3' not installed"
}

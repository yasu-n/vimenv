#!/usr/bin/env bats

load test_helper

create_hook() {
  mkdir -p "$1/$2"
  touch "$1/$2/$3"
}

@test "prints usage help given no argument" {
  run vimenv-hooks
  assert_failure "Usage: vimenv hooks <command>"
}

@test "prints list of hooks" {
  path1="${VIMENV_TEST_DIR}/vimenv.d"
  path2="${VIMENV_TEST_DIR}/etc/vimenv_hooks"
  create_hook "$path1" exec "hello.bash"
  create_hook "$path1" exec "ahoy.bash"
  create_hook "$path1" exec "invalid.sh"
  create_hook "$path1" which "boom.bash"
  create_hook "$path2" exec "bueno.bash"

  VIMENV_HOOK_PATH="$path1:$path2" run vimenv-hooks exec
  assert_success
  assert_line 0 "${VIMENV_TEST_DIR}/vimenv.d/exec/ahoy.bash"
  assert_line 1 "${VIMENV_TEST_DIR}/vimenv.d/exec/hello.bash"
  assert_line 2 "${VIMENV_TEST_DIR}/etc/vimenv_hooks/exec/bueno.bash"
}

@test "resolves relative paths" {
  path="${VIMENV_TEST_DIR}/vimenv.d"
  create_hook "$path" exec "hello.bash"
  mkdir -p "$HOME"

  VIMENV_HOOK_PATH="${HOME}/../vimenv.d" run vimenv-hooks exec
  assert_success "${VIMENV_TEST_DIR}/vimenv.d/exec/hello.bash"
}

@test "resolves symlinks" {
  path="${VIMENV_TEST_DIR}/vimenv.d"
  mkdir -p "${path}/exec"
  mkdir -p "$HOME"
  touch "${HOME}/hola.bash"
  ln -s "../../home/hola.bash" "${path}/exec/hello.bash"

  VIMENV_HOOK_PATH="$path" run vimenv-hooks exec
  assert_success "${HOME}/hola.bash"
}

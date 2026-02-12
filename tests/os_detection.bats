#!/usr/bin/env bats

setup() {
  ROOT="$BATS_TEST_DIRNAME/.."
}

@test "detects debian distro from os-release" {
  tmp="$(mktemp)"
  cat >"$tmp" <<EOS
ID=ubuntu
ID_LIKE=debian
EOS
  run bash -c "source '$ROOT/lib/common.sh'; source '$ROOT/lib/os.sh'; LU_OS_RELEASE_FILE='$tmp'; lu_detect_os; echo \"$LU_DISTRO/$LU_PKG_MGR\""
  [ "$status" -eq 0 ]
  [ "$output" = "debian/apt" ]
}

@test "detects alpine distro from os-release" {
  tmp="$(mktemp)"
  cat >"$tmp" <<EOS
ID=alpine
EOS
  run bash -c "source '$ROOT/lib/common.sh'; source '$ROOT/lib/os.sh'; LU_OS_RELEASE_FILE='$tmp'; lu_detect_os; echo \"$LU_DISTRO/$LU_PKG_MGR\""
  [ "$status" -eq 0 ]
  [ "$output" = "alpine/apk" ]
}

@test "routes to command handlers" {
  run "$ROOT/bin/linuxutils" help search firewall
  [ "$status" -eq 0 ]
  [[ "$output" == *"firewall"* ]]
}

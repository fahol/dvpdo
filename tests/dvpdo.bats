setup() {
    # Diretories from the repository relative to the test filename
    ROOT="$( cd "$( dirname "$BATS_TEST_FILENAME" )/.." >/dev/null 2>&1 && pwd )"
    load ${ROOT}/tests/lib/bats-support/load
    load ${ROOT}/tests/lib/bats-assert/load
    load ${ROOT}/tests/lib/bats-file/load
    load ${ROOT}/tests/lib/bats-detik/lib/utils
    load ${ROOT}/tests/lib/bats-detik/lib/detik

    # Ensure we re-use the downloaded binaries
    FILE_DST=${ROOT}/.tmp/bin
    assert_exist ${FILE_DST}/oc
    assert_exist ${FILE_DST}/kubectl

    # The dvpdo commandline file
    DP=${ROOT}/bin/dvpdo

    # Check k8s auth
    skip_k8s_if_not_auth() {
        if [[ ! -e ${ROOT}/.tmp/has_k8s_auth ]]; then
            skip
        fi
        return 0
    }
}

@test "dvpdo can be run as a command" {
    ${DP}
}

@test "dvpdo can be loaded properly" {
    load ${DP}
    assert_exist ${DVPDO_HOME}/bin/dvpdo
    assert_equal ${DVPDO_HOME} $(realpath ${ROOT})
}

@test "dvpdo_handle_cmd - basic dispatch" {
    # Help message
    run -0 ${DP} -h
    assert_output --partial '[dvpdo]'

    # Non existant command
    run -127 ${DP} non-existant-lvl1
    assert_line --index 0 'error: Invalid command non-existant-lvl1'

    # The template command for testing
    run -0 ${DP} template
    assert_line --index 0 '[dvpdo - template]'

    run -0 ${DP} template -h
    assert_line --index 0 '[dvpdo - template]'

    run -0 ${DP} template sub1
    assert_line --index 0 'command sub1'

    run -0 ${DP} template sub2
    assert_line --index 0 'command sub2'

    run -127 ${DP} template non-existant
    assert_line --index 0 'error: Invalid command non-existant'
}

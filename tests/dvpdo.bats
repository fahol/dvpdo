setup() {
    # Diretories from the repository relative to the test filename
    ROOT="$( cd "$( dirname "$BATS_TEST_FILENAME" )/.." >/dev/null 2>&1 && pwd )"
    load ${ROOT}/tests/lib/bats-support/load
    load ${ROOT}/tests/lib/bats-assert/load
    load ${ROOT}/tests/lib/bats-file/load

    # Load dvpdo
    FILE_DST=${ROOT}/.tmp/bin
    . ${ROOT}/bin/dvpdo

    # Ensure we re-use the downloaded binaries
    assert_exist ${FILE_DST}/oc
    assert_exist ${FILE_DST}/kubectl

    TMP_DIR=${ROOT}/.tmp/bin

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

#
# Downloaders for external binaries
#

@test "ensure_cli - openshift client can be downloaded and run properly" {
    ensure_cli_openshift ${TMP_DIR}
    # Openshift CLI
    assert_exist ${TMP_DIR}/oc
    ${TMP_DIR}/oc
    # Kubectl CLI
    assert_exist ${TMP_DIR}/kubectl
    ${TMP_DIR}/kubectl
}

@test "ensure_cli - vscode can be downloaded an run properly" {
    ensure_cli_vscode ${TMP_DIR}
    assert_exist ${TMP_DIR}/code
    ${TMP_DIR}/code --help
}

@test "ensure_cli - micromamba can be downloaded an run properly" {
    ensure_cli_micromamba ${TMP_DIR}
    assert_exist ${TMP_DIR}/micromamba
    ${TMP_DIR}/micromamba
}

#
# adhoc_pod on k8s
#

@test "adhoc_pod_exec - check basics" {
    skip_k8s_if_not_auth
    adhoc_pod_exec bash -l -c '[[ -e /bin && -e /sbin ]]'
}


@test "dvpdo can be run as a command" {
    ${DP}
}

#
# Main command
#

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

#!/bin/bash

# Include Beaker environment
. /usr/share/beakerlib/beakerlib.sh || exit 1

examples="/usr/share/doc/tmt/examples/systemd"

rlJournalStart
    rlPhaseStartSetup
        rlAssertRpm "tmt"
        rlRun "TmpDir=\$(mktemp -d)" 0 "Creating tmp directory"
        rlRun "cp example-test.txt $TmpDir/test.fmf"
        rlRun "cp example-testset.txt $TmpDir/testset.fmf"
        rlRun "pushd $TmpDir"
        rlRun "fmf init"
        rlRun "set -o pipefail"
    rlPhaseEnd

    rlPhaseStartTest "Test listing available tests"
        rlRun "tmt test ls | tee output"
        rlAssertGrep "/test/basic/smoke" "output"
        rlAssertNotGrep "/testset/smoke" "output"
    rlPhaseEnd

    rlPhaseStartTest "Test listing available testsets"
        rlRun "tmt testset ls | tee output"
        rlAssertGrep "/testset/smoke" "output"
        rlAssertNotGrep "/test/basic/smoke" "output"
    rlPhaseEnd

    rlPhaseStartCleanup
        rlRun "popd"
        rlRun "rm -r $TmpDir" 0 "Removing tmp directory"
    rlPhaseEnd
rlJournalEnd

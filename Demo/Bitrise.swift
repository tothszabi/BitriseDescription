// BitriseDescription: 0.0.1

import BitriseDescription

// This example is taken from https://bitrise.io/blog/post/beyond-the-basics-an-in-depth-look-at-bitrise-pipelines

let exportScript = """
#!/usr/bin/env bash

set -eo pipefail


for item in "${BITRISE_UI_TEST_XCRESULT_PATH}" "${BITRISE_UNIT_TEST_XCRESULT_PATH}";

  do

    echo "Exporting ${item}"


    test_name=$(basename "$item" .xcresult)

    echo "Test name: $test_name"


    test_dir="${BITRISE_TEST_RESULT_DIR}/${test_name}"

    mkdir -p "${test_dir}"

    echo "Moving test result to: ${test_dir}"

    cp -R "${item}" "${test_dir}/$(basename ${item})"


    test_info="${test_dir}/test-info.json"

    echo "Creating Test info at: ${test_info}"

    echo "{ \"test-name\": \"${test_name}\" }" > "$test_info"

  done
"""

let bitrise = Bitrise(
    formatVersion: .v13,
    projectType: .iOS,
    virtualMachine: .virtualMachine(
        stack: .xcode_15_2_x,
        machine: .m1_large
    ),
    app: .app(envs: [
        .env(
            key: "BITRISE_PROJECT_PATH",
            value: "BullsEye.xcworkspace"
        ),
        .env(
            key: "BITRISE_SCHEME",
            value: "BullsEye"
        ),
    ]),
    triggerMap: [
        .triggerMap(
            target: .pipeline("build_and_run_tests"),
            pullRequestSourceBranch: "*"
        )
    ],
    pipelines: [
        .pipeline(
            "build_and_run_tests",
            stages: [
                .stage("build_tests"),
                .stage("run_tests"),
                .stage("deploy_test_results"),
                .stage("send_notifications"),
            ]
        )
    ],
    stages: [
        .stage(
            "build_tests",
            shouldAlwaysRun: true,
            workflows: [
                .workflow("xcode_build_for_test")
            ]
        ),
        .stage(
            "run_tests",
            abortOnFail: true,
            workflows: [
                .workflow("run_ui_tests"),
                .workflow("run_unit_tests")
            ]
        ),
        .stage(
            "deploy_test_results",
            workflows: [
                .workflow("merge_and_deploy_test_results")
            ]
        ),
        .stage(
            "send_notifications",
            workflows: [
                .workflow(
                    "send_slack_notification",
                    runIf: #"'{{ getenv "SLACK_URL" | eq "URL here" }}'"#
                )
            ]
        )
    ],
    workflows: [
        .workflow(
            "_pull_test_bundle",
            steps: [
                .step(
                    identifier: "pull-intermediate-files",
                    majorVersion: 1,
                    inputs: [
                        .input(
                            key: "artifact_sources",
                            value: "build_tests.xcode_build_for_test"
                        )
                    ]
                )
            ]
        ),
        .workflow(
            "merge_and_deploy_test_results",
            steps: [
                .step(
                    identifier: "pull-intermediate-files",
                    majorVersion: 1,
                    inputs: [
                        .input(
                            key: "artifact_sources",
                            value: #"run_tests\..*"#
                        )
                    ]
                ),
                .step(
                    identifier: "script",
                    majorVersion: 1,
                    inputs: [
                        .input(
                            key: "content",
                            value: exportScript
                        )
                    ]
                ),
                .step(
                    identifier: "deploy-to-bitrise-io",
                    majorVersion: 2
                )
            ]
        ),
        .workflow(
            "run_ui_tests",
            beforeRun: [
                "_pull_test_bundle"
            ],
            steps: [
                .step(
                    identifier: "xcode-test-without-building",
                    majorVersion: 0,
                    inputs: [
                        .input(
                            key: "xctestrun",
                            value: "$BITRISE_TEST_BUNDLE_PATH/BullsEye_UnitTests_iphonesimulator15.2-arm64-x86_64.xctestrun"
                        ),
                        .input(
                            key: "destination",
                            value: "platform=iOS Simulator,name=iPhone 12 Pro Max"
                        ),
                    ]
                ),
                .step(
                    identifier: "deploy-to-bitrise-io",
                    majorVersion: 2,
                    inputs: [
                        .input(
                            key: "pipeline_intermediate_files",
                            value: "$BITRISE_XCRESULT_PATH:BITRISE_UNIT_TEST_XCRESULT_PATH"
                        )
                    ]
                )
            ]
        ),
        .workflow(
            "run_unit_tests",
            beforeRun: [
                "_pull_test_bundle"
            ],
            steps: [
                .step(
                    identifier: "",
                    majorVersion: 0,
                    inputs: [
                        .input(
                            key: "xctestrun",
                            value: "$BITRISE_TEST_BUNDLE_PATH/BullsEye_UnitTests_iphonesimulator15.2-arm64-x86_64.xctestrun"
                        ),
                        .input(
                            key: "destination",
                            value: "platform=iOS Simulator,name=iPhone 12 Pro Max"
                        )
                    ]
                ),
                .step(
                    identifier: "deploy-to-bitrise-io",
                    majorVersion: 2,
                    inputs: [
                        .input(
                            key: "pipeline_intermediate_files",
                            value: "$BITRISE_XCRESULT_PATH:BITRISE_UNIT_TEST_XCRESULT_PATH"
                        )
                    ]
                )
            ]
        ),
        .workflow(
            "xcode_build_for_test",
            steps: [
                .step(
                    identifier: "activate-ssh-key",
                    majorVersion: 4
                ),
                .step(
                    identifier: "git-clone",
                    majorVersion: 8
                ),
                .step(
                    identifier: "xcode-build-for-test",
                    majorVersion: 2,
                    inputs: [
                        .input(
                            key: "destination",
                            value: "generic/platform=iOS Simulator"
                        )
                    ]
                ),
                .step(
                    identifier: "share-pipeline-variable",
                    majorVersion: 1,
                    runIf: ".IsCI",
                    inputs: [
                        .input(
                            key: "variables",
                            value: "TEST_BUNDLE_ZIP_PATH=$BITRISE_TEST_BUNDLE_ZIP_PATH"
                        )
                    ]
                ),
                .step(
                    identifier: "deploy-to-bitrise-io",
                    majorVersion: 2,
                    inputs: [
                        .input(
                            key: "pipeline_intermediate_files",
                            value: "$BITRISE_TEST_BUNDLE_PATH:BITRISE_TEST_BUNDLE_PATH"
                        )
                    ]
                )
            ]
        ),
        .workflow(
            "send_slack_notification",
            steps: [
                .step(
                    identifier: "slack",
                    majorVersion: 3
                )
            ]
        )
    ]
)

//
//  Step.swift
//  BitriseDescription
//
//  Created by Szabolcs Toth on 05/02/2024.
//

import Foundation

public struct Step {
    public typealias Second = TimeInterval
    
    public let source: Source
    public let title: String?
    public let isAlwaysRun: Bool?
    public let isSkippable: Bool?
    public let runIf: String?
    public let timeout: Second?
    public let noOutputTimeout: Second?
    public let inputs: [EnvironmentItemModel]?
    public let outputs: [EnvironmentItemModel]?

    init(
        source: Source,
        title: String? = nil,
        isAlwaysRun: Bool? = nil,
        isSkippable: Bool? = nil,
        runIf: String? = nil,
        timeout: Second? = nil,
        noOutputTimeout: Second? = nil,
        inputs: [EnvironmentItemModel]? = nil,
        outputs: [EnvironmentItemModel]? = nil
    ) {
        self.source = source
        self.title = title
        self.isAlwaysRun = isAlwaysRun
        self.isSkippable = isSkippable
        self.runIf = runIf
        self.timeout = timeout
        self.noOutputTimeout = noOutputTimeout
        self.inputs = inputs
        self.outputs = outputs
    }
}

public extension Step {
    static func step(
        source: Source,
        title: String? = nil,
        isAlwaysRun: Bool? = nil,
        isSkippable: Bool? = nil,
        runIf: String? = nil,
        timeout: Second? = nil,
        noOutputTimeout: Second? = nil,
        inputs: [EnvironmentItemModel]? = nil,
        outputs: [EnvironmentItemModel]? = nil
    ) -> Step {
        return Step(
            source: source,
            title: title,
            isAlwaysRun: isAlwaysRun,
            isSkippable: isSkippable,
            runIf: runIf,
            timeout: timeout,
            noOutputTimeout: noOutputTimeout,
            inputs: inputs,
            outputs: outputs
        )
    }
    
    static func step(
        identifier: String,
        version: Step.Version,
        title: String? = nil,
        isAlwaysRun: Bool? = nil,
        isSkippable: Bool? = nil,
        runIf: String? = nil,
        timeout: Second? = nil,
        noOutputTimeout: Second? = nil,
        inputs: [EnvironmentItemModel]? = nil,
        outputs: [EnvironmentItemModel]? = nil
    ) -> Step {
        return Step(
            source: .steplib(
                identifier: identifier,
                version: version
            ),
            title: title,
            isAlwaysRun: isAlwaysRun,
            isSkippable: isSkippable,
            runIf: runIf,
            timeout: timeout,
            noOutputTimeout: noOutputTimeout,
            inputs: inputs,
            outputs: outputs
        )
    }
    
    static func step(
        identifier: String,
        majorVersion: UInt,
        title: String? = nil,
        isAlwaysRun: Bool? = nil,
        isSkippable: Bool? = nil,
        runIf: String? = nil,
        timeout: Second? = nil,
        noOutputTimeout: Second? = nil,
        inputs: [EnvironmentItemModel]? = nil,
        outputs: [EnvironmentItemModel]? = nil
    ) -> Step {
        return Step(
            source: .steplib(
                identifier: identifier,
                version: Version(major: majorVersion)
            ),
            title: title,
            isAlwaysRun: isAlwaysRun,
            isSkippable: isSkippable,
            runIf: runIf,
            timeout: timeout,
            noOutputTimeout: noOutputTimeout,
            inputs: inputs,
            outputs: outputs
        )
    }
}

extension Step: Equatable {}

extension Step: Encodable {
    enum CodingKeys: String, CodingKey {
        case title
        case isAlwaysRun = "is_always_run"
        case isSkippable = "is_skippable"
        case runIf = "run_if"
        case timeout
        case noOutputTimeout = "no_output_timeout"
        case inputs
        case outputs
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicKey.self)
        var nestedContainer = container.nestedContainer(keyedBy: CodingKeys.self, forKey: DynamicKey(stringValue: self.source.description)!)
        try nestedContainer.encodeIfPresent(self.title, forKey: .title)
        try nestedContainer.encodeIfPresent(self.isAlwaysRun, forKey: .isAlwaysRun)
        try nestedContainer.encodeIfPresent(self.isSkippable, forKey: .isSkippable)
        try nestedContainer.encodeIfPresent(self.runIf, forKey: .runIf)
        try nestedContainer.encodeIfPresent(self.timeout, forKey: .timeout)
        try nestedContainer.encodeIfPresent(self.noOutputTimeout, forKey: .noOutputTimeout)
        try nestedContainer.encodeIfPresent(self.inputs, forKey: .inputs)
        try nestedContainer.encodeIfPresent(self.outputs, forKey: .outputs)
    }
}

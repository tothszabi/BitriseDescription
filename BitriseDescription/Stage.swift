//
//  Stage.swift
//  BitriseDescription
//
//  Created by Szabolcs Toth on 05/02/2024.
//

public struct Stage {
    public let identifier: String
    public let title: String?
    public let summary: String?
    public let description: String?
    public let shouldAlwaysRun: Bool?
    public let abortOnFail: Bool?
    public let runIf: String?
    public let workflows: [Stage.Workflow]?
    
    init(
        identifier: String,
        title: String? = nil,
        summary: String? = nil,
        description: String? = nil,
        shouldAlwaysRun: Bool? = nil,
        abortOnFail: Bool? = nil,
        // This does not exist in the pipeline service
        runIf: String? = nil,
        workflows: [Stage.Workflow]? = nil
    ) {
        self.identifier = identifier
        self.title = title
        self.summary = summary
        self.description = description
        self.shouldAlwaysRun = shouldAlwaysRun
        self.abortOnFail = abortOnFail
        self.runIf = runIf
        self.workflows = workflows
    }
}

public extension Stage {
    static func stage(
        _ identifier: String,
        title: String? = nil,
        summary: String? = nil,
        description: String? = nil,
        shouldAlwaysRun: Bool? = nil,
        abortOnFail: Bool? = nil,
        runIf: String? = nil,
        workflows: [Stage.Workflow]? = nil
    ) -> Stage {
        return Stage(
            identifier: identifier,
            title: title,
            summary: summary,
            description: description,
            shouldAlwaysRun: shouldAlwaysRun,
            abortOnFail: abortOnFail,
            runIf: runIf,
            workflows: workflows
        )
    }
}

extension Stage: StageIdentifiable {
    public var stageID: String { self.identifier }
}

extension Stage: Equatable {}

extension Stage: Encodable {
    enum CodingKeys: String, CodingKey {
        case title
        case summary
        case description
        case shouldAlwaysRun = "should_always_run"
        case abortOnFail = "abort_on_fail"
        case runIf = "run_if"
        case workflows
    }
  
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.title, forKey: .title)
        try container.encodeIfPresent(self.summary, forKey: .summary)
        try container.encodeIfPresent(self.description, forKey: .description)
        try container.encodeIfPresent(self.shouldAlwaysRun, forKey: .shouldAlwaysRun)
        try container.encodeIfPresent(self.abortOnFail, forKey: .abortOnFail)
        try container.encodeIfPresent(self.runIf, forKey: .runIf)
        try container.encodeIfPresent(self.workflows, forKey: .workflows)
    }
}

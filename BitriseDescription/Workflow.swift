//
//  Workflow.swift
//  BitriseDescription
//
//  Created by Szabolcs Toth on 05/02/2024.
//

public struct Workflow {
    public let identifier: String
    public let title: String?
    public let summary: String?
    public let description: String?
    public let beforeRun: [any WorkflowIdentifiable]?
    public let afterRun: [any WorkflowIdentifiable]?
    public let envs: [EnvironmentItemModel]?
    public let steps: [Step]?
    
    public init(
        identifier: String,
        title: String? = nil,
        summary: String? = nil,
        description: String? = nil,
        beforeRun: [any WorkflowIdentifiable]? = nil,
        afterRun: [any WorkflowIdentifiable]? = nil,
        envs: [EnvironmentItemModel]? = nil,
        steps: [Step]? = nil
    ) {
        self.identifier = identifier
        self.title = title
        self.summary = summary
        self.description = description
        self.beforeRun = beforeRun
        self.afterRun = afterRun
        self.envs = envs
        self.steps = steps
    }
}

public extension Workflow {
    static func workflow(
        _ identifier: String,
        title: String? = nil,
        summary: String? = nil,
        description: String? = nil,
        beforeRun: [any WorkflowIdentifiable]? = nil,
        afterRun: [any WorkflowIdentifiable]? = nil,
        envs: [EnvironmentItemModel]? = nil,
        steps: [Step]? = nil
    ) -> Workflow {
        return Workflow(
            identifier: identifier,
            title: title,
            summary: summary,
            description: description,
            beforeRun: beforeRun,
            afterRun: afterRun,
            envs: envs,
            steps: steps
        )
    }
}

extension Workflow: WorkflowIdentifiable {
    public var workflowID: String { self.identifier }
}

extension Workflow: Equatable {
    public static func == (lhs: Workflow, rhs: Workflow) -> Bool {
        return lhs.identifier == rhs.identifier && 
        lhs.title == rhs.title &&
        lhs.summary == rhs.summary &&
        lhs.description == rhs.description &&
        lhs.beforeRun == rhs.beforeRun &&
        lhs.afterRun == rhs.afterRun &&
        lhs.envs == rhs.envs &&
        lhs.steps == rhs.steps
    }
}

extension Workflow: Encodable {
    enum CodingKeys: String, CodingKey {
        case title
        case summary
        case description
        case beforeRun = "before_run"
        case afterRun = "after_run"
        case envs
        case steps
    }
  
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.title, forKey: .title)
        try container.encodeIfPresent(self.summary, forKey: .summary)
        try container.encodeIfPresent(self.description, forKey: .description)
        try container.encodeIfPresent(convert(self.beforeRun), forKey: .beforeRun)
        try container.encodeIfPresent(convert(self.afterRun), forKey: .afterRun)
        try container.encodeIfPresent(self.envs, forKey: .envs)
        try container.encodeIfPresent(self.steps, forKey: .steps)
    }
    
    private func convert(_ array: [any WorkflowIdentifiable]?) -> [String]? {
        guard let array = array else { return nil }
        
        return array.map { $0.workflowID }
    }
}

extension Optional where Wrapped == Array<any WorkflowIdentifiable> {
    public static func == (lhs: Wrapped?, rhs: Wrapped?) -> Bool {
        guard let lhs = lhs, let rhs = rhs, lhs.count == rhs.count else { return false }
        
        for i in 0..<lhs.count {
            guard lhs[i].workflowID == rhs[i].workflowID else { return false }
        }
        
        return true
    }
}

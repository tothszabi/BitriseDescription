//
//  TriggerMap.swift
//  BitriseDescription
//
//  Created by Szabolcs Toth on 05/02/2024.
//

public struct TriggerMap {
    public let target: TriggerMap.Target
    public let pushBranch: String?
    public let tag: String?
    public let pullRequestSourceBranch: String?
    public let pullRequestTargetBranch: String?
    public let draftPullRequestEnabled: Bool?
    public let pattern: String?
    public let isPullRequestAllowed: Bool?
    
    init(
        target: TriggerMap.Target,
        pushBranch: String? = nil,
        tag: String? = nil,
        pullRequestSourceBranch: String? = nil,
        pullRequestTargetBranch: String? = nil,
        draftPullRequestEnabled: Bool? = nil,
        pattern: String? = nil,
        isPullRequestAllowed: Bool? = nil
    ) {
        self.target = target
        self.pushBranch = pushBranch
        self.tag = tag
        self.pullRequestSourceBranch = pullRequestSourceBranch
        self.pullRequestTargetBranch = pullRequestTargetBranch
        self.draftPullRequestEnabled = draftPullRequestEnabled
        self.pattern = pattern
        self.isPullRequestAllowed = isPullRequestAllowed
    }
}

public extension TriggerMap {
    static func triggerMap(
        target: TriggerMap.Target,
        pushBranch: String? = nil,
        tag: String? = nil,
        pullRequestSourceBranch: String? = nil,
        pullRequestTargetBranch: String? = nil,
        draftPullRequestEnabled: Bool? = nil,
        pattern: String? = nil,
        isPullRequestAllowed: Bool? = nil
    ) -> TriggerMap {
        return TriggerMap(
            target: target,
            pushBranch: pushBranch,
            tag: tag,
            pullRequestSourceBranch: pullRequestSourceBranch,
            pullRequestTargetBranch: pullRequestTargetBranch,
            draftPullRequestEnabled: draftPullRequestEnabled,
            pattern: pattern,
            isPullRequestAllowed: isPullRequestAllowed
        )
    }
}

extension TriggerMap: Equatable {}

extension TriggerMap: Encodable {
    enum CodingKeys: String, CodingKey {
        case pipeline
        case workflow
        case pushBranch = "push_branch"
        case tag
        case pullRequestSourceBranch = "pull_request_source_branch"
        case pullRequestTargetBranch = "pull_request_target_branch"
        case draftPullRequestEnabled = "draft_pull_request_enabled"
        case pattern
        case isPullRequestAllowed = "is_pull_request_allowed"
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        switch self.target {
        case .pipeline(_):
            try container.encodeIfPresent(self.target, forKey: .pipeline)
        case .workflow(_):
            try container.encodeIfPresent(self.target, forKey: .workflow)
        }
        
        try container.encodeIfPresent(self.pushBranch, forKey: .pushBranch)
        try container.encodeIfPresent(self.tag, forKey: .tag)
        try container.encodeIfPresent(self.pullRequestSourceBranch, forKey: .pullRequestSourceBranch)
        try container.encodeIfPresent(self.pullRequestTargetBranch, forKey: .pullRequestTargetBranch)
        try container.encodeIfPresent(self.draftPullRequestEnabled, forKey: .draftPullRequestEnabled)
        try container.encodeIfPresent(self.pattern, forKey: .pattern)
        try container.encodeIfPresent(self.isPullRequestAllowed, forKey: .isPullRequestAllowed)
    }
}

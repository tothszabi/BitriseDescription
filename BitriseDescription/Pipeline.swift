//
//  Pipeline.swift
//  BitriseDescription
//
//  Created by Szabolcs Toth on 05/02/2024.
//

public struct Pipeline {
    public let identifier: String
    public let title: String?
    public let summary: String?
    public let stages: [Pipeline.Stage]?
        
    init(
        identifier: String,
        title: String? = nil,
        summary: String? = nil,
        stages: [Pipeline.Stage]? = nil
    ) {
        self.identifier = identifier
        self.title = title
        self.summary = summary
        self.stages = stages
    }
}

public extension Pipeline {
    static func pipeline(
        _ identifier: String,
        title: String? = nil,
        summary: String? = nil,
        stages: [Pipeline.Stage]? = nil
    ) -> Pipeline {
        return Pipeline(
            identifier: identifier,
            title: title,
            summary: summary,
            stages: stages
        )
    }
}

extension Pipeline: PipelineIdentifiable {
    public var pipelineID: String { self.identifier }
}

extension Pipeline: Equatable {}

extension Pipeline: Encodable {
    enum CodingKeys: CodingKey {
        case title
        case summary
        case stages
    }
  
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.title, forKey: .title)
        try container.encodeIfPresent(self.summary, forKey: .summary)
        try container.encodeIfPresent(self.stages, forKey: .stages)
    }
}

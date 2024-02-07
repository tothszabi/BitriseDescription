//
//  Identifiable.swift
//  BitriseDescription
//
//  Created by Szabolcs Toth on 05/02/2024.
//

public protocol WorkflowIdentifiable {
    var workflowID: String { get }
}

extension String: WorkflowIdentifiable {
    public var workflowID: String { self }
}

public protocol StageIdentifiable {
    var stageID: String { get }
}

extension String: StageIdentifiable {
    public var stageID: String { self }
}

public protocol PipelineIdentifiable {
    var pipelineID: String { get }
}

extension String: PipelineIdentifiable {
    public var pipelineID: String { self }
}

//
//  TriggerMap_Target.swift
//  BitriseDescription
//
//  Created by Szabolcs Toth on 05/02/2024.
//

public extension TriggerMap {
    enum Target {
        case pipeline(PipelineIdentifiable)
        case workflow(WorkflowIdentifiable)
    }
}

extension TriggerMap.Target: Equatable {
    public static func == (lhs: TriggerMap.Target, rhs: TriggerMap.Target) -> Bool {
        switch (lhs, rhs) {
        case (.pipeline(let lhsPipeline), .pipeline(let rhsPipeline)):
            return lhsPipeline.pipelineID == rhsPipeline.pipelineID
        case (.workflow(let lhsWorkflow), .workflow(let rhsWorkflow)):
            return lhsWorkflow.workflowID == rhsWorkflow.workflowID
        default:
            return false
        }
    }
}

extension TriggerMap.Target: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        
        var value = ""
        
        switch self {
        case .pipeline(let pipeline):
            value = pipeline.pipelineID
        case .workflow(let workflow):
            value = workflow.workflowID
        }
        
        try container.encode(value)
    }
}

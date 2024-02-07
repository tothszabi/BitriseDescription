//
//  Stage_Workflow.swift
//  BitriseDescription
//
//  Created by Szabolcs Toth on 05/02/2024.
//

public extension Stage {
    struct Workflow {
        public let identifier: String
        public let runIf: String?
        
        init(
            identifier: String,
            runIf: String? = nil
        ) {
            self.identifier = identifier
            self.runIf = runIf
        }
    }
}

public extension Stage.Workflow {
    static func workflow(
        _ workflow: any WorkflowIdentifiable,
        runIf: String? = nil
    ) -> Stage.Workflow {
        return Stage.Workflow(
            identifier: workflow.workflowID,
            runIf: runIf
        )
    }
}

extension Stage.Workflow: Equatable {}

extension Stage.Workflow: Encodable {
    enum CodingKeys:String, CodingKey {
        case runIf = "run_if"
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicKey.self)
        var nestedContainer = container.nestedContainer(keyedBy: Stage.Workflow.CodingKeys.self, forKey: DynamicKey(stringValue: self.identifier)!)
        try nestedContainer.encodeIfPresent(self.runIf, forKey: .runIf)
    }
}

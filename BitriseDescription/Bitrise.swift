//
//  Bitrise.swift
//  BitriseDescription
//
//  Created by Szabolcs Toth on 05/02/2024.
//

public struct Bitrise {
    public let formatVersion: FormatVersion
    public let stepLibSource: StepLibSource
    public let projectType: ProjectType
    public let title: String?
    public let summary: String?
    public let description: String?
    public let virtualMachine: VirtualMachine
    public let app: AppModel?
    public let triggerMap: [TriggerMap]?
    public let pipelines: [Pipeline]?
    public let stages: [Stage]?
    public let workflows: [Workflow]?
    
    public init(
        formatVersion: FormatVersion,
        stepLibSource: StepLibSource = .default,
        projectType: ProjectType,
        title: String? = nil,
        summary: String? = nil,
        description: String? = nil,
        virtualMachine: VirtualMachine = .default,
        app: AppModel? = nil,
        triggerMap: [TriggerMap] = [],
        pipelines: [Pipeline] = [],
        stages: [Stage] = [],
        workflows: [Workflow] = []
    ) {
        self.formatVersion = formatVersion
        self.stepLibSource = stepLibSource
        self.projectType = projectType
        self.title = title
        self.summary = summary
        self.description = description
        self.virtualMachine = virtualMachine
        self.app = app
        self.triggerMap = triggerMap
        self.pipelines = pipelines
        self.stages = stages
        self.workflows = workflows
        
        dumpManifest(self)
    }
}

extension Bitrise: Equatable {}

extension Bitrise: Encodable {
    enum CodingKeys: String, CodingKey {
        case formatVersion = "format_version"
        case stepLibSource = "default_step_lib_source"
        case projectType = "project_type"
        case title
        case summary
        case description
        case virtualMachine = "meta"
        case app
        case triggerMap = "trigger_map"
        case pipelines
        case stages
        case workflows
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicKey.self)
        try container.encode(self.formatVersion, forKey: DynamicKey(stringValue: CodingKeys.formatVersion.rawValue)!)
        try container.encodeIfPresent(self.stepLibSource, forKey: DynamicKey(stringValue: CodingKeys.stepLibSource.rawValue)!)
        try container.encode(self.projectType, forKey: DynamicKey(stringValue: CodingKeys.projectType.rawValue)!)
        try container.encodeIfPresent(self.title, forKey: DynamicKey(stringValue: CodingKeys.title.rawValue)!)
        try container.encodeIfPresent(self.summary, forKey: DynamicKey(stringValue: CodingKeys.summary.rawValue)!)
        try container.encodeIfPresent(self.description, forKey: DynamicKey(stringValue: CodingKeys.description.rawValue)!)
        try container.encodeIfPresent(self.virtualMachine, forKey: DynamicKey(stringValue: CodingKeys.virtualMachine.rawValue)!)
        try container.encodeIfPresent(self.app, forKey: DynamicKey(stringValue: CodingKeys.app.rawValue)!)
        try container.encodeIfPresent(self.triggerMap, forKey: DynamicKey(stringValue: CodingKeys.triggerMap.rawValue)!)

        if let pipelines = self.pipelines {
            var nestedWorkflowContainer = container.nestedContainer(keyedBy: DynamicKey.self, forKey: DynamicKey(stringValue: CodingKeys.pipelines.rawValue)!)
            
            for pipeline in pipelines {
                try nestedWorkflowContainer.encode(pipeline, forKey: DynamicKey(stringValue: pipeline.identifier)!)
            }
        }
        
        if let stages = self.stages {
            var nestedContainer = container.nestedContainer(keyedBy: DynamicKey.self, forKey: DynamicKey(stringValue: CodingKeys.stages.rawValue)!)
            
            for stage in stages {
                try nestedContainer.encode(stage, forKey: DynamicKey(stringValue: stage.identifier)!)
            }
        }
        
        if let workflows = self.workflows {
            var nestedContainer = container.nestedContainer(keyedBy: DynamicKey.self, forKey: DynamicKey(stringValue: CodingKeys.workflows.rawValue)!)
            
            for workflow in workflows {
                try nestedContainer.encode(workflow, forKey: DynamicKey(stringValue: workflow.identifier)!)
            }
        }
    }
}

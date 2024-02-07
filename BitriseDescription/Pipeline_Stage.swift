//
//  Pipeline_Stage.swift
//  BitriseDescription
//
//  Created by Szabolcs Toth on 05/02/2024.
//

public extension Pipeline {
    struct Stage {
        public let identifier: String
    }
}

public extension Pipeline.Stage {
    static func stage(
        _ stage: any StageIdentifiable
    ) -> Pipeline.Stage {
        return Pipeline.Stage(
            identifier: stage.stageID
        )
    }
}

extension Pipeline.Stage: Equatable {}

extension Pipeline.Stage: Encodable {
    enum CodingKeys: CodingKey {
        case identifier
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicKey.self)
        _ = container.nestedContainer(keyedBy: CodingKeys.self, forKey: DynamicKey(stringValue: self.identifier)!)
    }
}

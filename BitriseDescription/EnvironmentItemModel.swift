//
//  EnvironmentItemModel.swift
//  BitriseDescription
//
//  Created by Szabolcs Toth on 05/02/2024.
//

public struct EnvironmentItemModel {
    public let key: String
    public let value: String
    
    init(
        key: String,
        value: String
    ) {
        self.key = key
        self.value = value
    }
}

public extension EnvironmentItemModel {
    static func env(key: String, value: String) -> EnvironmentItemModel {
        return EnvironmentItemModel(
            key: key,
            value: value
        )
    }
    
    static func input(key: String, value: String) -> EnvironmentItemModel {
        return EnvironmentItemModel(
            key: key,
            value: value
        )
    }
    
    static func output(key: String, newKey: String) -> EnvironmentItemModel {
        return EnvironmentItemModel(
            key: key,
            value: newKey
        )
    }
}

extension EnvironmentItemModel: Equatable {}

extension EnvironmentItemModel: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicKey.self)
        try container.encode(self.value, forKey: DynamicKey(stringValue: self.key)!)
    }
}

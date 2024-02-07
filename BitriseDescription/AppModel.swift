//
//  AppModel.swift
//  BitriseDescription
//
//  Created by Szabolcs Toth on 05/02/2024.
//

public struct AppModel {
    public let title: String?
    public let summary: String?
    public let description: String?
    public let envs: [EnvironmentItemModel]?
        
    init(
        title: String? = nil,
        summary: String? = nil,
        description: String? = nil,
        envs: [EnvironmentItemModel]? = nil
    ) {
        self.title = title
        self.summary = summary
        self.description = description
        self.envs = envs
    }
}

public extension AppModel {
    static func app(
        title: String? = nil,
        summary: String? = nil,
        description: String? = nil,
        envs: [EnvironmentItemModel]? = nil
    ) -> AppModel {
        return AppModel(
            title: title,
            summary: summary,
            description: description,
            envs: envs
        )
    }
}

extension AppModel: Equatable {}

extension AppModel: Encodable {}

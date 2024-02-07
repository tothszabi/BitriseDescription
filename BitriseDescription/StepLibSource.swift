//
//  StepLibSource.swift
//  BitriseDescription
//
//  Created by Szabolcs Toth on 05/02/2024.
//

public enum StepLibSource {
    case `default`
    case custom(String)
}

extension StepLibSource: Equatable {}

extension StepLibSource: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .default:
            try container.encode("https://github.com/bitrise-io/bitrise-steplib.git")
        case .custom(let value):
            try container.encode(value)
        }
    }
}

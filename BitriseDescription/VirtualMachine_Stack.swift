//
//  VirtualMachine_Stack.swift
//  BitriseDescription
//
//  Created by Szabolcs Toth on 05/02/2024.
//

public enum Stack {
    case xcode_15_1_x
    case xcode_15_1_x_edge
    case xcode_15_2_x
    case xcode_15_2_x_edge
    case xcode_15_3_x_edge
    case xcode_latest_edge
    case manual(String)
}

extension Stack: Equatable {}

extension Stack: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .xcode_15_1_x:
            try container.encode("osx-xcode-15.1.x")
        case .xcode_15_1_x_edge:
            try container.encode("osx-xcode-15.1.x-edge")
        case .xcode_15_2_x:
            try container.encode("osx-xcode-15.2.x")
        case .xcode_15_2_x_edge:
            try container.encode("osx-xcode-15.2.x-edge")
        case .xcode_15_3_x_edge:
            try container.encode("osx-xcode-15.3.x-edge")
        case .xcode_latest_edge:
            try container.encode("osx-xcode-edge")
        case .manual(let value):
            try container.encode(value)
        }
    }
}

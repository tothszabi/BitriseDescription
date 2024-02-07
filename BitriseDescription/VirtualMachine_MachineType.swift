//
//  VirtualMachine_MachineType.swift
//  BitriseDescription
//
//  Created by Szabolcs Toth on 05/02/2024.
//

public enum MachineType{
    case m1_medium
    case m1_large
    case manual(String)
}

extension MachineType: Equatable {}

extension MachineType: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .m1_medium:
            try container.encode("g2-m1.4core")
        case .m1_large:
            try container.encode("g2-m1.8core")
        case .manual(let value):
            try container.encode(value)
        }
    }
}

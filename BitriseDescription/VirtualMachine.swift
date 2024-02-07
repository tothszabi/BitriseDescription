//
//  VirtualMachine.swift
//  BitriseDescription
//
//  Created by Szabolcs Toth on 05/02/2024.
//

public struct VirtualMachine {
    public let stack: Stack
    public let machine: MachineType
        
    init(
        stack: Stack = .xcode_15_2_x,
        machine: MachineType = .m1_medium
    ) {
        self.stack = stack
        self.machine = machine
    }
}

public extension VirtualMachine {
    static let `default`: VirtualMachine = .init()
    
    static func virtualMachine(
        stack: Stack = .xcode_15_2_x,
        machine: MachineType = .m1_medium
    ) -> VirtualMachine {
        return VirtualMachine(
            stack: stack,
            machine: machine
        )
    }
}

extension VirtualMachine: Equatable {}

extension VirtualMachine: Encodable {
    enum CodingKeys: String, CodingKey {
        case stack
        case machine = "machine_type_id"
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicKey.self)
        var nestedContainer = container.nestedContainer(keyedBy: CodingKeys.self, forKey: DynamicKey(stringValue: "bitrise.io")!)
        try nestedContainer.encode(self.stack, forKey: .stack)
        try nestedContainer.encode(self.machine, forKey: .machine)
    }
}

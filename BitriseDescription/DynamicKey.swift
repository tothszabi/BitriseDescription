//
//  DynamicKey.swift
//  BitriseDescription
//
//  Created by Szabolcs Toth on 05/02/2024.
//

struct DynamicKey: CodingKey {
    var intValue: Int?
    var stringValue: String = ""

    init?(intValue: Int) {
        self.intValue = intValue
    }
    
    init?(stringValue: String) {
        self.stringValue = stringValue
    }
}

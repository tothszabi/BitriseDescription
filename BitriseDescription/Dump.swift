//
//  Dump.swift
//  BitriseDescription
//
//  Created by Szabolcs Toth on 05/02/2024.
//

import Foundation

func dumpManifest(_ entity: some Encodable) {
    guard 0 < CommandLine.argc, CommandLine.arguments.contains("--dump") else { return }
    
    let encoder = JSONEncoder()
#if DEBUG
    encoder.outputFormatting = .prettyPrinted
#endif

    let data = try! encoder.encode(entity)
    let manifest = String(data: data, encoding: .utf8)!
    
    print("BITRISE_MANIFEST_BEGIN")
    print(manifest)
    print("BITRISE_MANIFEST_END")
}

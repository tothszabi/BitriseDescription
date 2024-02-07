//
//  Step_Source.swift
//  BitriseDescription
//
//  Created by Szabolcs Toth on 05/02/2024.
//

public extension Step {
    enum Source {
        case steplib(identifier: String, version: Step.Version?)
        case customSteplib(url: String, identifier: String, version: Step.Version?)
        case git(url: String, branchOrTag: String)
        case path(String)
    }
}

extension Step.Source: CustomStringConvertible {
    public var description: String {
        switch self {
        case .steplib(identifier: let identifier, version: let version):
            if let versionString = version?.description, versionString.isEmpty == false {
                return "\(identifier)@\(versionString)"
            }
            return identifier
        case .customSteplib(url: let url, identifier: let identifier, version: let version):
            let base = "\(url)::\(identifier)"
            
            if let versionString = version?.description, versionString.isEmpty == false {
                return "\(base)@\(versionString)"
            }
            
            return base
        case .git(url: let url, branchOrTag: let branchOrTag):
            return "git::\(url)@\(branchOrTag)"
        case .path(let path):
            return "path::\(path)"
        }
    }
}

extension Step.Source: Equatable {}

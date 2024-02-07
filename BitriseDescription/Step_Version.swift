//
//  Step_Version.swift
//  BitriseDescription
//
//  Created by Szabolcs Toth on 05/02/2024.
//

public extension Step {
    struct Version {
        public let major: UInt?
        public let minor: UInt?
        public let patch: UInt?
        
        init(
            major: UInt? = nil,
            minor: UInt? = nil,
            patch: UInt? = nil
        ) {
            self.major = major
            self.minor = minor
            self.patch = patch
        }
    }
}

public extension Step.Version {
    static func alwaysLatest() -> Step.Version {
        return Step.Version()
    }
    
    static func exact(major: Int, minor: Int, patch: Int) -> Step.Version {
        return Step.Version()
    }
    
    static func upToNextMajor(from version: Step.Version?) -> Step.Version {
        return Step.Version(major: version?.major)
    }

    static func upToNextMinor(from version: Step.Version?) -> Step.Version {
        return Step.Version(major: version?.major, minor: version?.minor)
    }
}

extension Step.Version: CustomStringConvertible {
    public var description: String {
        var string = ""
        
        if let major = major {
            string.append("\(major)")
        }
        
        if let minor = minor {
            string.append(".\(minor)")
        }
        
        if let patch = patch {
            string.append(".\(patch)")
        }
        
        return string
    }
}

extension Step.Version: Equatable {}

// This is a workaround to be able to initialise an optional Version struct with a string literal.
extension Optional: ExpressibleByStringLiteral,
                    ExpressibleByUnicodeScalarLiteral,
                    ExpressibleByExtendedGraphemeClusterLiteral where Wrapped == Step.Version {
    public init(stringLiteral value: String) {
        var components = value.split(separator: ".")
        
        guard components.count <= 3 else { 
            self = nil
            return
        }
        
        self = Wrapped(
            major: UInt(components.popFirst()),
            minor: UInt(components.popFirst()),
            patch: UInt(components.popFirst())
        )
    }
    
    public init(unicodeScalarLiteral value: String) {
        self = .init(stringLiteral: value)
    }
    
    public init(extendedGraphemeClusterLiteral value: String) {
        self = .init(stringLiteral: value)
    }
}

private extension Array {
    mutating func popFirst() -> Element? {
        if self.count > 0 {
            return self.removeFirst()
        }
        return nil
    }
}

private extension UInt {
    init?(_ value: Substring?) {
        guard let value = value else { return nil }
        self.init(value)
    }
}

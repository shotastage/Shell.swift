//
//  Shell.swift
//
//
//  Created by Shota Shimazu on 2023/09/07.
//

import Foundation

public enum ShellError: Error {
    case platformNotSupported
    case taskFailed
}

open class Shell {
    @discardableResult
    public static func run(_ cmd: String, arguments: [String] = []) throws -> Int32 {
        #if os(iOS) || os(watchOS) || os(tvOS)
            throw ShellError.platformNotSupported
        #else
            let task = Process()
            task.executableURL = URL(fileURLWithPath: cmd)
            task.arguments = arguments
            do {
                try task.run()
                task.waitUntilExit()
                if task.terminationStatus != 0 {
                    throw ShellError.taskFailed
                }
                return task.terminationStatus
            } catch {
                throw ShellError.taskFailed
            }
        #endif
    }
}

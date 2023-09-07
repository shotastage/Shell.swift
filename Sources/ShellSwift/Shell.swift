//
//  Shell.swift
//
//
//  Created by Shota Shimazu on 2023/09/07.
//

import Foundation

public enum ShellError: Error {
    case platformNotSupported
    case commandNotFound
    case taskFailed
}

public enum Shells: String {
    case bash = "/bin/bash"
    case zsh = "/bin/zsh"
    case sh = "/bin/sh"
}

open class Shell {
    @discardableResult
    public static func directoryRun(_ cmd: String) -> String {
        let task = Process()
        let pipe = Pipe()

        task.standardOutput = pipe
        task.arguments = ["-c", cmd]
        task.launchPath = "/bin/sh"
        task.launch()

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8) ?? ""

        task.waitUntilExit()
        return output
    }
    

    @discardableResult
    public static func safeRun(_ cmd: String, args: [String], shell: Shells = .sh) throws -> String {
        #if os(iOS) || os(watchOS) || os(tvOS)
            throw ShellError.platformNotSupported
        #else
        let task = Process()
        let pipe = Pipe()
        
        task.standardOutput = pipe
        task.arguments = ["-c", cmd]
        task.launchPath = shell.rawValue
        task.launch()

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8) ?? ""

        task.waitUntilExit()
        return output
        #endif
    }

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

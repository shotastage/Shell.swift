# Shell.swift

Lightweight `Process` class wrapper for Swift.

## Current available methods

| Method  | Usage  |
|:----------|:----------|
| `Shell.directoryRun(_ cmd: String, out: Bool = false) -> String` | Run shell command directory with no command escaping. This method has potential threat for security in server-side use. |

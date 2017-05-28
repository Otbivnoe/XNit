//
//  SourceEditorCommand.swift
//  XNit
//
//  Created by Nikita Ermolenko on 27/05/2017.
//  Copyright © 2017 Nikita Ermolenko. All rights reserved.
//

import Foundation
import XcodeKit

extension String {
    var indentation: String {
        var indentation = ""
        for character in characters {
            if character == " " {
                indentation.append(" ")
            }
            else {
                break
            }
        }
        return indentation
    }
}

func *(count: Int, value: String) -> String {
    var value = ""
    for _ in 0...count {
        value += " "
    }
    return value
}

class SourceEditorCommand: NSObject, XCSourceEditorCommand {
    
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) -> Void {
        let buffer = invocation.buffer
        
        var properties = [(String, String)]() // name, type
        var selectedLines = [String]()

        for selection in invocation.buffer.selections {
            let range = selection as! XCSourceTextRange
            let startLine = range.start.line
            let endLine = range.end.line
            
            for index in startLine...endLine {
                let text = invocation.buffer.lines[index] as! String
                if text.contains("=") || text.isEmpty {
                    continue
                }
                guard text.contains("var") || text.contains("let") else {
                    continue
                }
                selectedLines.append(text)
            }
        }
        
        let trimmingSet = CharacterSet.whitespacesAndNewlines
    
        for line in selectedLines {
            let trimmedLine = line.trimmingCharacters(in: trimmingSet)
            let components = trimmedLine.components(separatedBy: ":")
            
            guard let nameComponent = components.first, let typeComponent = components.last, components.count == 2 else {
                continue
            }
            
            let type = typeComponent.trimmingCharacters(in: trimmingSet)
            let startIndex = nameComponent.index(nameComponent.startIndex, offsetBy: 4)
            let name = nameComponent[startIndex..<nameComponent.endIndex]
            
            properties.append(name, type)
        }
        
        guard properties.count > 0 else {
            return
        }
        
        let outsideIndentation = selectedLines.first!.indentation
        let innerIndentation = outsideIndentation + (buffer.usesTabsForIndentation ? buffer.tabWidth : buffer.indentationWidth) * " "
        
        var initializer = outsideIndentation + "init("
        for (index, (name, type)) in properties.enumerated() {
            initializer.append("\(name): \(type)")
            
            if index < properties.count - 1 {
                initializer.append(", ")
            }
        }

        initializer.append(") {\n")
        
        for (name, _) in properties {
            initializer.append(innerIndentation + "self.\(name) = \(name)")
            initializer.append("\n")
        }
        initializer.append(outsideIndentation + "}\n")
        print(initializer)
        
        completionHandler(nil)
    }
}

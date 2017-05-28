//
//  SourceEditorCommand.swift
//  XNit
//
//  Created by Nikita Ermolenko on 27/05/2017.
//  Copyright © 2017 Nikita Ermolenko. All rights reserved.
//

import Foundation
import XcodeKit

class SourceEditorCommand: NSObject, XCSourceEditorCommand {
    
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) -> Void {
        var properties = [(String, String)]() // name, type
        
        for selection in invocation.buffer.selections {
            
            let range = selection as! XCSourceTextRange
            var selectedLines = [String]()
            
            let startLine = range.start.line
            let endLine = range.end.line
            
            for index in startLine...endLine {
                let text = invocation.buffer.lines[index] as! String
                // check empty string
                selectedLines.append(text)
            }
            
            // let, var
            // :String, : String
            // let `let`: Int
            // var 2 = 4 !!!
 
            let trimmingSet = CharacterSet.whitespacesAndNewlines
            
            for line in selectedLines {
                if line.contains("=") {
                    continue
                }
                guard line.contains("var") || line.contains("let") else {
                    continue
                }
                
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
        }
        
        guard properties.count > 0 else {
            return
        }
        
        var initializer = "init("
        for (index, (name, type)) in properties.enumerated() {
            initializer.append("\(name): \(type)")
            
            if index < properties.count - 1 {
                initializer.append(", ")
            }
        }

        initializer.append(") {\n")
        
        for (index, (name, _)) in properties.enumerated() {
            initializer.append("self.\(name) = \(name)")
            
            if index < properties.count - 1 {
                initializer.append("\n")
            }
        }
        initializer.append("\n}\n")
        print(initializer)
        
        completionHandler(nil)
    }
}

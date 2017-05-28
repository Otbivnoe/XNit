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
            
            var properties = [(String, String)]() // name, type
            let trimmingSet = CharacterSet(charactersIn: " ")
            
            for line in selectedLines {
                if line.contains("=") {
                    continue
                }
                let trimmedLine = line.trimmingCharacters(in: trimmingSet)
                let components = trimmedLine.components(separatedBy: ":")
                
                guard let nameComponent = components.first, let typeComponent = components.last, components.count == 2 else {
                    continue
                }
                    
                let type = typeComponent.trimmingCharacters(in: trimmingSet)
                
                let startIndex = nameComponent.index(nameComponent.startIndex, offsetBy: 3)
                let name = nameComponent[startIndex..<nameComponent.endIndex]
                
                print("name: \(name), type:\(type)")
            }
        }
        
        completionHandler(nil)
    }
}

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
        // Implement your command here, invoking the completion handler when done. Pass it nil on success, and an NSError on failure.
        
        completionHandler(nil)
    }
    
}

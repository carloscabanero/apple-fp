//
//  FileProviderItem.swift
//  blinkfileprovider
//
//  Created by Carlos Cabanero on 10/14/21.
//

import FileProvider
import UniformTypeIdentifiers

class FileProviderItem: NSObject, NSFileProviderItem {
    let name: String
    
    // TODO: implement an initializer to create an item from your extension's backing model
    // TODO: implement the accessors to return the values from your extension's backing model
    init(name: String) {
        self.name = name
    }
    
    var itemIdentifier: NSFileProviderItemIdentifier {
        return NSFileProviderItemIdentifier(self.name)
    }
    
    var parentItemIdentifier: NSFileProviderItemIdentifier {
        return .rootContainer
    }
    
    var capabilities: NSFileProviderItemCapabilities {
        return [.allowsReading, .allowsWriting, .allowsRenaming, .allowsReparenting, .allowsTrashing, .allowsDeleting]
    }
    
    var filename: String {
        self.name
    }
    
    var contentType: UTType {
        return itemIdentifier == NSFileProviderItemIdentifier.rootContainer ? .folder : .plainText
    }
    
}

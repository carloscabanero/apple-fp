//
//  FileProviderEnumerator.swift
//  blinkfileprovider
//
//  Created by Carlos Cabanero on 10/14/21.
//

import FileProvider

class FileProviderEnumerator: NSObject, NSFileProviderEnumerator {
    
    var enumeratedItemIdentifier: NSFileProviderItemIdentifier
    var timer: DispatchSourceTimer!
    
    init(enumeratedItemIdentifier: NSFileProviderItemIdentifier) {
        self.enumeratedItemIdentifier = enumeratedItemIdentifier
        let q = DispatchQueue(label: "blk.timer")
        self.timer = DispatchSource.makeTimerSource(queue: q)
        super.init()

        timer.schedule(deadline: .now(), repeating: .seconds(5))
        timer.setEventHandler { [weak self] in
            guard let self = self else {
                return
            }
            
            NSFileProviderManager.default.signalEnumerator(for: .rootContainer, completionHandler: { error in
                print("Signal Enumerator Done with error? \(error)")
            })
        }
        timer.resume()
    }

    func invalidate() {
        // TODO: perform invalidation of server connection if necessary
    }

    func enumerateItems(for observer: NSFileProviderEnumerationObserver, startingAt page: NSFileProviderPage) {
        /* TODO:
         - inspect the page to determine whether this is an initial or a follow-up request
         
         If this is an enumerator for a directory, the root container or all directories:
         - perform a server request to fetch directory contents
         If this is an enumerator for the active set:
         - perform a server request to update your local database
         - fetch the active set from your local database
         
         - inform the observer about the items returned by the server (possibly multiple times)
         - inform the observer that you are finished with this page
         */
        let items = [FileProviderItem(name: "file1"), FileProviderItem(name: "file2")]
        observer.didEnumerate(items)
        observer.finishEnumerating(upTo: nil)
    }
    
    func enumerateChanges(for observer: NSFileProviderChangeObserver, from anchor: NSFileProviderSyncAnchor) {
        /* TODO:
         - query the server for updates since the passed-in sync anchor
         
         If this is an enumerator for the active set:
         - note the changes in your local database
         
         - inform the observer about item deletions and updates (modifications + insertions)
         - inform the observer when you have finished enumerating up to a subsequent sync anchor
         */
        let lastChange = String(data: anchor.rawValue, encoding: .utf8)!
        print("Enumerate changes from \(lastChange)")
    }

    func currentSyncAnchor(completionHandler: @escaping (NSFileProviderSyncAnchor?) -> Void) {
      print("CurrentSyncAnchor")

      let data = "1".data(using: .utf8)
      completionHandler(NSFileProviderSyncAnchor(data!))
    }
}

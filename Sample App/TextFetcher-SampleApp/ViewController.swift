///
///  ViewController.swift
///  Created on 7/25/20
///  Copyright © 2020 Eric Reedy. All rights reserved.
///

import Cocoa
import TextFetcher

class ViewController: NSViewController {

    var texts: [TextSource: (text: String, version: Version)] = [:]
    var textsArray: [(textSource: TextSource, text: String, version: Version)] {
        return texts.map({ (textSource: $0.key, text: $0.value.text, version: $0.value.version) })
                    .sorted(by: { $0.textSource.identifier < $1.textSource.identifier })
    }
    var selectedText: Int = 0 {
        didSet {
            if (0 ..< textsArray.count).contains(selectedText) {
                textView.string = textsArray[selectedText].text
            } else {
                textView.string = ""
            }
        }
    }
    
    @IBOutlet var tableView: NSTableView!
    @IBOutlet var textView: NSTextView!
    
    override func viewWillAppear() {
        super.viewWillAppear()
        view.window?.isOpaque = false
        textView.textContainerInset = NSSize(width: 20, height: 20)
        TextFetcher.default.addNotificationReceiver(self)
        reloadSources(self)
    }
    
    func loadText(for textSource: TextSource) {

        TextFetcher.default.text(for: textSource, awaitRemoteFetchIfNeeded: true) { [weak self] text, version in
            guard let self = self else { return }
            self.texts[textSource] = (text: text ?? "", version: version ?? .zero)
            self.tableView.reloadData()
        }
    }
    
    @IBAction func clearCaches(_ sender: Any) {
        TextFetcher.default.clearCaches()
        texts = [:]
        tableView.reloadData()
        selectedText = -1
    }
    
    @IBAction func reloadSources(_ sender: Any) {
        for textProvider in SampleAppTextSource.allCases {
            loadText(for: textProvider.textSource)
        }
    }
}

extension ViewController: TextFetcherNotificationReceiver {
    
    func versionIncreased(to version: Version, for textSource: TextSource) {
        loadText(for: textSource)
    }
}

extension ViewController: NSTableViewDelegate, NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return texts.count
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        selectedText = tableView.selectedRow
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "TableCell"), owner: nil) as? NSTableCellView {
            let textInfo = textsArray[row]
            cell.textField?.stringValue = "ID: " + textInfo.textSource.identifier + ", Version: " + textInfo.version.stringValue
            return cell
        }
        return nil
    }
}

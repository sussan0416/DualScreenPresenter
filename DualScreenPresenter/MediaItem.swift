//
//  MediaItem.swift
//  DualScreenPresenter
//
//  Created by 鈴木孝宏 on 2020/03/21.
//  Copyright © 2020 鈴木孝宏. All rights reserved.
//

import Cocoa

class MediaItem: NSCollectionViewItem {

    @IBOutlet weak var mediaImage: NSImageView!
    @IBOutlet weak var titleLabel: NSTextField!

    var media: Media? {
        didSet {
            guard let m = media else {
                mediaImage.image = nil
                titleLabel.stringValue = "No Media"
                return
            }

            mediaImage.image = NSImage(contentsOf: m.url)
            titleLabel.stringValue = m.url.lastPathComponent
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }

    override var isSelected: Bool {
        didSet {
            self.view.layer?.borderWidth = 2
            
            if isSelected {
                self.view.layer?.borderColor = NSColor.green.cgColor
                return
            }

            if media?.isProgram ?? false {
                self.view.layer?.borderColor = NSColor.green.cgColor
                return
            }

            self.view.layer?.borderColor = NSColor.clear.cgColor
        }
    }
}

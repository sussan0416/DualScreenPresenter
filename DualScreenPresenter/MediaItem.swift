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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
}

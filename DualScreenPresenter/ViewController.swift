//
//  ViewController.swift
//  DualScreenPresenter
//
//  Created by 鈴木孝宏 on 2020/03/05.
//  Copyright © 2020 鈴木孝宏. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var collectionView: NSCollectionView!

    private var fillWindowController: NSWindowController!
    private var keyWindowController: NSWindowController!

    private var mediaData: [Media] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        let storyboard = NSStoryboard.init(name: "Main", bundle: Bundle.main)
        fillWindowController = (storyboard.instantiateController(withIdentifier: .init(stringLiteral: "Fill")) as! NSWindowController)
        keyWindowController = (storyboard.instantiateController(withIdentifier: .init(stringLiteral: "Key")) as! NSWindowController)

        collectionView.register(NSNib(nibNamed: "MediaItem", bundle: .main), forItemWithIdentifier: NSUserInterfaceItemIdentifier("MediaItem"))
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func clickLoadImage(_ sender: Any) {
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = true

        switch panel.runModal() {
        case .OK:
            mediaData = panel.urls.map({
                Media(url: $0, title: $0.lastPathComponent, isProgram: false)
            })
            collectionView.reloadData()
        default: break
        }
    }

    @IBAction func changeFillSwitch(_ sender: Any) {
        guard let sw = sender as? NSSwitch else { return }

        switch sw.state {
        case .off:
            fillWindowController.close()
        case .on:
            fillWindowController.showWindow(self)
        default: break
        }
    }

    @IBAction func changeKeySwitch(_ sender: Any) {
        guard let sw = sender as? NSSwitch else { return }

        switch sw.state {
        case .off:
            keyWindowController.close()
        case .on:
            keyWindowController.showWindow(self)
        default: break
        }
    }

    @IBAction func clickChangeButton(_ sender: Any) {
        let indexes = collectionView.selectionIndexes
        mediaData.enumerated().forEach { (offset: Int, element: Media) in
            let selected = indexes.contains(offset)
            mediaData[offset].isProgram = selected

            // 現状1枚の選択にしか対応していないので、これでも問題にはならない
            if selected {
                presentImage(url: element.url)
            }
        }

        collectionView.deselectAll(nil)
        collectionView.reloadData()
    }

    private func presentImage(url: URL) {
        guard let fillWindow = fillWindowController.window,
            let keyWindow = keyWindowController.window else { return }

        // Viewを管理していないので、一旦すべてのviewを削除
        fillWindow.contentView?.subviews.forEach {
            $0.removeFromSuperview()
        }
        keyWindow.contentView?.subviews.forEach {
            $0.removeFromSuperview()
        }

        // 画像読み込み
        let ciImage = CIImage(contentsOf: url)!
        let imageRect = ciImage.extent
        let size = ciImage.extent.size

        // fill
        let context = CIContext()
        let cgImage = context.createCGImage(ciImage, from: imageRect)!
        let fillSize = fillWindow.frame.size

        let fillImage = NSImage(cgImage: cgImage, size: size)
        let imageView = NSView(frame: NSRect(x: 0, y: 0, width: fillSize.width, height: fillSize.height))
        imageView.layer = CALayer()
        imageView.layer?.contentsGravity = .resizeAspectFill
        imageView.layer?.contents = fillImage
        imageView.wantsLayer = true
        imageView.autoresizingMask = [.height, .width]


        let backgroundView1 = NSView(frame: NSRect(x: 0, y: 0, width: fillSize.width, height: fillSize.height))
        backgroundView1.wantsLayer = true
        backgroundView1.layer?.backgroundColor = NSColor.black.cgColor
        backgroundView1.autoresizingMask = [.height, .width]

        fillWindow.contentView?.addSubview(backgroundView1)
        fillWindow.contentView?.addSubview(imageView)

        // フィルタかけたあとの画像
        let filter = KeyOnlyFilter()
        filter.inputImage = ciImage
        let outputImage = filter.outputImage()!
        let outputCGImage = context.createCGImage(outputImage, from: imageRect)
        let keySize = keyWindow.frame.size

        let keyImage = NSImage(cgImage: outputCGImage!, size: ciImage.extent.size)
        let alphaImageView = NSView(frame: NSRect(x: 0, y: 0, width: keySize.width, height: keySize.height))
        alphaImageView.layer = CALayer()
        alphaImageView.layer?.contentsGravity = .resizeAspectFill
        alphaImageView.layer?.contents = keyImage
        alphaImageView.wantsLayer = true
        alphaImageView.autoresizingMask = [.height, .width]

        let backgroundView2 = NSView(frame: NSRect(x: 0, y: 0, width: keySize.width, height: keySize.height))
        backgroundView2.wantsLayer = true
        backgroundView2.layer?.backgroundColor = NSColor.black.cgColor
        backgroundView2.autoresizingMask = [.height, .width]

        keyWindow.contentView?.addSubview(backgroundView2)
        keyWindow.contentView?.addSubview(alphaImageView)
    }
}

extension ViewController: NSCollectionViewDataSource {
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return mediaData.count
    }

    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let media = mediaData[indexPath.item]
        let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "MediaItem"), for: indexPath) as! MediaItem
        item.media = media
        return item
    }


}

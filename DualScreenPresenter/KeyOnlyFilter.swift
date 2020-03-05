//
//  MetalFilter.swift
//  DualScreenPresenter
//
//  Created by 鈴木孝宏 on 2020/03/05.
//  Copyright © 2020 鈴木孝宏. All rights reserved.
//

import CoreImage

class KeyOnlyFilter: CIFilter {

    private let kernel: CIColorKernel

    var inputImage: CIImage?

    override init() {
        let url = Bundle.main.url(forResource: "default", withExtension: "metallib")!
        let data = try! Data(contentsOf: url)
        kernel = try! CIColorKernel(functionName: "createGrayImageByAlphaChannel", fromMetalLibraryData: data)
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func outputImage() -> CIImage? {
        guard let inputImage = inputImage else {return nil}
        return kernel.apply(extent: inputImage.extent, arguments: [inputImage])
    }
}

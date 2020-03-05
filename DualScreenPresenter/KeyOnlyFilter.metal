//
//  KeyOnlyFilter.metal
//  DualScreenPresenter
//
//  Created by 鈴木孝宏 on 2020/03/05.
//  Copyright © 2020 鈴木孝宏. All rights reserved.
//

#include <CoreImage/CoreImage.h> // includes CIKernelMetalLib.h

extern "C" { namespace coreimage {

    float4 createGrayImageByAlphaChannel(sample_t s) {
        return s.a;
    }

}}

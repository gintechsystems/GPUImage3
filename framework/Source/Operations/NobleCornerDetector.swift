//
//  NobleCornerDetector.swift
//  GPUImage
//
//  Created by PavanK on 7/15/20.
//  Copyright © 2020 Red Queen Coder, LLC. All rights reserved.
//

public class NobleCornerDetector: HarrisCornerDetector {
    public override init() {
        super.init(fragmentShaderFunction: "nobleCornerDetector")
    }
}

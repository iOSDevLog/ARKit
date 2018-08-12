//
//  Float4x4+translation.swift
//  SimpleARKitDemo
//
//  Created by iosdevlog on 2018/8/12.
//  Copyright © 2018年 iosdevlog. All rights reserved.
//

import ARKit

extension float4x4 {
    var translation: float3 {
        let translation = self.columns.3
        return float3(translation.x, translation.y, translation.z)
    }
}

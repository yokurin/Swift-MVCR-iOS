//
//  CollectionExtension.swift
//  SwiftMVCR
//
//  Created by 林　翼 on 2018/11/09.
//  Copyright © 2018年 Tsubasa Hayashi. All rights reserved.
//

import Foundation

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

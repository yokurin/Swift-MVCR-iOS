//
//  DetailModel.swift
//  SwiftMVCR
//
//  Created by 林　翼 on 2018/11/09.
//  Copyright © 2018年 Tsubasa Hayashi. All rights reserved.
//

import Foundation

final class DetailModel: Modelable {
    var entryModel: DetailEntryModel!
    init(entryModel: DetailEntryModel) {
        self.entryModel = entryModel
    }
}

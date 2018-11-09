//
//  ListRouter.swift
//  SwiftMVCR
//
//  Created by 林　翼 on 2018/11/07.
//  Copyright © 2018年 Tsubasa Hayashi. All rights reserved.
//

import UIKit

struct ListEntryModel {
    let rowCount: Int
    init(rowCount: Int = 100) {
        self.rowCount = rowCount
    }
}

final class ListRouterInput {
    func push(from: Viewable, entryModel: ListEntryModel) {
        let controller = ListViewController.configure(entryModel: entryModel)
        from.push(controller, animated: true)
    }

    func present(from: Viewable, entryModel: ListEntryModel) {
        let controller = ListViewController.configure(entryModel: entryModel)
        from.present(controller, animated: true)
    }
}

final class ListRouterOutput: Routerable {

    weak private(set) var view: Viewable!

    init(_ view: Viewable) {
        self.view = view
    }

    func transitionToDetail(entryModel: DetailEntryModel) {
        DetailRouterInput().push(from: view, entryModel: entryModel)
    }
}

//
//  ListRouter.swift
//  SwiftMVCR
//
//  Created by 林　翼 on 2018/11/07.
//  Copyright © 2018年 Tsubasa Hayashi. All rights reserved.
//

import UIKit

// Add Data for Enrty
struct ListEntryEntity {
    let rowCount: Int
    init(rowCount: Int = 100) {
        self.rowCount = rowCount
    }
}

final class ListRouterInput {
    func push(from: Transitionable, entryEntity: ListEntryEntity) {
        let controller = ListViewController.configure(entryEntity: entryEntity)
        from.push(controller, animated: true)
    }

    func present(from: Transitionable, entryEntity: ListEntryEntity) {
        let controller = ListViewController.configure(entryEntity: entryEntity)
        from.present(controller, animated: true)
    }
}

final class ListRouterOutput: Routerable {

    weak private(set) var view: Transitionable!

    init(_ view: Transitionable) {
        self.view = view
    }

    func transitionToDetail(entryEntity: DetailEntryEntity) {
        DetailRouterInput().push(from: view, entryEntity: entryEntity)
    }
}

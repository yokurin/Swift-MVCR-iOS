//
//  DetailRouter.swift
//  SwiftMVCR
//
//  Created by 林　翼 on 2018/11/08.
//  Copyright © 2018年 Tsubasa Hayashi. All rights reserved.
//

import UIKit

// Add Data for Entry
struct DetailEntryEntity {
    var count: Count
    init(count: Count) {
        self.count = count
    }
}

final class DetailRouterInput {
    func push(from: Transitionable, entryEntity: DetailEntryEntity) {
        let controller = DetailViewController.configure(entryEntity: entryEntity)
        from.push(controller, animated: true)
    }

    func present(from: Transitionable, entryEntity: DetailEntryEntity) {
        let controller = DetailViewController.configure(entryEntity: entryEntity)
        from.present(controller, animated: true)
    }
}

final class DetailRouterOutput: Routerable {

    weak private(set) var view: Transitionable!

    init(_ view: Transitionable) {
        self.view = view
    }

    func transitionToDetail(entity: AnyObject) {
        let detail = UIViewController()
        view.push(detail, animated: true)
    }
}


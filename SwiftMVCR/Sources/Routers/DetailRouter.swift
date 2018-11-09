//
//  DetailRouter.swift
//  SwiftMVCR
//
//  Created by 林　翼 on 2018/11/08.
//  Copyright © 2018年 Tsubasa Hayashi. All rights reserved.
//

import UIKit

struct DetailEntryModel {
    var gitHubRepository: GitHubRepository
    init(gitHubRepository: GitHubRepository) {
        self.gitHubRepository = gitHubRepository
    }
}

final class DetailRouterInput {
    func push(from: Viewable, entryModel: DetailEntryModel) {
        let controller = DetailViewController.configure(entryModel: entryModel)
        from.push(controller, animated: true)
    }

    func present(from: Viewable, entryModel: DetailEntryModel) {
        let controller = DetailViewController.configure(entryModel: entryModel)
        from.present(controller, animated: true)
    }
}

final class DetailRouterOutput: Routerable {

    weak private(set) var view: Viewable!

    init(_ view: Viewable) {
        self.view = view
    }

    // nop
}


//
//  ListModel.swift
//  SwiftMVCR
//
//  Created by 林　翼 on 2018/11/09.
//  Copyright © 2018年 Tsubasa Hayashi. All rights reserved.
//

import Foundation

protocol ListModelDelegate: AnyObject {
    func onSuccessSearch()
    func onErrorSearch(error: Error)
}

final class ListModel: Modelable {

    weak var delegate: ListModelDelegate?

    var entryModel: ListEntryModel!

    var gitHubRepositories: [GitHubRepository] = []
    var pageCount = 1
    var isFetching = false

    init(entryModel: ListEntryModel) {
        self.entryModel = entryModel
    }

    func fetch() {
        isFetching = true
        GitHubApiSevice.Search().do(with: "Swift", page: pageCount, onSuccess: { [weak self] res in
            self?.isFetching = false
            self?.gitHubRepositories += res.items
            self?.pageCount += 1
            self?.delegate?.onSuccessSearch()
            //print(res)
        }) { [weak self] error in
            self?.isFetching = false
            self?.delegate?.onErrorSearch(error: error)
            //print(error)
        }
    }

}

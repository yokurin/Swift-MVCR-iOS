//
//  DetailViewController.swift
//  SwiftMVCR
//
//  Created by 林　翼 on 2018/11/08.
//  Copyright © 2018年 Tsubasa Hayashi. All rights reserved.
//

import UIKit

final class DetailViewController: UIViewController, Controllerable {

    static func configure(entryEntity: DetailEntryEntity) -> DetailViewController {
        let controller = DetailViewController()
        controller.router = DetailRouterOutput(controller)
        controller.entryEntity = entryEntity
        return controller
    }

    @IBOutlet private weak var countDisplayLabel: UILabel!

    private var entryEntity: DetailEntryEntity!
    private(set) var router: DetailRouterOutput!

    override func viewDidLoad() {
        super.viewDidLoad()
        countDisplayLabel.text = "\(entryEntity.count.value)"
        entryEntity.count.value += 10000
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard let listController = navigationController?.viewControllers.first(where: { $0 is ListViewController }) as? ListViewController else { return }
        listController.detailEntity = entryEntity
    }

}

extension DetailViewController: Transitionable {}

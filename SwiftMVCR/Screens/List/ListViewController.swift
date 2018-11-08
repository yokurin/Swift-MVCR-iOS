//
//  ListViewController.swift
//  SwiftMVCR
//
//  Created by 林　翼 on 2018/11/07.
//  Copyright © 2018年 Tsubasa Hayashi. All rights reserved.
//

import UIKit

final class ListViewController: UIViewController, Controllerable {

    static func configure(entryEntity: ListEntryEntity) -> ListViewController {
        let controller = ListViewController()
        controller.router = ListRouterOutput(controller)
        controller.entryEntity = entryEntity
        return controller
    }

    // MARK: Properties
    @IBOutlet weak private var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }

    private var entryEntity: ListEntryEntity!
    private(set) var router: ListRouterOutput!

    var detailEntity: DetailEntryEntity! // Using when backed from Detail

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let entity = detailEntity {
            print("updated count: \(entity.count.value)")
        }
    }

    @IBAction func onPopButtonTapped(_ sender: Any) {
        router.pop(animated: true)
    }

}

// MARK: UITableViewDelegate, UITableViewDataSource
extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entryEntity.rowCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "default")
        cell.textLabel?.text = "row: \(indexPath.row)"
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        router.transitionToDetail(entryEntity: DetailEntryEntity(count: Count(value: indexPath.row)))
    }
}

// MARK: Viewable
extension ListViewController: Viewable {}


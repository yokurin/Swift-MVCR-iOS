//
//  ListViewController.swift
//  SwiftMVCR
//
//  Created by 林　翼 on 2018/11/07.
//  Copyright © 2018年 Tsubasa Hayashi. All rights reserved.
//

import UIKit

final class ListViewController: UIViewController, Controllerable {

    static func configure(entryModel: ListEntryModel) -> ListViewController {
        let controller = ListViewController()
        controller.router = ListRouterOutput(controller)
        controller.entryModel = entryModel
        return controller
    }

    // MARK: Properties
    @IBOutlet weak private var closeButton: UIButton!
    @IBOutlet weak private var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }

    private var entryModel: ListEntryModel!
    private(set) var router: ListRouterOutput!

    internal var detailModel: DetailEntryModel! // Using when backed from Detail

    override func viewDidLoad() {
        super.viewDidLoad()
        closeButton.isHidden = navigationController?.viewControllers.count != 1
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let Model = detailModel {
            print("updated count: \(Model.count.value)")
        }
    }

    @IBAction func onCloseButtonTapped(_ sender: Any) {
        router.dismiss(animated: true)
    }

}

// MARK: UITableViewDelegate, UITableViewDataSource
extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entryModel.rowCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "default")
        cell.textLabel?.text = "row: \(indexPath.row)"
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        router.transitionToDetail(entryModel: DetailEntryModel(count: Count(value: indexPath.row)))
    }
}

// MARK: Viewable
extension ListViewController: Viewable {}


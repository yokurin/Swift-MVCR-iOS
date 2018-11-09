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
        let model = ListModel(entryModel: entryModel)
        model.delegate = controller
        controller.model = model
        return controller
    }

    // MARK: Properties
    @IBOutlet weak private var closeButton: UIButton!
    @IBOutlet weak private var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.estimatedRowHeight = UITableView.automaticDimension
        }
    }

    private(set) var model: ListModel!
    private(set) var router: ListRouterOutput!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Swift Repositories"
        closeButton.isHidden = navigationController?.viewControllers.count != 1
        model.fetch()
    }

    @IBAction func onCloseButtonTapped(_ sender: Any) {
        router.dismiss(animated: true)
    }
}

// MARK: ListViewModelDelegate
extension ListViewController: ListModelDelegate {
    func onSuccessSearch() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }

    func onErrorSearch(error: Error) {
        // nop
    }
}

// MARK: UITableViewDelegate, UITableViewDataSource
extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.gitHubRepositories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let repo = model.gitHubRepositories[safe: indexPath.row] else { return UITableViewCell() }
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "subtitle")
        cell.textLabel?.text = "\(repo.fullName)"
        cell.detailTextLabel?.textColor = UIColor.lightGray
        cell.detailTextLabel?.text = "\(repo.description)"
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let selectedRepo = model.gitHubRepositories[safe: indexPath.row] else { return }
        router.transitionToDetail(entryModel: DetailEntryModel(gitHubRepository: selectedRepo))
    }
}

// MARK: UIScrollViewDelegate
extension ListViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let visibleLastIndexPath = tableView.visibleCells.compactMap { [weak self] in
            self?.tableView.indexPath(for: $0)
        }.last
        guard visibleLastIndexPath?.row ?? 0 >= model.gitHubRepositories.count - 2 else { return }
        guard model.pageCount < 5 else { return }   // limit GitHub Api https://developer.github.com/v3/search/#search-repositories
        model.fetch()
    }
}

// MARK: Viewable
extension ListViewController: Viewable {}


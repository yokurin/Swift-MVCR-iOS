//
//  DetailViewController.swift
//  SwiftMVCR
//
//  Created by 林　翼 on 2018/11/08.
//  Copyright © 2018年 Tsubasa Hayashi. All rights reserved.
//

import UIKit
import WebKit

final class DetailViewController: UIViewController, Controllerable {

    static func configure(entryModel: DetailEntryModel) -> DetailViewController {
        let controller = DetailViewController()
        controller.router = DetailRouterOutput(controller)
        let model = DetailModel(entryModel: entryModel)
        controller.model = model
        return controller
    }

    @IBOutlet private weak var webView: WKWebView! {
        didSet {
            webView.uiDelegate = self
            webView.navigationDelegate = self
        }
    }
    @IBOutlet private weak var indicatorView: UIActivityIndicatorView!

    private(set) var model: DetailModel!
    private(set) var router: DetailRouterOutput!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = model.entryModel.gitHubRepository.fullName
        webView.load(URLRequest(url: URL(string: model.entryModel.gitHubRepository.url)!))
    }

}

extension DetailViewController: WKUIDelegate {}

extension DetailViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        indicatorView.isHidden = true
    }
}


extension DetailViewController: Viewable {}

//
//  ViewController.swift
//  SwiftMVCR
//
//  Created by 林　翼 on 2018/11/07.
//  Copyright © 2018年 Tsubasa Hayashi. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {

    @IBAction func pushListScreen(_ sender: UIButton) {
        ListRouterInput().push(from: self, entryModel: ListEntryModel())
    }

    @IBAction func presentListScreen(_ sender: UIButton) {
        ListRouterInput().present(from: self, entryModel: ListEntryModel())
    }
}

extension ViewController: Viewable {}

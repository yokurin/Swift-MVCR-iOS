//
//  Routerable.swift
//  SwiftMVCR
//
//  Created by 林　翼 on 2018/11/07.
//  Copyright © 2018年 Tsubasa Hayashi. All rights reserved.
//

import Foundation

protocol Routerable {
    var view: Viewable! { get }

    func dismiss(animated: Bool, completion: @escaping (() -> Void))
    func pop(animated: Bool)
}

extension Routerable {
    func dismiss(animated: Bool, completion: @escaping (() -> Void)) {
        view.dismiss(animated: animated, completion: {})
    }

    func pop(animated: Bool) {
        view.pop(animated: animated)
    }
}

//
//  Controllerable.swift
//  SwiftMVCR
//
//  Created by 林　翼 on 2018/11/07.
//  Copyright © 2018年 Tsubasa Hayashi. All rights reserved.
//

import Foundation
import UIKit

protocol Controllerable {
    // associatedtype Controller: UIViewController = Self
    associatedtype R: Routerable
    var router: R! { get }
    // static func configure() -> Controller
}

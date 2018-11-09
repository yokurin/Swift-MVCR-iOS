//
//  XibView.swift
//  SwiftMVCR
//
//  Created by 林　翼 on 2018/11/08.
//  Copyright © 2018年 Tsubasa Hayashi. All rights reserved.
//

import UIKit

class XibView: UIView {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addFilledXibView()
        configure()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addFilledXibView()
        configure()
    }

    var xibView: UIView {
        return subviews.first!
    }

    func configure() {
        backgroundColor = .clear
    }

    func addFilledXibView() {
        let view = viewFromXib(with: self)
        addFilledSubView(view)
    }

}

private func viewFromXib(with superView: UIView) -> UIView {
    let typeName = String(describing: type(of: superView)).components(separatedBy: "<")[0] // remove generics
    let nib = UINib(nibName: typeName, bundle: Bundle(for: type(of: superView)))
    guard let view = nib.instantiate(withOwner: superView, options: nil).first as? UIView else { fatalError("Not found Xib:" + typeName) }
    return view
}

extension UIView {
    func addFilledSubView(_ view: UIView) {
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.frame = bounds
        addSubview(view)
    }
}

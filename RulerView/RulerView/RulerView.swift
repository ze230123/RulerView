//
//  RulerView.swift
//  RulerView
//
//  Created by 泽i on 2017/11/27.
//  Copyright © 2017年 泽i. All rights reserved.
//
import UIKit

class LineLabel: UILabel {
    let line = CALayer()

    /// 便利
    convenience init(lineColor: UIColor) {
        self.init()
        textColor = lineColor
        line.backgroundColor = lineColor.cgColor
        layer.addSublayer(line)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        line.frame = CGRect(x: 0, y: frame.height - 1, width: frame.width, height: 1)
    }
}

class RulerView: UIView {

    private let longCellId = "LongCell"
    private let shortCellId = "ShortCell"

    private let line = UIView()
    private let textLabel = LineLabel(lineColor: UIColor.orange)

    var ruler: Ruler!
}

extension RulerView {
    convenience init() {
        self.init(frame: CGRect(x: 0, y: 100, width: UIScreen.main.bounds.width, height: 130))
        backgroundColor = UIColor.lightGray

        ruler = Ruler(rect: CGRect(x: 0, y: frame.height - 70, width: frame.width, height: 70), superView: self)
        addSubview(ruler)
        line.backgroundColor = UIColor.red
        addSubview(line)

        line.translatesAutoresizingMaskIntoConstraints = false
        line.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        line.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        line.widthAnchor.constraint(equalToConstant: 1).isActive = true
        line.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.7).isActive = true

        textLabel.text = "1000"
        addSubview(textLabel)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        textLabel.bottomAnchor.constraint(equalTo: line.topAnchor, constant: -8).isActive = true
        textLabel.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: 5).isActive = true
    }
}

extension RulerView {
    func set(current price: Int) {
        textLabel.text = "\(price)"
    }
}

//
//  RulerView.swift
//  RulerView
//
//  Created by 泽i on 2017/11/27.
//  Copyright © 2017年 泽i. All rights reserved.
//
import UIKit
/// 带下划线的Label
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
/// 整体的标尺视图
class RulerView: UIView {
    // x轴中心线
    private let line = UIView()
    /// 数值显示
    private let textLabel = LineLabel(lineColor: UIColor.orange)
    /// 标尺刻度
    var ruler: Ruler!

    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension RulerView {
    convenience init() {
        self.init(frame: CGRect(x: 0, y: 100, width: UIScreen.main.bounds.width, height: 120))
    }

    func initSubViews() {
        backgroundColor = UIColor.white
        // 创建标尺
        ruler = Ruler(rect: CGRect(x: 0, y: frame.height - 65, width: frame.width, height: 65), superView: self)
        addSubview(ruler)
        // 中心线
        line.backgroundColor = UIColor.orange
        addSubview(line)

        line.translatesAutoresizingMaskIntoConstraints = false
        line.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        line.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        line.widthAnchor.constraint(equalToConstant: 1).isActive = true
        line.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.7).isActive = true
        
        textLabel.text = "1000"
        textLabel.textAlignment = .center
        addSubview(textLabel)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        textLabel.bottomAnchor.constraint(equalTo: line.topAnchor, constant: -8).isActive = true
        textLabel.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: 5).isActive = true
        textLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 42).isActive = true
    }
}

extension RulerView {
    /// 设置当前数值
    func set(current price: Int) {
        textLabel.text = "\(price)"
    }
}

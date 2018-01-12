//
//  RulerViewCell.swift
//  RulerView
//
//  Created by 泽i on 2017/11/27.
//  Copyright © 2017年 泽i. All rights reserved.
//

import UIKit

private let longRatio: CGFloat = 0.65
private let shortRatio: CGFloat = 0.35

class LongLineCell: UICollectionViewCell {
    let textLabel = UILabel()

    private let line = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        let color = UIColor(white: 0.7, alpha: 1)
        textLabel.font = UIFont.systemFont(ofSize: 14)
        textLabel.textColor = color
        contentView.addSubview(textLabel)
        line.backgroundColor = color
        contentView.addSubview(line)

        addConstraint()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LongLineCell {
    private var lineHeight: CGFloat {
        return bounds.height * longRatio
    }
    private func addConstraint() {
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        textLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        textLabel.bottomAnchor.constraint(equalTo: line.topAnchor).isActive = true
        
        line.translatesAutoresizingMaskIntoConstraints = false
        line.centerXAnchor.constraint(equalTo: textLabel.centerXAnchor).isActive = true
        line.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        line.widthAnchor.constraint(equalToConstant: 1).isActive = true
        line.heightAnchor.constraint(equalToConstant: lineHeight).isActive = true
    }
}

class ShortLineCell: UICollectionViewCell {
    private let line = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        line.backgroundColor = UIColor(white: 0.8, alpha: 1)
        contentView.addSubview(line)
        addConstraint()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ShortLineCell {
    private var lineHeight: CGFloat {
        return bounds.height * shortRatio
    }

    private func addConstraint() {
        line.translatesAutoresizingMaskIntoConstraints = false
        line.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        line.widthAnchor.constraint(equalToConstant: 1).isActive = true
        line.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        line.heightAnchor.constraint(equalToConstant: lineHeight).isActive = true
    }
}

//
//  Ruler.swift
//  RulerView
//
//  Created by 泽i on 2017/11/27.
//  Copyright © 2017年 泽i. All rights reserved.
//

import UIKit

protocol RulerDelegate: class {
    func ruler(_ ruler: Ruler, currentPrice: Int)
}

private let padding: CGFloat = 0
/// item 的宽高比
private let aspectRatio: CGFloat = 0.3

class Ruler: UIView, UICollectionViewDelegateFlowLayout {
    /// 最大金额
    var maxPrice = 0 {
        didSet {
            assert((maxPrice % 100) == 0, "maxPrice 必须为100的倍数")
            setItemCount()
        }
    }

    /// 每个Item等于多少、单位`元`
    var ratio: Int = 100 {
        didSet {
            if maxPrice != 0 {
                setItemCount()
            }
        }
    }
    /// 初始位置
    var selectedPrice: Int = 0 {
        didSet {
//            collectionView.contentOffset.x = selectedPrice / CGFloat(ratio) * itemWidth
            let indexPath = IndexPath(item: selectedPrice / ratio, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }

    weak var delegate: RulerDelegate?

    private var itemCount = 0 {
        didSet {
            collectionView.reloadData()
        }
    }

    private let longCellId = "LongCell"
    private let shortCellId = "ShortCell"

    private weak var rulerView: RulerView?

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.minimumLineSpacing = padding
        let margin = (frame.width - itemWidth) / 2
        layout.sectionInset = UIEdgeInsets(top: 0, left: margin, bottom: 0, right: margin)
        let view = UICollectionView(frame: bounds, collectionViewLayout: layout)
        view.backgroundColor = UIColor.white
        view.bounces = false
        view.register(LongLineCell.self, forCellWithReuseIdentifier: longCellId)
        view.register(ShortLineCell.self, forCellWithReuseIdentifier: shortCellId)
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.autoresizingMask = [.flexibleTopMargin, .flexibleBottomMargin, .flexibleLeftMargin, .flexibleRightMargin]
        addSubview(collectionView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension Ruler {
    private var itemHeight: CGFloat {
        return bounds.height
    }

    private var itemWidth: CGFloat {
        return bounds.height * aspectRatio
    }

    private func setItemCount() {
        guard maxPrice != 0 else { return }
        itemCount = maxPrice / ratio + 1
    }
}

extension Ruler {
    convenience init(rect: CGRect, superView: RulerView) {
        self.init(frame: rect)
        rulerView = superView
    }
}

extension Ruler: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(#function)
        return itemCount
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        var cell: UICollectionViewCell

        switch indexPath.item % 5 {
        case 0:
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: longCellId, for: indexPath)
            (cell as? LongLineCell)?.textLabel.text = "\(indexPath.item * ratio)"
        default:
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: shortCellId, for: indexPath)
        }
        return cell
    }
}

extension Ruler: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let index = round(targetContentOffset.pointee.x / itemWidth)
        print(#function, index)
        targetContentOffset.pointee.x = index * itemWidth
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let index = round(scrollView.contentOffset.x / itemWidth)
        rulerView?.set(current: Int(index) * ratio)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = round(scrollView.contentOffset.x / itemWidth)
        let price = Int(index) * ratio
        delegate?.ruler(self, currentPrice: price)
    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        print(#function)
        let index = round(scrollView.contentOffset.x / itemWidth)
        let price = Int(index) * ratio
        delegate?.ruler(self, currentPrice: price)
    }
}


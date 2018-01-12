//
//  Ruler.swift
//  RulerView
//
//  Created by 泽i on 2017/11/27.
//  Copyright © 2017年 泽i. All rights reserved.
//

import UIKit

protocol RulerDelegate: NSObjectProtocol {
    func ruler(_ ruler: Ruler, currentPrice: Int)
}

extension RulerDelegate {
    func ruler(_ ruler: Ruler, currentPrice: Int) {
        
    }
}

/// items间隔
private let padding: CGFloat = 0
/// item 的宽高比
private let aspectRatio: CGFloat = 0.3

/// 标尺主体
class Ruler: UIView {
    /// 最大金额
    var maxPrice: Int = 0 {
        didSet {
            assert((maxPrice % 100) == 0, "maxPrice 必须为100的倍数")
            setItemCount()
        }
    }
    /// 每个Item等于多少金额
    ///
    /// 确保delegate回调的金额和传入的金额单位是一样的
    var ratio: Int = 100 {
        didSet {
            setItemCount()
        }
    }
    
    /// Cell显示的金额比例
    var textRatio: Int = 100
    
    /// Cell显示的金钱单位，默认--`元`
    var textUnit: String = "元"
    
    /// 初始位置
    var selectedPrice: Int = 0 {
        didSet {
            let indexPath = IndexPath(item: selectedPrice / ratio, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
    weak var delegate: RulerDelegate?
    
    /// item数量，最大金额换算后的count会+1
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
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.register(LongLineCell.self, forCellWithReuseIdentifier: longCellId)
        view.register(ShortLineCell.self, forCellWithReuseIdentifier: shortCellId)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        collectionView.dataSource = self
        collectionView.autoresizingMask = [.flexibleTopMargin, .flexibleBottomMargin, .flexibleLeftMargin, .flexibleRightMargin]
        addSubview(collectionView)
        // 标尺底部直线
        let line = CALayer()
        line.backgroundColor = UIColor(white: 0.7, alpha: 1).cgColor
        line.frame = CGRect(x: 0, y: frame.height - 1, width: frame.width, height: 1)
        layer.addSublayer(line)
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
    /// 计算Item数量
    private func setItemCount() {
        guard maxPrice != 0 else { return }
        itemCount = maxPrice / ratio + 1
    }
    /// 计算当前位置的金额
    private func calculatePrice(_ scrollView: UIScrollView) -> Int {
        let index = round(scrollView.contentOffset.x / itemWidth)
        return Int(index) * ratio
    }
}

extension Ruler {
    convenience init(rect: CGRect, superView: RulerView) {
        self.init(frame: rect)
        rulerView = superView
    }
}
// MARK: - UICollectionViewDataSource
extension Ruler: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemCount
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell: UICollectionViewCell

        switch indexPath.item % 5 {
        case 0:
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: longCellId, for: indexPath)
            (cell as? LongLineCell)?.textLabel.text = "\(indexPath.item * textRatio)\(textUnit)"
        default:
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: shortCellId, for: indexPath)
        }
        return cell
    }
}
// MARK: - UIScrollViewDelegate
extension Ruler: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        // 手指离开屏幕后，CollectionView将要停下的位置，换算成整数确保停留在中间线上
        let index = round(targetContentOffset.pointee.x / itemWidth)
        targetContentOffset.pointee.x = index * itemWidth
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 实时显示金额
        let index = round(scrollView.contentOffset.x / itemWidth)
        rulerView?.set(current: Int(index) * textRatio)
    }

    // 停下后通知代理当前选中的金额
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        delegate?.ruler(self, currentPrice: calculatePrice(scrollView))
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // 如果停在了边界，decelerate为false时通知代理
        guard !decelerate else { return }
        delegate?.ruler(self, currentPrice: calculatePrice(scrollView))
    }

    // 代码滚动
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        delegate?.ruler(self, currentPrice: calculatePrice(scrollView))
    }
}

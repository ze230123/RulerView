//
//  ViewController.swift
//  RulerView
//
//  Created by 泽i on 2017/11/27.
//  Copyright © 2017年 泽i. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        let rulerView = RulerView()
        view.addSubview(rulerView)
        rulerView.ruler.delegate = self
        rulerView.ruler.maxPrice = 1000
        rulerView.ruler.selectedPrice = 1000
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: RulerDelegate {
    func ruler(_ ruler: Ruler, currentPrice: Int) {
        guard currentPrice >= 500 else {
            ruler.selectedPrice = 500
            return
        }
        label.text = "\(currentPrice)"
    }
}

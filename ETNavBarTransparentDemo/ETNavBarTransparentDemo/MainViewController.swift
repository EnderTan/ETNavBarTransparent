//
//  MainViewController.swift
//  ETNavBarTransparentDemo
//
//  Created by Bing on 2017/3/1.
//  Copyright © 2017年 tanyunbing. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Testing for Color NavigationBar
//        self.navigationController?.navigationBar.barTintColor = .red
        
        if #available(iOS 11.0, *) {
            // Testing for LargeTitlesMode on iOS11
//            self.navigationController?.navigationBar.prefersLargeTitles = true
        }
    }

}

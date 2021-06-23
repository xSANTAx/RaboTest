//
//  BaseViewController.swift
//  RaboParser
//
//  Created by Andrei Ivanou2 on 6/18/21.
//

import UIKit

class BaseViewController: UIViewController {

    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

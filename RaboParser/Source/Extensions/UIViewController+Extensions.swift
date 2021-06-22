//
//  UIViewController+Extensions.swift
//  RaboParser
//
//  Created by Andrei Ivanou2 on 6/18/21.
//

import UIKit

extension UIViewController {
    static func loadFromNib() -> Self {
        func instantiateFromNib<T: UIViewController>() -> T {
            return T.init(nibName: String(describing: T.self), bundle: nil)
        }

        return instantiateFromNib()
    }
}

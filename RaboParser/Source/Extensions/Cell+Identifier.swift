//
//  Cell+Identifier.swift
//  RaboParser
//
//  Created by Andrei Ivanou2 on 6/20/21.
//

import UIKit

extension UITableViewCell {
    static var identifier: String {
        return String(describing: Self.self)
    }
}

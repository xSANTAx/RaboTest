//
//  DetailPageFactory.swift
//  RaboParser
//
//  Created by Andrei Ivanou2 on 6/21/21.
//

import UIKit

protocol DetailPageFactoryProtocol {
    func make(with issue: IssueModel) -> UIViewController
}

class DetailPageFactory: DetailPageFactoryProtocol {
    func make(with issue: IssueModel) -> UIViewController {
        let presenter = DetailPagePresenter(issue: issue)
        let view = DetailPageView(presenter: presenter)
        presenter.view = view
        return view
    }
}

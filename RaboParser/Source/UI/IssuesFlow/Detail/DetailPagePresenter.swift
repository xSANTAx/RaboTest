//
//  DetailPagePresenter.swift
//  RaboParser
//
//  Created by Andrei Ivanou2 on 6/21/21.
//

import Foundation

protocol DetailPagePresenterProtocol {
    func onViewDidLoad()
}

class DetailPagePresenter: DetailPagePresenterProtocol {
    weak var view: DetailPageViewProtocol?
    var issue: IssueModel
    
    init(issue: IssueModel) {
        self.issue = issue
    }
    
    func onViewDidLoad() {
        view?.update(issue)
    }
}

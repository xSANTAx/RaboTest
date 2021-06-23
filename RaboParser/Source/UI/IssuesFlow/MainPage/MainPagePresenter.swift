//
//  MainPagePresenter.swift
//  RaboParser
//
//  Created by Andrei Ivanou2 on 6/20/21.
//

import UIKit

protocol MainPagePresenterProtocol {
    func onViewDidLoad()
    func buttonParseTapped()
    func cellTapped(of indexPath: IndexPath)
    
    @discardableResult
    func configureCell(cell: IssueTableCellProtocol, for indexPath: IndexPath) -> Bool
}

class MainPagePresenter: MainPagePresenterProtocol {
    
    weak var view: MainPageViewProtocol?
    let parsingService: ParsingServiceProtocol
    let navigationCompletion: ((UserFlowEvent) -> Void)?
    var issues: [IssueModel] = []
    
    init(parsingService: ParsingServiceProtocol, completion: ((UserFlowEvent) -> Void)?) {
        self.parsingService = parsingService
        self.navigationCompletion = completion
    }
    
    func onViewDidLoad() {
        view?.update(.prepared)
    }
    
    func buttonParseTapped() {
        let fileName = "issues"
        
        view?.update(.loadind)
        parsingService.parseCVSFile(with: fileName) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let items):
                self.issues = items
                self.view?.update(.showIssuesCount(items.count))
                
            case .failure(let err):
                if err == .noFileFound {
                    self.view?.update(.notFound(fileName))
                } else {
                    self.view?.update(.error)
                }
            }
        }
    }
    
    func cellTapped(of indexPath: IndexPath) {
        let issue = issues[indexPath.row]
        navigationCompletion?(.detail(issue))
    }
    
    func configureCell(cell: IssueTableCellProtocol, for indexPath: IndexPath) -> Bool {
        
        let issue = issues[indexPath.row]
        cell.update(for: issue)
        
        return true
    }
}

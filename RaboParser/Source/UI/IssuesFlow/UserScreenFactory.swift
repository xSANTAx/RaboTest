//
//  UserScreenFactory.swift
//  RaboParser
//
//  Created by Andrei Ivanou2 on 6/21/21.
//

import UIKit

protocol UserScreenFactoryProtocol {
    func getMainPage(parsingService: ParsingServiceProtocol, completion: @escaping (UserFlowEvent) -> Void ) -> UIViewController
    
    func getDetailPage(issueModel: IssueModel) -> UIViewController
}

final class UserScreenFactory: UserScreenFactoryProtocol {
    
    func getMainPage(parsingService: ParsingServiceProtocol, completion: @escaping (UserFlowEvent) -> Void ) -> UIViewController {
        let mainPageFactory: MainPageFactoryProtocol = MainPageFactory()
        return mainPageFactory.make(parsingService: parsingService, completion: completion)
    }
    
    func getDetailPage(issueModel: IssueModel) -> UIViewController {
        let detailPageFactory: DetailPageFactoryProtocol = DetailPageFactory()
        return detailPageFactory.make(with: issueModel)
    }
}

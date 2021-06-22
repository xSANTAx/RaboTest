//
//  UserScreenFactory.swift
//  RaboParser
//
//  Created by Andrei Ivanou2 on 6/21/21.
//

import UIKit

protocol UserScreenFactoryProtocol {
    func getMainPage(parseService: ParseServiceProtocol, completion: @escaping (UserFlowEvent) -> Void ) -> UIViewController
    
    func getDetailPage(issueModel: IssueModel) -> UIViewController
}

final class UserScreenFactory: UserScreenFactoryProtocol {
    func getMainPage(parseService: ParseServiceProtocol, completion: @escaping (UserFlowEvent) -> Void ) -> UIViewController {
        let mainPageFactory: MainPageFactoryProtocol = MainPageFactory()
        return mainPageFactory.make(parseService: parseService, completion: completion)
    }
    
    func getDetailPage(issueModel: IssueModel) -> UIViewController {
        let detailPageFactory: DetailPageFactoryProtocol = DetailPageFactory()
        return detailPageFactory.make(with: issueModel)
    }
}

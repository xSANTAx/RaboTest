//
//  UserFlowCoordinator.swift
//  RaboParser
//
//  Created by Andrei Ivanou2 on 6/20/21.
//

import UIKit

enum UserFlowEvent {
    case detail(IssueModel)
}

class UserFlowCoordinator {
    let navigationController: UINavigationController
    let screenFactory: UserScreenFactoryProtocol

    init(navigationController: UINavigationController, screenFactory: UserScreenFactoryProtocol) {
        self.navigationController = navigationController
        self.screenFactory = screenFactory
    }

    func start(using window: UIWindow?) {
        let parseService: ParseServiceProtocol = ParseService()
        
        let viewController = screenFactory.getMainPage(parseService: parseService) { [weak self] event in
            guard let self = self else { return }
            
            switch event {
            case .detail(let issue):
                self.openDetailContent(issueModel: issue)
            }
        }

        navigationController.setViewControllers([viewController], animated: false)
        window?.rootViewController = navigationController
    }

    private func openDetailContent(issueModel: IssueModel) {
        let viewController = screenFactory.getDetailPage(issueModel: issueModel)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    deinit {
        print("\(self) deinit")
    }
}

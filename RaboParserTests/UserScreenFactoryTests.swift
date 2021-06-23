//
//  UserScreenFactoryMock.swift
//  RaboParserTests
//
//  Created by Andrei Ivanou2 on 6/21/21.
//

import XCTest
@testable import RaboParser

class UserScreenFactorytests: XCTestCase {
    
    func testCoordinator() {
        let navigationController = UINavigationController()
        let screenFactory = UserScreenFactoryMock()
        let parseFlow = UserFlowCoordinator(navigationController: navigationController, screenFactory: screenFactory)
        
        parseFlow.start(using: nil)
        XCTAssert(screenFactory.getMainContentWasCalled == true)
        
        let issueModel = IssueModel(name: "Andrei", surname: "Ivanou", dateOfBirth: Date(), issuesCount: 5)
        screenFactory.completion(.detail(issueModel))
        
        XCTAssert(screenFactory.getDetailContentWasCalled == true)
    }
}

final class UserScreenFactoryMock: UserScreenFactoryProtocol {
    var getMainContentWasCalled: Bool = false
    var getDetailContentWasCalled: Bool = false
    var completion: (UserFlowEvent) -> Void = { _ in }
    
    func getMainPage(parsingService: ParsingServiceProtocol, completion: @escaping (UserFlowEvent) -> Void) -> UIViewController {
        self.completion = completion
        getMainContentWasCalled = true
        
        return UIViewController()
    }
    
    func getDetailPage(issueModel: IssueModel) -> UIViewController {
        getDetailContentWasCalled = true
        return UIViewController()
    }
}

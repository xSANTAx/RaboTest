//
//  MainPageTests.swift
//  RaboParserTests
//
//  Created by Andrei Ivanou2 on 6/22/21.
//

import XCTest
@testable import RaboParser

class MainPageTests: XCTestCase {
    
    func testPrtesenter() {
        
        let parsingService = ParsingServiceMock()
        
        let presenter = MainPagePresenter(parsingService: parsingService, completion: nil)
        let view = MainPageViewMock()
        presenter.view = view
        
        presenter.onViewDidLoad()
        XCTAssertEqual(view.state, .prepared)
        
        presenter.buttonParseTapped()
        XCTAssertTrue(view.state == .showIssuesCount(1))
    }
}

struct ParsingServiceMock: ParsingServiceProtocol {
    
    func parseCVSFile(with name: String, completion: @escaping ParsingCompletion) {
        let issue = IssueModel(name: "name", surname: "surname", dateOfBirth: Date(), issuesCount: 3)
        completion(.success([issue]))
    }
}

final class MainPageViewMock: MainPageViewProtocol {
    
    var state: MainPageViewState?
    
    func update(_ state: MainPageViewState) {
        self.state = state
    }
}

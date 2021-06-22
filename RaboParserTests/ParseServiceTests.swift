//
//  ParseServiceTests.swift
//  RaboParserTests
//
//  Created by Andrei Ivanou2 on 6/22/21.
//

import XCTest
@testable import RaboParser

class ParseServiceTests: XCTestCase {
    
    func testParsingWithWrongFileName() {
        let parseService = ParseService()
        var parseResult: ParseResult<[IssueModel]> = ParseResult.success([])
        
        let exp = expectation(description: "Parse CVS file is successful")
        parseService.parseCVSFile(with: "test") { result in
            parseResult = result
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail("waitForExpectations error = \(error)")
            }
            XCTAssertEqual(parseResult, .failure(.noFileFound))
        }
    }
    
    func testParsingMockFile() {
        let parseService = ParseService()
        var resultCount = 0
        let exp = expectation(description: "Parse CVS file is successful")
        parseService.parseCVSFile(with: "issues_for_tests") { result in
            switch result {
            case .success(let issues):
                resultCount = issues.count
            case .failure:
                resultCount = 0
            }
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail("waitForExpectations error = \(error)")
            }
            
            XCTAssertEqual(resultCount, 2)
        }
    }
    
    func testEquitable() {
        
        let dob = Date()
        let issueModel1 = IssueModel(name: "Name", surname: "Surname", dateOfBirth: dob, issuesCount: 5)
        let issueModel2 = IssueModel(name: "Name", surname: "Surname", dateOfBirth: dob, issuesCount: 5)
        
        let issueModel3 = IssueModel(name: "Name2", surname: "Surname", dateOfBirth: dob, issuesCount: 5)
        let issueModel4 = IssueModel(name: "Name", surname: "Surname2", dateOfBirth: dob, issuesCount: 5)
        let issueModel5 = IssueModel(name: "Name", surname: "Surname2", dateOfBirth: Date(), issuesCount: 5)
        let issueModel6 = IssueModel(name: "Name", surname: "Surname2", dateOfBirth: dob, issuesCount: 6)
        
        XCTAssertEqual(issueModel1, issueModel2)
        XCTAssertNotEqual(issueModel1, issueModel3)
        XCTAssertNotEqual(issueModel1, issueModel4)
        XCTAssertNotEqual(issueModel1, issueModel5)
        XCTAssertNotEqual(issueModel1, issueModel6)
        
        let result1: ParseResult<[IssueModel]> = ParseResult.success([issueModel1, issueModel3])
        let result2: ParseResult<[IssueModel]> = ParseResult.success([issueModel1, issueModel3])
        
        XCTAssertEqual(result1, result2)
    }
}

//
//  ParsingErrors.swift
//  RaboParser
//
//  Created by Andrei Ivanou2 on 6/23/21.
//

import Foundation

typealias ParsingCompletion = (_ result: ParseResult<[IssueModel]>) -> Void

public enum ParseResult<T>: Equatable where T: Equatable {
    case failure(ParsingError)
    case success(T)
    
    static public func == (lhs: ParseResult, rhs: ParseResult) -> Bool {
        switch (lhs, rhs) {
        case (.failure, .failure):
            return true
            
        case (.success(let issuesLhs), .success(let issuesRhs)):
            return issuesLhs == issuesRhs
        default:
            return false
        }
    }
}

public enum ParsingError: Error, Equatable {
    case noFileFound
    case parseProblem
    case other(Error)
    
    static public func == (lhs: ParsingError, rhs: ParsingError) -> Bool {
        switch (lhs, rhs) {
        case (.noFileFound, .noFileFound),
             (.other, .other):
            return true
        default:
            return false
        }
    }
}

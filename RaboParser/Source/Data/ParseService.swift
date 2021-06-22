//
//  ParseService.swift
//  RaboParser
//
//  Created by Andrei Ivanou2 on 6/18/21.
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
            
        case (.success(let issues1), .success(let issues2)):
            return issues1 == issues2
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

protocol ParseServiceProtocol {
    func parseCVSFile(with name: String, completion: @escaping ParsingCompletion)
}

struct ParseService: ParseServiceProtocol {
    
    fileprivate struct Constants {
        static let comma: String = ","
        static let newLineChar: String = "\n"
        static let carriageChar: String = "\r"
        static let quoteChar: Character = "\""
    }
    
    func parseCVSFile(with name: String, completion: @escaping ParsingCompletion)  {
        let queue = DispatchQueue(label: "parse_file_queue", attributes: .concurrent)
        queue.async {
            self.parse(with: name) { result in
                DispatchQueue.main.async {
                    completion(result)
                }
            }
        }
    }
    
    private func parse(with name: String, completion: @escaping ParsingCompletion) {
        if let path = Bundle.main.path(forResource: name, ofType: "csv") {
            
            getContentOfFile(by: path) { content, error in
                guard let content = content else {
                    completion(.failure(error!))
                    return
                }
                var rows = content.components(separatedBy: Constants.newLineChar)
                rows.remove(at: 0)
                
                var issues: [IssueModel] = []
                for row in rows {
                    var clearRow = row.replacingOccurrences(of: Constants.carriageChar, with: "")
                    clearRow = clearRow.filter { $0 != Constants.quoteChar }
                    let values = clearRow.components(separatedBy: Constants.comma)
                    if let issueModel = IssueModel(values: values) {
                        issues.append(issueModel)
                    }
                }
                completion(.success(issues))
            }
        } else {
            completion(.failure(.noFileFound))
        }
    }
    
    private func getContentOfFile(by path: String, completion: (String?, ParsingError?) -> Void) {
        do {
            let content = try String(contentsOfFile: path)
            completion(content, nil)
        } catch {
            completion(nil, .other(error))
        }
    }
}

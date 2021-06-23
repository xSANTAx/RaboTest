//
//  ParsingService.swift
//  RaboParser
//
//  Created by Andrei Ivanou2 on 6/18/21.
//

import Foundation

protocol ParsingServiceProtocol {
    
    /**
     Function to parse CVS File
     
     - parameters:
        - name: The name of desired CVS file
        - completion: Closure, that returns the parsing result
     
     # Notes: #
     Completion has two return types:
     1. success. It contains Array of parsed items
     2. failure. Contains type of error: 'ParsingError'
     
     # Example #
     ```
     let parsingService: ParsingServiceProtocol = ParsingService()
     parsingService.parseCVSFile(with: "fileName") { result in
         switch result {
         case .success(let items):
             print("items = \(items)")
             
         case .failure(let err):
             print("error = \(err)")
         }
     }
     ```
     */
    func parseCVSFile(with name: String, completion: @escaping ParsingCompletion)
}

struct ParsingService: ParsingServiceProtocol {
    
    fileprivate struct Constants {
        static let comma: String = ","
        static let newLineChar: String = "\n"
        static let carriageChar: String = "\r"
        static let quoteChar: Character = "\""
    }
    
    func parseCVSFile(with name: String, completion: @escaping ParsingCompletion) {
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

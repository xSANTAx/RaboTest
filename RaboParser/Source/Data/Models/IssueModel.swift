//
//  IssuesModel.swift
//  RaboParser
//
//  Created by Andrei Ivanou2 on 6/20/21.
//

import Foundation

public struct IssueModel: Equatable {
    let name: String
    let surname: String
    let dateOfBirth: Date
    let issuesCount: Int
    
    init?(values: [String]) {
        guard values.count >= 4 else {
            return nil
        }
        
        self.name = values[0]
        self.surname = values[1]
        self.issuesCount = Int(values[2]) ?? 0
        self.dateOfBirth = Date.date(from: values[3]) ?? Date()
    }
    
    init(name: String, surname: String, dateOfBirth: Date, issuesCount: Int) {
        self.name = name
        self.surname = surname
        self.dateOfBirth = dateOfBirth
        self.issuesCount = issuesCount
    }
    
    func representDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM y"
        return dateFormatter.string(from: self.dateOfBirth)
    }
    
    static public func == (lhs: IssueModel, rhs: IssueModel) -> Bool {
        lhs.name == rhs.name && lhs.surname == rhs.surname && lhs.dateOfBirth == rhs.dateOfBirth && lhs.issuesCount == rhs.issuesCount
    }
}

extension Date {
    static func date(from string: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        return dateFormatter.date(from: string)
    }
}

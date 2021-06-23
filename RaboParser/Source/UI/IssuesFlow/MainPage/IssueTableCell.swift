//
//  IssueTableCell.swift
//  RaboParser
//
//  Created by Andrei Ivanou2 on 6/20/21.
//

import UIKit

protocol IssueTableCellProtocol {
    func update(for issue: IssueModel)
}

// MARK: - Variables
final class IssueTableCell: UITableViewCell {

    fileprivate lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.numberOfLines = 0
        label.textColor = .customBlack
        label.backgroundColor = .clear
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate lazy var bodLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.numberOfLines = 0
        label.textColor = .customBlack
        label.font = UIFont.systemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate lazy var issuesLabel: UILabel = {
        let label = UILabel()
        label.text = "Issues: "
        label.numberOfLines = 0
        label.textColor = .customBlack
        label.font = UIFont.systemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate lazy var issuesCountLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.numberOfLines = 0
        label.textColor = .customBlack
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate lazy var chevronImage: UIImageView = {
        let largeFont = UIFont.systemFont(ofSize: 13)
        var imageView = UIImageView()
        if #available(iOS 13.0, *) {
            let configuration = UIImage.SymbolConfiguration(font: largeFont)
            imageView = UIImageView(image: UIImage(systemName: "chevron.right", withConfiguration: configuration))
        } else {
            imageView = UIImageView(image: UIImage(named: "front_arrow"))
        }

        imageView.tintColor = .customBlack
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
}

// MARK: - ViewController life cycle
fileprivate extension IssueTableCell {

    func setupUI() {
        contentView.backgroundColor = .customGray
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(bodLabel)
        contentView.addSubview(issuesLabel)
        contentView.addSubview(issuesCountLabel)
        contentView.addSubview(chevronImage)
        
        let namelabelConstraints = [
            nameLabel.bottomAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 3),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24)
        ]
        
        let bodlabelConstraints = [
            bodLabel.topAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 3),
            bodLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24)
        ]
        
        let chevronConstraints = [
            chevronImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            chevronImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24)
        ]
        
        let issueslabelConstraints = [
            issuesLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            issuesLabel.trailingAnchor.constraint(equalTo: issuesCountLabel.leadingAnchor, constant: -6)
        ]
        
        let issuesCountlabelConstraints = [
            issuesCountLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            issuesCountLabel.trailingAnchor.constraint(equalTo: chevronImage.leadingAnchor, constant: -50)
        ]

        NSLayoutConstraint.activate(namelabelConstraints + bodlabelConstraints + issueslabelConstraints + issuesCountlabelConstraints + chevronConstraints)
    }
}

extension IssueTableCell: IssueTableCellProtocol {
    
    func update(for issue: IssueModel) {
        nameLabel.text = issue.name + " " + issue.surname
        bodLabel.text = issue.representDate()
        issuesCountLabel.text = "\(issue.issuesCount)"
    }
}

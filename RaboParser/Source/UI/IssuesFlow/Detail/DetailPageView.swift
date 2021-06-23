//
//  DetailPage.swift
//  RaboParser
//
//  Created by Andrei Ivanou2 on 6/21/21.
//

import UIKit

protocol DetailPageViewProtocol: AnyObject {
    func update(_ issue: IssueModel)
}

final class DetailPageView: BaseViewController {
    
    fileprivate lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .customBlack
        label.backgroundColor = .clear
        label.font = UIFont.systemFont(ofSize: 30)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate lazy var bodLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .customBlack
        label.backgroundColor = .clear
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate lazy var issuesLabel: UILabel = {
        let label = UILabel()
        label.text = "Issues: "
        label.textColor = .customBlack
        label.font = UIFont.systemFont(ofSize: 25)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate lazy var issuesCountLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.numberOfLines = 0
        label.textColor = .customBlack
        label.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let presenter: DetailPagePresenter

    init(presenter: DetailPagePresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder: \(coder) has not been implemented")
    }
    
    func setupUI() {
        view.addSubview(nameLabel)
        view.addSubview(bodLabel)
        view.addSubview(issuesLabel)
        view.addSubview(issuesCountLabel)

        let nameLabelConstraints = [
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]
        
        let bodLabelConstraints = [
            bodLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            bodLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]
        
        let issuesLabelConstraints = [
            issuesLabel.topAnchor.constraint(equalTo: bodLabel.bottomAnchor, constant: 50),
            issuesLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]
        
        let issuesCountLabelConstraints = [
            issuesCountLabel.leadingAnchor.constraint(equalTo: issuesLabel.trailingAnchor, constant: 5),
            issuesCountLabel.centerYAnchor.constraint(equalTo: issuesLabel.centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(nameLabelConstraints + bodLabelConstraints + issuesLabelConstraints + issuesCountLabelConstraints)
    }
}

// MARK: - LifeCycle
extension DetailPageView {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.onViewDidLoad()
        setupUI()
    }
}

// MARK: - View Protocol
extension DetailPageView: DetailPageViewProtocol {
    
    func update(_ issue: IssueModel) {
        nameLabel.text = issue.name + " " + issue.surname
        bodLabel.text = issue.representDate()
        issuesCountLabel.text = "\(issue.issuesCount)"
    }
}

//
//  MainPageView.swift
//  RaboParser
//
//  Created by Andrei Ivanou2 on 6/18/21.
//

import UIKit

public enum MainPageViewState: Equatable {
    case prepared
    case loadind
    case notFound(String)
    case showIssuesCount(Int)
    case error
    
    static public func == (lhs: MainPageViewState, rhs: MainPageViewState) -> Bool {
        switch (lhs, rhs) {
        case (.prepared, .prepared),
             (.loadind, .loadind),
             (.error, .error):
            return true
        case (.notFound(let nameLhs), .notFound(let nameRhs)):
            return nameLhs == nameRhs
        case (.showIssuesCount(let countLhs), .showIssuesCount(let countRhs)):
            return countLhs == countRhs
        default:
            return false
        }
    }
}

protocol MainPageViewProtocol: AnyObject {
    func update(_ state: MainPageViewState)
}

final class MainPageView: BaseViewController {
    
    fileprivate struct Constants {
        static let sidePadding: CGFloat = 24
    }
    
    fileprivate lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.text = "Parsing in progress..."
        label.textColor = .customBlack
        label.backgroundColor = .clear
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate lazy var parseButton: UIButton = {
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(pressed), for: .touchUpInside)
        button.setTitle("Parse", for: .normal)
        button.setTitleColor(.customBlack, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.backgroundColor = .customGray
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.black.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    fileprivate lazy var tryAgainButton: UIButton = {
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(pressed), for: .touchUpInside)
        button.setTitle("Parse", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(IssueTableCell.self, forCellReuseIdentifier: IssueTableCell.identifier)
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = 50
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let presenter: MainPagePresenterProtocol
    private var numberOfItems: Int

    init(presenter: MainPagePresenterProtocol) {
        self.presenter = presenter
        self.numberOfItems = 0
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder: \(coder) has not been implemented")
    }
    
    func setupUI() {
        title = "Issues"
        
        view.addSubview(infoLabel)
        view.addSubview(tableView)
        view.addSubview(parseButton)
        view.addSubview(tryAgainButton)

        let infoLabelConstraints = [
            infoLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            infoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            infoLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ]
        
        let buttonConstraints = [
            parseButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            parseButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            parseButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            parseButton.heightAnchor.constraint(equalTo: parseButton.widthAnchor, multiplier: 0.3)
        ]
        
        let tryAgainButtonConstraints = [
            tryAgainButton.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 16),
            tryAgainButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]
        
        let tableConstraints = [
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
        
        NSLayoutConstraint.activate(infoLabelConstraints + buttonConstraints + tryAgainButtonConstraints + tableConstraints)
    }
}

// MARK: - LifeCycle
extension MainPageView {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.onViewDidLoad()
        setupUI()
    }
}

// MARK: - View Protocol
extension MainPageView: MainPageViewProtocol {
    
    func update(_ numberOfItems: Int) {
        self.numberOfItems = numberOfItems
        tableView.reloadData()
    }
    
    func update(_ state: MainPageViewState) {
        parseButton.isHidden = true
        infoLabel.isHidden = true
        infoLabel.text = ""
        tableView.isHidden = true
        tryAgainButton.isHidden = true
        
        switch state {
        case .prepared:
            parseButton.isHidden = false
            
        case .loadind:
            infoLabel.isHidden = false
            infoLabel.text = "Parsing in progress..."
            
        case .showIssuesCount(let itemsCount):
            tableView.isHidden = false
            numberOfItems = itemsCount
            tableView.reloadData()
        
        case .notFound(let name):
            print("NotFound")
            infoLabel.isHidden = false
            infoLabel.text = "File '\(name)' not found. Please enter another name"
            
        case .error:
            infoLabel.isHidden = false
            tryAgainButton.isHidden = false
            infoLabel.text = "Error is occured. Please try again"
        }
    }
}

// MARK: - Actions
extension MainPageView {
    
    @objc func pressed() {
        presenter.buttonParseTapped()
    }
}

// MARK: - TableView methods
extension MainPageView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        numberOfItems
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: IssueTableCell.identifier, for: indexPath) as! IssueTableCell
        
        presenter.configureCell(cell: cell, for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.cellTapped(of: indexPath)
    }
}

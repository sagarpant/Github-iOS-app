//
//  ClosedRepoListViewController.swift
//  GithubProfile
//
//  Created by Sagar Pant on 07/08/22.
//

import UIKit

class ClosedPullRequestListViewController: UIViewController {
   
    private let viewModel: ClosedRepoViewModel
    
    init(viewModel: ClosedRepoViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView.withAutoLayout()
        tableView.register(ClosedPullRequestViewCell.self, forCellReuseIdentifier: ClosedPullRequestViewCell.closedPullRequestViewCellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        navigationItem.title = "Closed Pull Requests"
        view.setNeedsUpdateConstraints()
        viewModel.start()
    }
    
    override func updateViewConstraints() {
        NSLayoutConstraint.activate(staticConstraints())
        super.updateViewConstraints()
    }
    
    private func staticConstraints() -> [NSLayoutConstraint] {
        return [
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
    }

}

extension ClosedPullRequestListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfClosedPullRequests
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ClosedPullRequestViewCell.closedPullRequestViewCellIdentifier, for: indexPath) as? ClosedPullRequestViewCell else {
            return UITableViewCell()
        }
        cell.viewData = viewModel.closedRepoViewData(for: indexPath)
        return cell
    }
}

extension ClosedPullRequestListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}

extension ClosedPullRequestListViewController: ClosedRepoViewModelDelegate {
    func viewModelCompletedFetch(result: Result<Void, ClosedPullRequestViewModelError>) {
        switch result {
        case .success():
            tableView.reloadData()
        case .failure(let closedPullRequestViewModelError):
            print(closedPullRequestViewModelError)
        }
    }
}


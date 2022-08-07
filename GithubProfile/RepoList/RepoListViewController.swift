//
//  RepoListViewController.swift
//  GithubProfile
//
//  Created by Sagar Pant on 07/08/22.
//

import UIKit

class RepoListViewController: UIViewController {

    
    private let viewModel: RepoListViewModel
    
    init(viewModel: RepoListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView.withAutoLayout()
        tableView.register(RepoListCell.self, forCellReuseIdentifier: RepoListCell.repoListIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        navigationItem.title = "Repository List"
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

extension RepoListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRepos
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RepoListCell.repoListIdentifier, for: indexPath) as? RepoListCell else {
            return UITableViewCell()
        }
        cell.viewData = viewModel.repoViewData(for: indexPath)
        return cell
    }
}

extension RepoListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let closedRepoViewModel = ClosedPullRequestViewModelImp(userName: viewModel.user, repoName: viewModel.repoName(indexPath: indexPath))
        let closedPullRequestListViewController = ClosedPullRequestListViewController(viewModel: closedRepoViewModel)
        closedRepoViewModel.delegate = closedPullRequestListViewController
        navigationController?.pushViewController(closedPullRequestListViewController, animated: true)
    }
}

extension RepoListViewController: RepoListViewModelDelegate {
    func viewModelCompletedFetch(result: Result<Void, RepoListViewModelError>) {
        switch result {
        case.failure(let error) :
            print(error)
        case .success():
            tableView.reloadData()
        }
    }
    
}

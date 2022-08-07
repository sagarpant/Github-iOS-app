//
//  RepoListViewModel.swift
//  GithubProfile
//
//  Created by Sagar Pant on 07/08/22.
//

import Foundation

protocol RepoListViewModel {
    func start()
    var user: String { get }
    func repoName(indexPath: IndexPath) -> String
    var numberOfRepos: Int { get }
    func repoViewData(for indexPath: IndexPath) -> RepoListCell.ViewData
}

protocol RepoListViewModelDelegate: AnyObject {
    func viewModelCompletedFetch(result: Result<Void, RepoListViewModelError>)
}

enum RepoListViewModelError: Error {
    case networkError
    case parsingError
}

struct Repository: Codable {
    let name: String
}

final class RepoListViewModelImp {
    
    var repoList: [Repository] = []
    weak var delegate: RepoListViewModelDelegate?
    
    private let userName: String
    
    init(userName: String) {
        self.userName = userName
    }
}

extension RepoListViewModelImp: RepoListViewModel {
    func start() {
        guard let url = URL(string: "https://api.github.com/users/\(userName)/repos") else {
            
            return
        }
        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            if error != nil {
                DispatchQueue.main.async {
                    self.delegate?.viewModelCompletedFetch(result: .failure(.networkError))
                }
            } else {
                guard let data = data,
                      let repoList = try? JSONDecoder().decode([Repository].self, from: data) else {
                    DispatchQueue.main.async {
                        self.delegate?.viewModelCompletedFetch(result: .failure(.parsingError))
                    }
                    return
                }
                self.repoList = repoList
                DispatchQueue.main.async {
                    self.delegate?.viewModelCompletedFetch(result: .success(()))
                }
            }
        }
        .resume()
    }
    
    var numberOfRepos: Int {
        repoList.count
    }
    
    func repoViewData(for indexPath: IndexPath) -> RepoListCell.ViewData {
        return RepoListCell.ViewData(repoName: repoList[indexPath.row].name)
    }
    
    var user: String {
        userName
    }
    
    func repoName(indexPath: IndexPath) -> String {
        repoList[indexPath.row].name
    }
}


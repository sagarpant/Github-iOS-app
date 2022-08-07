//
//  ClosedRepoViewModel.swift
//  GithubProfile
//
//  Created by Sagar Pant on 07/08/22.
//

import Foundation

// MARK: Model
struct ClosedPullRequests: Codable {
    let title: String
    let created_at: String
    let closed_at: String
    let user: ClosedPullRequestUser
}

struct ClosedPullRequestUser: Codable {
    let login: String
    let avatar_url: String
}

// MARK: VC-> ViewModel
protocol ClosedRepoViewModel {
    func start()
    var numberOfClosedPullRequests: Int { get }
    func closedRepoViewData(for indexPath: IndexPath) -> ClosedPullRequestViewCell.ViewData
}

// MARK: ViewModel-> VC
protocol ClosedRepoViewModelDelegate: AnyObject {
    func viewModelCompletedFetch(result: Result<Void, ClosedPullRequestViewModelError>)
}

// MARK: ViewModel Errors
enum ClosedPullRequestViewModelError: Error {
    case networkError
    case parsingError
}

final class ClosedPullRequestViewModelImp {
    
    weak var delegate: ClosedRepoViewModelDelegate?
    private var closedPullRequests: [ClosedPullRequests] = []
    static let dateFormatter = ISO8601DateFormatter()
    private let userName: String
    private let repoName: String
    
    init(userName: String,
         repoName: String) {
        self.userName = userName
        self.repoName = repoName
    }
    
    func start() {
        guard let url = URL(string: "https://api.github.com/repos/\(userName)/\(repoName)/pulls?state=closed") else {
            return
        }
        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            if error != nil {
                DispatchQueue.main.async {
                    self.delegate?.viewModelCompletedFetch(result: .failure(.networkError))
                }
            } else {
                guard let data = data,
                      let closedPullRequests = try? JSONDecoder().decode([ClosedPullRequests].self, from: data) else {
                          DispatchQueue.main.async {
                              self.delegate?.viewModelCompletedFetch(result: .failure(.parsingError))
                          }
                    
                          return
                }
                self.closedPullRequests = closedPullRequests
                DispatchQueue.main.async {
                    self.delegate?.viewModelCompletedFetch(result: .success(()))
                }
            }
        }
        .resume()
    }
    
}

extension ClosedPullRequestViewModelImp: ClosedRepoViewModel {
    
    var numberOfClosedPullRequests: Int {
        closedPullRequests.count
    }
    
    func closedRepoViewData(for indexPath: IndexPath) -> ClosedPullRequestViewCell.ViewData {
        let closedPullRequest = closedPullRequests[indexPath.row]
        let imageUrl: URL
        if let imgURL = URL(string: closedPullRequest.user.avatar_url) {
            imageUrl = imgURL
        } else {
            imageUrl = URL(string: "https://as2.ftcdn.net/v2/jpg/02/17/34/67/1000_F_217346782_7XpCTt8bLNJqvVAaDZJwvZjm0epQmj6j.jpg")!
        }
        
        let createdAtDate = ClosedPullRequestViewModelImp.dateFormatter.date(from: closedPullRequest.created_at)?.formatted()
        let closedAtDate = ClosedPullRequestViewModelImp.dateFormatter.date(from: closedPullRequest.closed_at)?.formatted()
        
        return ClosedPullRequestViewCell.ViewData(userName: closedPullRequest.user.login, userImageUrl: imageUrl, pullRequestTitle: closedPullRequest.title, createdDate: createdAtDate, closedDate: closedAtDate)
    }
}

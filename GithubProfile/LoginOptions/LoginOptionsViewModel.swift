//
//  LoginOptionsViewModel.swift
//  GithubProfile
//
//  Created by Sagar Pant on 07/08/22.
//

import Foundation
import FirebaseAuth

protocol LoginOptionsViewModel {
    func getUserName(completion: @escaping (String) -> Void)
}

final class LoginOptionsViewModelImp: LoginOptionsViewModel {
    private let provider: OAuthProvider
    
    init(provider: OAuthProvider) {
        self.provider = provider
    }
    
    func getUserName(completion: @escaping (String) -> Void) {
        provider.customParameters = [
            "allow_signup" : "false"
        ]
        provider.scopes = ["user:email", "repo", "public_repo"]
        provider.getCredentialWith(nil) { credential, error in
              if error != nil {
                // Handle error.
              }
              if let credential = credential {
                  Auth.auth().signIn(with: credential) { authResult, error in
                  if error != nil {
                    // Handle error.
                  }
                

                  guard let authResult = authResult,
                        let oauthCredential = authResult.credential as? OAuthCredential,
                        let accessToken = oauthCredential.accessToken else { return }
                      let url = URL(string: "https://api.github.com/user")!
                      var urlRequest = URLRequest(url: url)
                      urlRequest.setValue(" token \(accessToken)", forHTTPHeaderField: "Authorization")
                      URLSession.shared.dataTask(with: urlRequest) { data, _, error in
                          if error == nil {
                              guard let data = data,
                                    let json = try? JSONSerialization.jsonObject(with: data) as? [AnyHashable: Any],
                                    let name = json["login"] as? String else {
                                  return
                              }
                              DispatchQueue.main.async {
                                  completion(name)
                              }
                          }
                      }.resume()
                  }
              }
        }
    }
    
    
}

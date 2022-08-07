//
//  LoginOptionsViewController.swift
//  GithubProfile
//
//  Created by Sagar Pant on 02/08/22.
//

import UIKit
import FirebaseAuth

class LoginOptionsViewController: UIViewController {
    
    private let viewModel: LoginOptionsViewModel
    
    init(viewModel: LoginOptionsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var mainStackView: UIStackView = {
       let mainStackView = UIStackView(arrangedSubviews: [topStackView, bottomStackView])
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.axis = .vertical
        return mainStackView
    }()
   
    private lazy var imageHorizontalSpacers: HorizontalSpacers = {
        let leftImageViewSpacer = UIView.withAutoLayout()
        let rightImageViewSpacer = UIView.withAutoLayout()
        return (leading: leftImageViewSpacer, trailing: rightImageViewSpacer)
    }()
    
    private lazy var horizontalGithubImageStackView: UIStackView = {
        let horizontalGithubImageStackView = UIStackView(arrangedSubviews: [imageHorizontalSpacers.leading,
                                                                           githubImageView,
                                                                            imageHorizontalSpacers.trailing])
        horizontalGithubImageStackView.translatesAutoresizingMaskIntoConstraints = false
        return horizontalGithubImageStackView
    }()
    
    private lazy var imageVerticalSpacers: VerticalSpacers = {
        let topView = UIView.withAutoLayout()
        let bottomView = UIView.withAutoLayout()
        return (top: topView, bottom: bottomView)
    }()
    
    private lazy var topStackView: UIStackView = {
        let topStackView = UIStackView(arrangedSubviews: [imageVerticalSpacers.top, horizontalGithubImageStackView, imageVerticalSpacers.bottom])
        topStackView.translatesAutoresizingMaskIntoConstraints = false
        topStackView.axis = .vertical
        return topStackView
    }()
    
    private lazy var bottomButtonSpacer: UIView = {
        return UIView.withAutoLayout()
    }()
    
    private lazy var bottomStackView: UIStackView = {
       let bottomStackView = UIStackView(arrangedSubviews: [oAuthButtonStackView, nameRepoButtonStackView, bottomButtonSpacer])
        bottomStackView.axis = .vertical
        bottomStackView.spacing = 20
        return bottomStackView
    }()
    
    private lazy var githubImageView: UIImageView = {
        let imageView = UIImageView.withAutoLayout()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    
    private lazy var oAuthButtonStackViewHorizontalSpacers: HorizontalSpacers = {
        return (leading: UIView.withAutoLayout(), trailing: UIView.withAutoLayout())
    }()
    
    private lazy var oAuthButtonStackView: UIStackView = {
        let oAuthButtonStackView = UIStackView(arrangedSubviews: [oAuthButtonStackViewHorizontalSpacers.leading, oauthButton, oAuthButtonStackViewHorizontalSpacers.trailing])
        return oAuthButtonStackView
    }()
    
    private lazy var oauthButton: Button = {
        let oauthButton = Button.withAutoLayout()
        oauthButton.addTarget(self, action: #selector(oAuthButtonTapped), for: .touchUpInside)
        return oauthButton
    }()
    
    
    private lazy var nameRepoButtonStackViewHorizontalSpacers: HorizontalSpacers = {
        return (leading: UIView.withAutoLayout(), trailing: UIView.withAutoLayout())
    }()
    
    private lazy var nameRepoButtonStackView: UIStackView = {
        let nameRepoButtonStackView = UIStackView(arrangedSubviews: [nameRepoButtonStackViewHorizontalSpacers.leading, nameRepoButton, nameRepoButtonStackViewHorizontalSpacers.trailing])
        return nameRepoButtonStackView
    }()
    
    private lazy var nameRepoButton: Button = {
        let nameRepoButton = Button.withAutoLayout()
        nameRepoButton.addTarget(self, action: #selector(nameRepoButtonTapped), for: .touchUpInside)
        return nameRepoButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(mainStackView)
        navigationController?.navigationBar.prefersLargeTitles = true
        // Do any additional setup after loading the view.
        view.setNeedsUpdateConstraints()
        render()
    }
    
    override func updateViewConstraints() {
        NSLayoutConstraint.activate(staticConstaints())
        super.updateViewConstraints()
    }
    
    private func render() {
        githubImageView.image = UIImage(named: "github1")?.withTintColor(.secondaryColor, renderingMode: .alwaysOriginal)
        oauthButton.backgroundColor = .buttonNormalColor
        nameRepoButton.backgroundColor = .buttonNormalColor
        oauthButton.setTitleColor(.secondaryColor, for: .normal)
        nameRepoButton.setTitleColor(.secondaryColor, for: .normal)
        oauthButton.setTitle("OAuth", for: .normal)
        nameRepoButton.setTitle("Name Repo", for: .normal)
        nameRepoButton.layer.cornerRadius = 8
        oauthButton.layer.cornerRadius = 8
        view.backgroundColor = .primaryColor
    }

    private func staticConstaints() -> [NSLayoutConstraint] {
        return [
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainStackView.topAnchor.constraint(equalTo: view.topAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            imageHorizontalSpacers.leading.widthAnchor.constraint(equalTo: imageHorizontalSpacers.trailing.widthAnchor),
            imageVerticalSpacers.top.heightAnchor.constraint(equalTo: imageVerticalSpacers.bottom.heightAnchor),
            
            topStackView.heightAnchor.constraint(equalTo: mainStackView.heightAnchor, multiplier: 0.6),
            
            githubImageView.widthAnchor.constraint(equalTo: horizontalGithubImageStackView.widthAnchor, multiplier: 0.6),
            githubImageView.heightAnchor.constraint(equalTo: topStackView.heightAnchor, multiplier: 0.8),
            
            
            oauthButton.heightAnchor.constraint(equalToConstant: 40),
            nameRepoButton.heightAnchor.constraint(equalToConstant: 40),
            
            nameRepoButton.widthAnchor.constraint(equalTo: nameRepoButtonStackView.widthAnchor, multiplier: 0.6),
            oauthButton.widthAnchor.constraint(equalTo: oAuthButtonStackView.widthAnchor, multiplier: 0.6),
            
            oAuthButtonStackViewHorizontalSpacers.leading.widthAnchor.constraint(equalTo: oAuthButtonStackViewHorizontalSpacers.trailing.widthAnchor),
            nameRepoButtonStackViewHorizontalSpacers.leading.widthAnchor.constraint(equalTo: nameRepoButtonStackViewHorizontalSpacers.trailing.widthAnchor)
            
        ]
    }
    
    @objc
    private func nameRepoButtonTapped() {
        let nameRepoViewController = UserNameInputViewController()
        navigationController?.pushViewController(nameRepoViewController, animated: true)
    }
    
    @objc
    private func oAuthButtonTapped() {
        viewModel.getUserName { userName in
            let repoListViewModel = RepoListViewModelImp(userName: userName)
            let repoListViewController = RepoListViewController(viewModel: repoListViewModel)
            repoListViewModel.delegate = repoListViewController
            self.navigationController?.pushViewController(repoListViewController, animated: true)
        }
    }
    
}

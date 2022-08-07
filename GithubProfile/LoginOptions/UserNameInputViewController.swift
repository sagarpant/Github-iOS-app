//
//  NameRepoViewController.swift
//  GithubProfile
//
//  Created by Sagar Pant on 03/08/22.
//

import UIKit
import Lottie

class UserNameInputViewController: UIViewController {

    private lazy var topView: UIView = {
        let topView = UIView.withAutoLayout()
        return topView
    }()
    
    private lazy var animationView: AnimationView = {
       let animationView = AnimationView(name: "user")
        animationView.clipsToBounds = true
        animationView.translatesAutoresizingMaskIntoConstraints = false
        return animationView
    }()
    
    
    private lazy var doneButton: Button = {
        let doneButton = Button.withAutoLayout()
        doneButton.addTarget(self, action: #selector(doneButtonPressed), for: .touchUpInside)
        return doneButton
    }()
    
    private lazy var textFieldHorizontalSpacers: HorizontalSpacers = {
        let leading = UIView.withAutoLayout()
        let trailing = UIView.withAutoLayout()
        return (leading: leading, trailing: trailing)
    }()
    
    private lazy var textField: TextField = {
        let textField = TextField.withAutoLayout()
        textField.delegate = self
        textField.backgroundColor = .colorOnPrimary
        return textField
    }()
    
    private lazy var textFieldStackView: UIStackView = {
        let textFieldStackView = UIStackView(arrangedSubviews: [textFieldHorizontalSpacers.leading, textField, textFieldHorizontalSpacers.trailing])
        textFieldStackView.translatesAutoresizingMaskIntoConstraints = false
        return textFieldStackView
    }()
    
    private lazy var buttonHorizontalSpacers: HorizontalSpacers = {
        let leading = UIView.withAutoLayout()
        let trailing = UIView.withAutoLayout()
        return (leading: leading, trailing: trailing)
    }()
    
    private lazy var buttonHorizontalStackView: UIStackView = {
        let buttonHorizontalStackView = UIStackView(arrangedSubviews: [buttonHorizontalSpacers.leading, doneButton, buttonHorizontalSpacers.trailing])
        buttonHorizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        return buttonHorizontalStackView
    }()
    
    private lazy var bottomStackViewSpacer: UIView = {
        let bottomSpacer = UIView.withAutoLayout()
        return bottomSpacer
    }()
    
    private lazy var bottomStackView: UIStackView = {
        let bottomStackView = UIStackView(arrangedSubviews: [textFieldStackView, buttonHorizontalStackView, bottomStackViewSpacer])
        bottomStackView.axis = .vertical
        bottomStackView.translatesAutoresizingMaskIntoConstraints = false
        bottomStackView.spacing = 20
        return bottomStackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(topView)
        view.addSubview(bottomStackView)
        topView.addSubview(animationView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideNotification(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardDidChangeFrame(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        // Do any additional setup after loading the view.
        view.setNeedsUpdateConstraints()
        render()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animationView.play()
    }
    
    @objc
    private func keyBoardDidChangeFrame(_ notification: NSNotification) {
        let height = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height ?? 0
        
        UIView.animate(withDuration: 0.5) {
            self.view.bounds = CGRect(x: 0, y: height, width: self.view.bounds.width, height: self.view.bounds.height)
        }

    }
    
    @objc private func keyboardWillHideNotification(_ notification: NSNotification) {
        let width = view.bounds.width
        let height = view.bounds.height
        UIView.animate(withDuration: 0.5) {
            self.view.bounds = CGRect(x: 0, y: 0, width: width, height: height)
        }
    }
    
    override func updateViewConstraints() {
        NSLayoutConstraint.activate(staticConstraints())
        super.updateViewConstraints()
    }
    
    private func staticConstraints() -> [NSLayoutConstraint] {
        return [
            topView.topAnchor.constraint(equalTo: view.topAnchor),
            topView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6),
            
            bottomStackView.topAnchor.constraint(equalTo: topView.bottomAnchor),
            bottomStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            animationView.centerXAnchor.constraint(equalTo: topView.centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: topView.centerYAnchor),
            animationView.heightAnchor.constraint(equalTo: topView.heightAnchor, multiplier: 0.8),
            animationView.widthAnchor.constraint(equalTo: topView.widthAnchor, multiplier: 0.8),
            
            buttonHorizontalSpacers.leading.widthAnchor.constraint(equalTo: buttonHorizontalSpacers.trailing.widthAnchor),
            textFieldHorizontalSpacers.leading.widthAnchor.constraint(equalTo: textFieldHorizontalSpacers.trailing.widthAnchor),
            
            textField.widthAnchor.constraint(equalTo: bottomStackView.widthAnchor, multiplier: 0.6),
            doneButton.widthAnchor.constraint(equalTo: bottomStackView.widthAnchor, multiplier: 0.6),
            
            textField.heightAnchor.constraint(equalToConstant: 40),
            doneButton.heightAnchor.constraint(equalToConstant: 40)
        ]
    }
    
    private func render() {
        view.backgroundColor = .primaryColor
        textField.placeholder = "Enter User Name"
        doneButton.setTitleColor(.secondaryColor, for: .normal)
        doneButton.setTitle("Repo List", for: .normal)
        doneButton.backgroundColor =  .buttonNormalColor
        animationView.animationSpeed = 0.5
        doneButton.layer.cornerRadius = 8
        textField.layer.cornerRadius = 8
        animationView.loopMode = .loop
        animationView.play()
    }
    
    @objc
    private func doneButtonPressed() {
        guard let userName = textField.text else {
            return
        }
        let repoListViewModel = RepoListViewModelImp(userName: userName)
        let repoListViewController = RepoListViewController(viewModel: repoListViewModel)
        repoListViewModel.delegate = repoListViewController
        navigationController?.pushViewController(repoListViewController, animated: true)
    }
}


extension UserNameInputViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        doneButtonPressed()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

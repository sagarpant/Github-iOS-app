//
//  LoginOptionsViewController1.swift
//  GithubProfile
//
//  Created by Sagar Pant on 02/08/22.
//

import UIKit

class LoginOptionsViewController1: UIViewController {

    @IBOutlet weak var oAuthButton: UIButton!
    @IBOutlet weak var nameRepoButton: UIButton!
    @IBOutlet weak var gitHubImageView: UIImageView!
    private let string: String
    init(string: String) {
        self.string = string
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .primaryColor
        gitHubImageView.image = UIImage(named: "github1")?.withTintColor(.secondaryColor, renderingMode: .alwaysOriginal)
        oAuthButton.setTitleColor(.secondaryColor, for: .normal)
        oAuthButton.layer.cornerRadius = 8
        // Do any additional setup after loading the view.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

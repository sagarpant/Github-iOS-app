//
//  ClosedPullRequestViewCell.swift
//  GithubProfile
//
//  Created by Sagar Pant on 07/08/22.
//

import UIKit
import Kingfisher

class ClosedPullRequestViewCell: UITableViewCell {

    static let closedPullRequestViewCellIdentifier = "closedPullRequestViewCellIdentifier"
    
    //MARK: User Image
    private lazy var userImage: UIImageView = {
        let userImageView = UIImageView.withAutoLayout()
        userImageView.clipsToBounds = true
        return userImageView
    }()
    
    private lazy var userNameLabel: UILabel = {
        let userNameLabel = UILabel.withAutoLayout()
        userNameLabel.numberOfLines = 0
        userNameLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        userNameLabel.adjustsFontForContentSizeCategory = true
        return userNameLabel
    }()
    
    private lazy var userInfoStackView: UIStackView = {
        let userInfoStackView = UIStackView(arrangedSubviews: [userImage,
                                                                userNameLabel])
        userInfoStackView.layoutMargins = UIEdgeInsets(top: 16, left: 8, bottom: 0, right: 8)
        userInfoStackView.translatesAutoresizingMaskIntoConstraints = false
        userInfoStackView.isLayoutMarginsRelativeArrangement = true
        userInfoStackView.spacing = 16
        return userInfoStackView
    }()
    
    //MARK: Pull Request Info
    private lazy var pullRequestTitle: UILabel = {
        let pullRequestTitle = UILabel.withAutoLayout()
        pullRequestTitle.numberOfLines = 0
        return pullRequestTitle
    }()
    
    private lazy var pullRequestCreatedDate: UILabel = {
        let pullRequestTitle = UILabel.withAutoLayout()
        pullRequestTitle.numberOfLines = 1
        return pullRequestTitle
    }()
    
    private lazy var pullRequestClosedDate: UILabel = {
        let pullRequestTitle = UILabel.withAutoLayout()
        pullRequestTitle.numberOfLines = 1
        return pullRequestTitle
    }()
    
    private lazy var pullRequestInfoStackView: UIStackView = {
        let pullRequestInfoStackView = UIStackView(arrangedSubviews: [pullRequestTitle, pullRequestCreatedDate, pullRequestClosedDate])
        pullRequestInfoStackView.translatesAutoresizingMaskIntoConstraints = false
        pullRequestInfoStackView.spacing = 16
        pullRequestInfoStackView.layoutMargins = UIEdgeInsets(top: 16, left: 8, bottom: 16, right: 8)
        pullRequestInfoStackView.isLayoutMarginsRelativeArrangement = true
        pullRequestInfoStackView.axis = .vertical
        return pullRequestInfoStackView
    }()
    
    //MARK: Main Stack
    private lazy var mainStackView: UIStackView = {
       let mainStackView = UIStackView(arrangedSubviews: [userInfoStackView,
                                                          pullRequestInfoStackView
                                                         ])
        mainStackView.axis = .vertical
        mainStackView.layoutMargins = UIEdgeInsets(top: 16, left: 8, bottom: 16, right: 8)
        mainStackView.isLayoutMarginsRelativeArrangement = true
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        return mainStackView
    }()
    
    
    // MARK: Init
    init() {
        super.init(style: .default, reuseIdentifier: ClosedPullRequestViewCell.closedPullRequestViewCellIdentifier)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    private func commonInit() {
        contentView.addSubview(mainStackView)
        setNeedsUpdateConstraints()
        render()
    }
    
    
    // MARK: Constraints
    override func updateConstraints() {
        NSLayoutConstraint.activate(staticConstraints())
        super.updateConstraints()
    }
    
    private func staticConstraints() -> [NSLayoutConstraint] {
        return [
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            userImage.heightAnchor.constraint(equalToConstant: 80),
            userImage.widthAnchor.constraint(equalToConstant: 80),
            pullRequestClosedDate.heightAnchor.constraint(equalToConstant: UIFont.dateFonts.pointSize * CGFloat(pullRequestClosedDate.numberOfLines)),
            pullRequestCreatedDate.heightAnchor.constraint(equalToConstant: UIFont.dateFonts.pointSize * CGFloat(pullRequestClosedDate.numberOfLines))
        ]
    }
    
    
    // MARK: Render
    private func render() {
        
        guard let viewData = viewData else {
            return
        }
        let pullRequestTitleString = NSMutableAttributedString(string: "Title: ", attributes: [.font: UIFont.titleFont])
        
        let pullRequestTitleStringValue = NSAttributedString(string: viewData.pullRequestTitle, attributes: [.font: UIFont.dateValueFont])
        pullRequestTitleString.append(pullRequestTitleStringValue)
        pullRequestTitle.attributedText = pullRequestTitleString
        
        let createdAt = NSMutableAttributedString(string: "Created at: ", attributes: [.font: UIFont.dateFonts])
        let createdAtString = NSAttributedString(string: viewData.createdDate ?? "", attributes: [.font: UIFont.dateValueFont])
        createdAt.append(createdAtString)
        pullRequestCreatedDate.attributedText = createdAt
        
        let closedAt = NSMutableAttributedString(string: "Closed at: ", attributes: [.font: UIFont.dateFonts])
        let closedAtValue = NSAttributedString(string: viewData.closedDate ??
                                               "", attributes: [.font: UIFont.dateValueFont])
        closedAt.append(closedAtValue)
        pullRequestClosedDate.attributedText = closedAt
        
        userImage.kf.setImage(with: .network(ImageResource(downloadURL: viewData.userImageUrl)))
        userNameLabel.text = viewData.userName
        userImage.layer.cornerRadius = 40
        userInfoStackView.backgroundColor = .colorOnPrimary
        pullRequestInfoStackView.backgroundColor = .colorOnPrimary
        
        pullRequestInfoStackView.layer.cornerRadius = 8
        pullRequestInfoStackView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        userInfoStackView.layer.cornerRadius = 8
        userInfoStackView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    // MARK: ViewData
    struct ViewData {
        let userName: String
        let userImageUrl: URL
        let pullRequestTitle: String
        let createdDate: String?
        let closedDate: String?
    }
    
    var viewData: ViewData? {
        didSet {
            render()
        }
    }
}


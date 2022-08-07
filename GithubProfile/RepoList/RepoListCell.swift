//
//  RepoListCell.swift
//  GithubProfile
//
//  Created by Sagar Pant on 07/08/22.
//

import UIKit

class RepoListCell: UITableViewCell {

    public static let repoListIdentifier = "repoListIdentifier"
    private lazy var label: UILabel = {
        let label = UILabel.withAutoLayout()
        label.font = .headline
        return label
    }()
    
    private lazy var mainStackView: UIStackView = {
        let mainStackView = UIStackView(arrangedSubviews: [label])
        mainStackView.axis = .vertical
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        mainStackView.isLayoutMarginsRelativeArrangement = true
        return mainStackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        contentView.addSubview(mainStackView)
        setNeedsUpdateConstraints()
    }
    
    override func updateConstraints() {
        NSLayoutConstraint.activate(staticConstraints())
        super.updateConstraints()
    }
    
    private func staticConstraints() -> [NSLayoutConstraint] {
        return [
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ]
    }
    
    struct ViewData {
        let repoName: String
    }
    
    var viewData: ViewData? {
        didSet {
            render()
        }
    }
    
    private func render() {
        label.text = viewData?.repoName
    }
}

//
//  SectionTitleView.swift
//  YouTubeClone
//
//  Created by Victor Roldan on 14/03/22.
//

import UIKit

class SectionTitleView: UITableViewHeaderFooterView {
    let title : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var customView : UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configView() {
        contentView.addSubview(customView)
        
        NSLayoutConstraint.activate([
            customView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            customView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            customView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            customView.heightAnchor.constraint(equalToConstant: 40.0),
        ])
        
        customView.addSubview(title)
        title.font = .systemFont(ofSize: 13.0)
        title.textColor = .whiteColor
        
        NSLayoutConstraint.activate([
            title.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 13.0),
            title.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 13.0),
            title.topAnchor.constraint(equalTo: customView.topAnchor, constant: 0.0)
        ])
    }
    
    
}

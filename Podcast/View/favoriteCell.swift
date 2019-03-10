//
//  favoriteCell.swift
//  Podcast
//
//  Created by prog on 3/10/19.
//  Copyright © 2019 prog. All rights reserved.
//

import UIKit

class favoriteCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
        backgroundColor = .yellow
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let imageView:UIImageView = {
        let image = UIImageView(image: #imageLiteral(resourceName: "appicon"))
        return image
        
    }()
    
    let namelabel:UILabel = {
        let nameLabel = UILabel()
        nameLabel.text = "Podcast Name"
        nameLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return nameLabel
    }()
    
    let artistLabel:UILabel = {
        let artistNameLabel = UILabel()
        artistNameLabel.text = "Artist Name"
        artistNameLabel.font = UIFont.systemFont(ofSize: 14)
        artistNameLabel.textColor = .lightGray
        return artistNameLabel
    }()
    
    func setUpView(){
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
        let stackView = UIStackView(arrangedSubviews: [imageView,namelabel,artistLabel])
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
    
}

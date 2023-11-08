//
//  CharacterCollectionViewCell.swift
//  anotherRM
//
//  Created by Onur on 1.09.2023.
//

import Foundation
import UIKit
import SnapKit

class CharacterCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "CharacterCollectionViewCell"
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    private func setupViews() {
        addSubview(imageView)
        addSubview(nameLabel)
        
        imageView.snp.makeConstraints{ (make) in
            make.top.equalToSuperview().offset(15)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalTo(nameLabel.snp.top).offset(-10)
            
        }
        
        nameLabel.snp.makeConstraints(){(make) in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            
        }
        
    }

    func configure(with character: Character) {
        nameLabel.text = character.name
        if let imageUrl = URL(string: character.image) {
            imageView.loadImage(url: imageUrl)
        }
    }
}

//
//  FileCollectionViewCell.swift
//  DropboxTest
//
//  Created by Alexander Sokolenko on 29.08.2023.
//

import UIKit

final class FileCollectionViewCell: UICollectionViewCell {
    
    var title : String? {
        didSet {
            self.titleView.text = title
        }
    }
    var image : UIImage? {
        didSet {
            imageView.image = image
        }
    }
    private let titleView = UILabel()
    private let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        titleView.translatesAutoresizingMaskIntoConstraints = false
        titleView.lineBreakMode = .byTruncatingTail
        titleView.textAlignment = .center
        self.contentView.addSubview(imageView)
        self.contentView.addSubview(titleView)
        let textPadding : CGFloat = 3
        NSLayoutConstraint.activate([
            imageView.leftAnchor.constraint(equalTo: self.leftAnchor),
            imageView.rightAnchor.constraint(equalTo: self.rightAnchor),
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            titleView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: textPadding),
            titleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -textPadding),
            titleView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            imageView.bottomAnchor.constraint(equalTo: titleView.topAnchor, constant: -10)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.image = nil
        self.title = nil
    }
    
}

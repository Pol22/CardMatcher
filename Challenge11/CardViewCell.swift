//
//  CardViewCell.swift
//  Challenge11
//
//  Created by Pavel Ilyutchenko on 13.12.2021.
//

import UIKit

class CardViewCell: UICollectionViewCell {
    
    static let identifier = "CardViewCell"
    
    private let imageView = UIImageView()
    public var name: String?
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 15.0
        contentView.layer.borderWidth = 3.0
        contentView.layer.borderColor = UIColor.gray.cgColor
        contentView.layer.masksToBounds = true
        contentView.addSubview(imageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setImage(_ imageName: String) {
        name = imageName
        imageView.image = UIImage(systemName: imageName)
        imageView.isHidden = true
    }
    
    func flip() {
        let flipSide: UIView.AnimationOptions = imageView.isHidden ? .transitionFlipFromLeft : .transitionFlipFromRight
        UIView.transition(with: self.contentView, duration: 0.5, options: flipSide, animations: { [weak self]  () -> Void in
            self?.imageView.isHidden = !(self?.imageView.isHidden ?? true)
        }, completion: nil)
    }
    
    func hide() {
        UIView.animate(withDuration: 0.5, animations: {
            self.alpha = 0.0
        })
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.frame = CGRect(x: 5, y: 5, width: contentView.frame.size.width - 10, height: contentView.frame.size.height - 10)
    }
}

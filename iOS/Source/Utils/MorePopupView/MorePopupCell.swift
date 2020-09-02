//
//  MorePopupCell.swift
//  Kawagarbo
//
//  Created by 一鸿温 on 8/31/20.
//  Copyright © 2020 Moirig. All rights reserved.
//

import UIKit

class MorePopupCell: UICollectionViewCell {
    
    var image: UIImage? {
        set {
            imageView.image = newValue
        }
        get {
            return imageView.image
        }
    }
    
    var text: String {
        set {
            var frame = textLabel.frame
            frame.size.height = newValue.count > 6 ? 22 : 11
            textLabel.frame = frame
            textLabel.text = newValue
        }
        get {
            return textLabel.text ?? ""
        }
    }
    
    private lazy var imageBackground: UIView = {
        let imageBackground: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        imageBackground.center = CGPoint(x: contentView.center.x + 8, y: contentView.center.y - 12)
        imageBackground.backgroundColor = .white
        imageBackground.layer.cornerRadius = 10
        
        return imageBackground
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView: UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 28, height: 28))
        imageView.center = CGPoint(x: 25, y: 25)
        
        return imageView
    }()
    
    private lazy var textLabel: UILabel = {
        let textLabel: UILabel = UILabel(frame: CGRect(x: imageBackground.frame.minX - 2, y: imageBackground.frame.maxY + 8, width: 56, height: 22))
        textLabel.textAlignment = .center
        textLabel.numberOfLines = 2
        textLabel.font = UIFont.systemFont(ofSize: 9.0)
        textLabel.textColor = UIColor(white: 0.4, alpha: 1)

        return textLabel
    }()
    
    override var isHighlighted: Bool {
        set {
            super.isHighlighted = newValue
            imageBackground.backgroundColor = newValue ? UIColor(white: 0.92, alpha: 1) : .white
        }
        get { return super.isHighlighted }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension MorePopupCell {
    
    func setUI() {
        contentView.addSubview(imageBackground)
        imageBackground.addSubview(imageView)
        contentView.addSubview(textLabel)
    }
    
}

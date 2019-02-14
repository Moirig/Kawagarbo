//
//  KGTitleView.swift
//  Kawagarbo_iOS
//
//  Created by 温一鸿 on 2019/2/14.
//

import UIKit

class KGTitleView: UIView {
    
    var title: String {
        get {
            return titleLabel.text ?? ""
        }
        set {
            titleLabel.text = newValue
            setNeedsLayout()
        }
    }
    
    var isShowLoading: Bool {
        get {
            return activityIndicator.isAnimating
        }
        set {
            newValue ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
        }
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.lineBreakMode = .byTruncatingTail
        label.font = UIFont.boldSystemFont(ofSize: 17.0)
        label.frame = bounds
        return label
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let juhua = UIActivityIndicatorView(style: .gray)
        juhua.hidesWhenStopped = true
        return juhua
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI() {
        addSubview(titleLabel)
        addSubview(activityIndicator)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.kg.fitWidth()
        titleLabel.center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        
        activityIndicator.center = CGPoint(x: titleLabel.frame.minX - 15, y: bounds.height / 2)
    }
    
}


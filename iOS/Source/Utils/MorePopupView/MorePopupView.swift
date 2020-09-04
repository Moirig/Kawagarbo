//
//  MorePopupView.swift
//  Kawagarbo
//
//  Created by 一鸿温 on 8/31/20.
//  Copyright © 2020 Moirig. All rights reserved.
//

import UIKit

private let ScreenWidth: CGFloat = UIScreen.main.bounds.width
private let ScreenHeight: CGFloat = UIScreen.main.bounds.height
private let H_Margin: CGFloat = 16.0
private let ShareViewColor = UIColor(white: 0.96, alpha: 1)

class MorePopupView: UIView, UIGestureRecognizerDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    private var isShow: Bool = false
    
    private lazy var backgroundView: UIView = {
        let backgroundView = UIView(frame: bounds)
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(backgroundViewTap(gesture:)))
        gesture.delegate = self
        backgroundView.addGestureRecognizer(gesture)
        
        return backgroundView
    }()
    
    private lazy var shareView: UIView = {
        let shareView = UIView(frame: .zero)
        shareView.backgroundColor = ShareViewColor
        shareView.layer.cornerRadius = 12.0
        
        return shareView
    }()
    
    private lazy var titleView: UIView = {
        let titleView = UIView(frame: .zero)
        
        return titleView
    }()
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel(frame: .zero)
        titleLabel.font = UIFont.systemFont(ofSize: 13.0)
        titleLabel.textColor = UIColor(white: 0.2, alpha: 1)
        titleLabel.text = NSLocalizedString("More")
        
        return titleLabel
    }()
    
    private lazy var horzLine0: UIView = {
        let horzLine0 = UIView(frame: .zero)
        horzLine0.backgroundColor = UIColor(white: 0.88, alpha: 1)
        
        return horzLine0
    }()
    
    private lazy var collectionView0: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0
        flowLayout.itemSize = CGSize(width: 66, height: 116)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = ShareViewColor
        collectionView.alwaysBounceHorizontal = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(MorePopupCell.self, forCellWithReuseIdentifier: String(describing: MorePopupCell.self))
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.tag = MorePopupItemType.share.rawValue
        
        return collectionView
    }()
    
    private lazy var horzLine1: UIView = {
        let horzLine1 = UIView(frame: .zero)
        horzLine1.backgroundColor = UIColor(white: 0.88, alpha: 1)
        
        return horzLine1
    }()
    
    private lazy var collectionView1: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0
        flowLayout.itemSize = CGSize(width: 66, height: 116)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = ShareViewColor
        collectionView.alwaysBounceHorizontal = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(MorePopupCell.self, forCellWithReuseIdentifier: String(describing: MorePopupCell.self))
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.tag = MorePopupItemType.default.rawValue
        
        return collectionView
    }()
    
    private lazy var cancelButton: UIButton = {
        let cancelButton = UIButton(type: .system)
        cancelButton.backgroundColor = .white
        cancelButton.tintColor = UIColor(white: 0.2, alpha: 1)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 17.0)
        cancelButton.setTitle(NSLocalizedString("Cancel"), for: .normal)
        if #available(iOS 11.0, *) {
            if let safeAreaInsets = UIApplication.shared.windows.first?.safeAreaInsets, safeAreaInsets.bottom > 0 {
                cancelButton.titleEdgeInsets = UIEdgeInsets(top: -16, left: 0, bottom: 0, right: 0)
            }
        }
        cancelButton.addTarget(self, action: #selector(cancelButtonAction(button:)), for: .touchUpInside)
        
        return cancelButton
    }()
    
    private static var shareItems: [MorePopupItem.Type] = []
    private static var defaultItems: [MorePopupItem.Type] = []

    var info: MorePopupItemInfo = MorePopupItemInfo()
    
    var selected: ((MorePopupItemRes, MorePopupItem.Type) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
}

extension MorePopupView {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == MorePopupItemType.share.rawValue {
            return type(of: self).shareItems.count
        }
        else if collectionView.tag == MorePopupItemType.default.rawValue {
            return type(of: self).defaultItems.count
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: MorePopupCell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: MorePopupCell.self), for: indexPath) as! MorePopupCell
        if collectionView.tag == MorePopupItemType.share.rawValue {
            cell.image = type(of: self).shareItems[indexPath.row].image
            cell.text = type(of: self).shareItems[indexPath.row].text
        }
        else if collectionView.tag == MorePopupItemType.default.rawValue {
            cell.image = type(of: self).defaultItems[indexPath.row].image
            cell.text = type(of: self).defaultItems[indexPath.row].text
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == MorePopupItemType.share.rawValue {
            let item: MorePopupItem.Type = type(of: self).shareItems[indexPath.row]
            item.selected(info: info) { (res) in
                if let cb = self.selected {
                    cb(res, item)
                }
            }
        }
        else if collectionView.tag == MorePopupItemType.default.rawValue {
            let item: MorePopupItem.Type = type(of: self).defaultItems[indexPath.row]
            item.selected(info: info) { (res) in
                if let cb = self.selected {
                    cb(res, item)
                }
            }
        }
        
        hide()
    }
    
}

extension MorePopupView {
    
    static func addItem(item: MorePopupItem.Type) {
        switch item.type {
        case .share:
            shareItems.append(item)
        case .default:
            defaultItems.append(item)
        }
    }
    
    static func removeItem(item: MorePopupItem.Type) {
        switch item.type {
        case .share:
            var idx: Int = 0
            for (aitem) in shareItems {
                if item == aitem {
                    break;
                }
                idx += 1
            }
            shareItems.remove(at: idx)
            
        case .default:
            var idx: Int = 0
            for (aitem) in defaultItems {
                if item == aitem {
                    break;
                }
                idx += 1
            }
            shareItems.remove(at: idx)
        }
    }
    
    var shareViewTitle: String? {
        set {
            titleLabel.text = newValue
        }
        get {
            return titleLabel.text
        }
    }
    
    func show() {
        guard !isShow else { return }
        isShow = true
        
        if let window = UIApplication.shared.windows.first {
            window.addSubview(self)
        }
        backgroundView.alpha = 0
        UIView.animate(withDuration: 0.3) {
            self.backgroundView.alpha = 1
            self.shareView.frame = CGRect(x: 0, y: ScreenHeight - self.shareView.frame.height, width: self.shareView.frame.width, height: self.shareView.frame.height)
        }
    }

    private func hide() {
        guard isShow else { return }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.shareView.frame = CGRect(x: 0, y: ScreenHeight, width: self.shareView.frame.width, height: self.shareView.frame.height)
            self.backgroundView.alpha = 0
        }) { (complete) in
            if complete {
                self.removeFromSuperview()
                self.isShow = false
            }
        }
    }
    
}

extension MorePopupView {
    
    private func setUI() {
        addSubview(backgroundView)
        backgroundView.addSubview(shareView)
        shareView.addSubview(titleView)
        titleView.addSubview(titleLabel)
        shareView.addSubview(horzLine0)
        shareView.addSubview(collectionView0)
        shareView.addSubview(horzLine1)
        shareView.addSubview(collectionView1)
        shareView.addSubview(cancelButton)
        
        var curY: CGFloat = 0
        titleView.frame = CGRect(x: 0, y: curY, width: ScreenWidth, height: 50)
        titleLabel.frame = CGRect(x: H_Margin, y: curY, width: ScreenWidth - 2 * H_Margin, height: 50)
        curY += 50
        horzLine0.frame = CGRect(x: H_Margin, y: curY, width: ScreenWidth - H_Margin, height: 0.5)
        curY += 0.5
        collectionView0.frame = CGRect(x: 0, y: curY, width: ScreenWidth, height: 116)
        curY += 116
        horzLine1.frame = CGRect(x: H_Margin, y: curY, width: ScreenWidth - H_Margin, height: 0.5)
        curY += 0.5
        collectionView1.frame = CGRect(x: 0, y: curY, width: ScreenWidth, height: 116)
        curY += 116
        var cancelButtonHeight: CGFloat = 50.0
        if #available(iOS 11.0, *) {
            if let safeAreaInsets = UIApplication.shared.windows.first?.safeAreaInsets, safeAreaInsets.bottom > 0 {
                cancelButtonHeight += safeAreaInsets.bottom
            }
        }
        cancelButton.frame = CGRect(x: 0, y: curY, width: ScreenWidth, height: cancelButtonHeight)
        curY += cancelButtonHeight
        let shareViewHeight: CGFloat = curY
        shareView.frame = CGRect(x: 0, y: ScreenHeight, width: ScreenWidth, height: shareViewHeight)
    }
    
    @objc func backgroundViewTap(gesture: UIGestureRecognizer) {
        if gesture.state == .ended {
            hide()
        }
    }
    
    @objc func cancelButtonAction(button: UIButton) {
        hide()
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let point = gestureRecognizer.location(in: self)
        if shareView.frame.contains(point) {
            return false
        }
        return true
    }
    
}

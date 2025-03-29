//
//  HorizontalPullLoadView.swift
//  KRPullLoaderDemo
//
//  Copyright © 2017年 Krimpedance. All rights reserved.
//

import UIKit
import KRPullLoader

class HorizontalPullLoadView: UIView {

    public let activityIndicator = UIActivityIndicatorView()
    static var pullRequest : (()->Void)?
    static var pageRequest : (()->Void)?
    var shouldSetConstraints = true

    open override func layoutSubviews() {
        super.layoutSubviews()
        if shouldSetConstraints { setUp() }
        shouldSetConstraints = false
    }
}

// MARK: - Actions -------------------

extension HorizontalPullLoadView {
    func setUp() {
        backgroundColor = .clear

        activityIndicator.style = .gray
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(activityIndicator)

        addConstraints([
            NSLayoutConstraint(item: activityIndicator, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 15.0),
            NSLayoutConstraint(item: activityIndicator, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0.0)
            ])

        addConstraint(
            NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: 50)
        )
    }
}

// MARK: - KRPullLoadable actions -------------------

extension HorizontalPullLoadView: KRPullLoadable {
    
    func didChangeState(_ state: KRPullLoaderState, viewType type: KRPullLoaderType) {
        switch state {
        case .none:
            activityIndicator.stopAnimating()

        case .pulling:
            //activityIndicator.startAnimating()
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1) {
                HorizontalPullLoadView.pullRequest?()
                if let collectionView = self.superview?.superview as? UICollectionView {
                    collectionView.reloadData()
                }
            }

        case let .loading(completionHandler):
            activityIndicator.startAnimating()
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1) {
                completionHandler()
                HorizontalPullLoadView.pageRequest?()
                if let collectionView = self.superview?.superview as? UICollectionView {
                    collectionView.reloadData()
                }
            }
        }
    }
}

//
//  ReactiveExtension.swift
//  TrailerPlayer
//
//  Created by Ana Finotti on 31/01/21.
//
import UIKit

import RxSwift
import RxCocoa
import Foundation


extension Reactive where Base: UIActivityIndicatorView {

/// Bindable sink for `startAnimating()`, `stopAnimating()` methods.
public var isAnimating: Binder<Bool> {
    
    return Binder(self.base) { activityIndicator, active in
        if active {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
}}

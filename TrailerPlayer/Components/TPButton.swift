//
//  TPButton.swift
//  TrailerPlayer
//
//  Created by Ana Finotti on 29/01/21.
//

import UIKit

@IBDesignable open class TPButton: UIButton {
    
    @IBInspectable public var spinnerColor: UIColor = UIColor.clear { didSet { self.setupIndicator() } }
    
    private var indicator: UIActivityIndicatorView?
    private var textForIndicator: String?
    
    public override init(frame: CGRect) {
        
        super.init(frame: frame)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
    }
    
    func setupIndicator() {
        
        self.indicator?.removeFromSuperview()
        
        let indicator = UIActivityIndicatorView()
        indicator.isHidden = true
        indicator.color = self.spinnerColor
        self.addSubview(indicator)
        
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        indicator.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        self.indicator = indicator
    }
    
    public func startLoading() {
        
        self.textForIndicator = self.title(for: .normal)
        self.setTitle("", for: .normal)
        
        self.indicator?.isHidden = false
        self.indicator?.startAnimating()
        self.isUserInteractionEnabled = false
    }
    
    public func stopLoading() {
        
        if self.indicator?.isAnimating != true { return }
        
        self.setTitle(self.textForIndicator, for: .normal)
        
        self.indicator?.stopAnimating()
        self.indicator?.isHidden = true
        self.isUserInteractionEnabled = true
    }
}

//
//  TPHeaderCollectionReusableView.swift
//  TrailerPlayer
//
//  Created by Ana Finotti on 27/01/21.
//

import UIKit

class TPHeaderCollectionReusableView: UICollectionReusableView {
        
    //MARK: - Outlets
    @IBOutlet weak var labelTitle: UILabel!
    
    //MARK: - Properties
    var title: String? {
        
        didSet {
            
            labelTitle.text = title
        }
    }
}

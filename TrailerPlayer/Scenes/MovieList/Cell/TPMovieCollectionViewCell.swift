//
//  TPMovieCollectionViewCell.swift
//  TrailerPlayer
//
//  Created by Ana Finotti on 27/01/21.
//

import UIKit
import SDWebImage

class TPMovieCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Outlets
    @IBOutlet weak var imageViewArtwork: UIImageView!
    
    //MARK: - Properties
    var movie: Movie? {
        
        didSet {
            
            if let artwork = movie?.images?.artwork {
                
                imageViewArtwork.sd_setImage(with: URL(string: artwork), placeholderImage: UIImage(named: "refresh"))
            }
        }
    }
    
    //MARK: - Lifecycle
    
    //MARK: - Layout
    //MARK: - Actions
    //MARK: - Delegates
}

//
//  TPMovieDetailsAdapter.swift
//  TrailerPlayer
//
//  Created by Ana Finotti on 27/01/21.
//

import UIKit
import AVFoundation

class TPMovieDetailsAdapter: NSObject {

    //MARK: Properties
    let delegate: TPMovieDetailsProtocol

    //MARK: Constructor
    init(delegate: TPMovieDetailsProtocol) {
        
        self.delegate = delegate
    }
}

//
//  TPMovieDetailsViewController.swift
//  TrailerPlayer
//
//  Created by Ana Finotti on 27/01/21.
//

import UIKit
import AVKit
import SDWebImage
import AVFoundation

class TPMovieDetailsViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var imageViewSnapshot: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelPlot: UILabel!
    @IBOutlet weak var labelYear: UILabel!
        
    @IBOutlet weak var buttonPlay: TPButton!
    
    //MARK: - Properties
    var movie: Movie?
    
    var playerViewController = AVPlayerViewController()
    var player: AVPlayer!
    
    lazy var viewModel: TPMovieDetailsViewModel = {
        
        return TPMovieDetailsViewModel()
    }()
    
    var adapter: TPMovieListAdapter!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.title = movie?.title
        
        if let snapshot = movie?.images?.snapshot {
            
            imageViewSnapshot.sd_setImage(with: URL(string: snapshot), placeholderImage: UIImage(named: "refresh"))
        }
        
        if let title = movie?.title { labelTitle.text = title }
        
        self.setupViewModel()
    }
    
    //MARK: - Layout
    func setupView(movie: MovieDetail) {
        
        buttonPlay.isEnabled = true
        
        if let shortPlot = movie.shortPlot { labelPlot.text = shortPlot }
    }
    
    func playTrailer(stream: Stream) {
        
        guard let trailerUrl = stream.streamInfo?.first?.url else { fatalError("No trailer found.") }
        
        if let url = URL(string: trailerUrl) {
            
            buttonPlay.isEnabled = true
            
            player = AVPlayer(url: url)
            playerViewController.player = player
            player.play()
            
            self.present(playerViewController, animated: true, completion: nil)
        }
    }
    
    func setupViewModel() {
        
        viewModel.reloadViewClosure = { [weak self] () in
            
            DispatchQueue.main.async {
                
                self?.setupView(movie: (self?.viewModel.movie)!)
            }
        }
        
        viewModel.playVideoClosure = { [weak self] () in
            
            DispatchQueue.main.async {
                
                self?.buttonPlay.stopLoading()
                
                self?.playTrailer(stream: (self?.viewModel.stream)!)
            }
        }
        
        viewModel.fetchMovieDetails(movieId: movie?.id ?? "", classificationId: 6, marketCode: "es", locale: "es")
    }
    
    //MARK: - Actions
    @IBAction func didTapPlayTrailerButton(_ sender: Any) {
        
        buttonPlay.startLoading()
        
        viewModel.fetchMovieStreamings(movieDetail: viewModel.movie, classificationId: 6, marketCode: "es", locale: "es")
    }
}

extension TPMovieDetailsViewController: TPMovieDetailsProtocol {
    
    func getMovie() -> MovieDetail {
        
        return viewModel.movie
    }
    
    func getStream() -> Stream {
        
        return viewModel.stream
    }
}

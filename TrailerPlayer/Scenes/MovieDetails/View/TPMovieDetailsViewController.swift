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
import RxSwift
import RxCocoa

class TPMovieDetailsViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var imageViewSnapshot: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelPlot: UILabel!
    @IBOutlet weak var labelYear: UILabel!
    
    @IBOutlet weak var buttonPlay: TPButton!
    
    //MARK: - Properties
    let disposeBag = DisposeBag()
    
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
        
        setupViewModel()
    }
    
    //MARK: - Layout
    func setupView(movieDetail: MovieDetail) {
        
        buttonPlay.isEnabled = true
        
        if let shortPlot = movieDetail.shortPlot { labelPlot.text = shortPlot }
    }
    
    func playTrailer(stream: Stream) {
        
        buttonPlay.stopLoading()
        
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
        
        viewModel.fetchMovieDetails(movieId: movie?.id ?? "",
                                    classificationId: 6,
                                    marketCode: "es",
                                    locale: "es")
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { response in
                
                self.setupView(movieDetail: response)
                
            }, onError: { error in
                
                switch error {
                
                case ApiError.conflict:
                    print("Conflict error")
                case ApiError.forbidden:
                    print("Forbidden error")
                case ApiError.notFound:
                    print("Not found error")
                default:
                    print("Unknown error:", error)
                }
            })
            .disposed(by: disposeBag)
    }
    
    //MARK: - Actions
    @IBAction func didTapPlayTrailerButton(_ sender: Any) {
        
        buttonPlay.startLoading()
        
        viewModel.fetchMovieStreamings(movieDetail: viewModel.movieDetail,
                                       classificationId: 6,
                                       marketCode: "es",
                                       locale: "es")
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { response in
                
                self.playTrailer(stream: response)
                
            }, onError: { error in
                
                self.buttonPlay.stopLoading()

                switch error {
                
                case ApiError.conflict:
                    print("Conflict error")
                case ApiError.forbidden:
                    print("Forbidden error")
                case ApiError.notFound:
                    print("Not found error")
                default:
                    print("Unknown error:", error)
                }
            })
            .disposed(by: disposeBag)
    }
}

extension TPMovieDetailsViewController: TPMovieDetailsProtocol {
    
    func getMovie() -> MovieDetail {
        
        return viewModel.movieDetail
    }
    
    func getStream() -> Stream {
        
        return viewModel.stream
    }
}

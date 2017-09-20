//
//  DetailViewController.swift
//  ios-moviedb
//
//  Created by Nguyen, Kim on 9/19/17.
//  Copyright © 2017 knguyen1. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var infoView: UIView!
    
    var movie: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // width is the size of the frame
        // height is provisioned by how much height we see on the infoView
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: infoView.frame.origin.y + infoView.frame.size.height)
        
        let title = movie["title"] as? String
        let overview = movie["overview"] as? String
        titleLabel.text = title
        overviewLabel.text = overview
        
        // resize the overview label to fit - generally obsolete compared to autolayout :)
        overviewLabel.sizeToFit()
        
        if let posterPath = movie?["poster_path"] as? String {
            let imageBaseUrl = "https://image.tmdb.org/t/p/w500/"
            let imageUrl = URL(string: imageBaseUrl + posterPath)
            posterImageView.setImageWith(imageUrl!)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

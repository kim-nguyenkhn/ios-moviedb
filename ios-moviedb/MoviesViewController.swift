//
//  MoviesViewController.swift
//  ios-moviedb
//
//  Created by Nguyen, Kim on 9/19/17.
//  Copyright © 2017 knguyen1. All rights reserved.
//

import UIKit
import AFNetworking

// added protocols: UITableViewDataSource & UITableViewDelegate
class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    @IBOutlet weak var tableView: UITableView!

    var movies: [NSDictionary]?  // make this optional -- can be nil
    
    var endpoint: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set the table view dataSource & delegate
        tableView.dataSource = self
        tableView.delegate = self
        
        networkRequest()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // network request
    func networkRequest() {
        // Network Request
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(endpoint)?api_key=\(apiKey)")
        let request = URLRequest(url: url!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        let task : URLSessionDataTask = session.dataTask(
            with: request as URLRequest,
            completionHandler: { (data, response, error) in
                if let data = data {
                    if let responseDictionary = try! JSONSerialization.jsonObject(
                        with: data, options:[]) as? NSDictionary {
                        // print("responseDictionary: \(responseDictionary)")
                        
                        // in the moviesDB payload, we want to drill down to the "results" key
                        self.movies = responseDictionary["results"] as? [NSDictionary]
                        
                        // make sure to reload the tableView
                        self.tableView.reloadData()
                    }
                }
        });
        task.resume()
    }

    
    // numberOfRowsInSection -> how many cells that it has
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // check if movies is nil
        if let movies = movies {
            return movies.count
        } else {
            return 0
        }
    }
    
    // cellForRowAtIndexPath -> communicate & set contents of ea cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        
        // grab the movie corresponding to the row
        let movie = self.movies?[indexPath.row]
        let title = movie?["title"] as! String
        let overview = movie?["overview"] as! String
        cell.titleLabel.text = title
        cell.overviewLabel.text = overview
        
        if let posterPath = movie?["poster_path"] as? String {
            let imageBaseUrl = "https://image.tmdb.org/t/p/w500/"
            let imageUrl = URL(string: imageBaseUrl + posterPath)
            cell.posterView.setImageWith(imageUrl!)
        }
        
        return cell
    }
    
    // MARK: Navigation
    // sender is what initiates the navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UITableViewCell
        // we give a cell, and get the indexpath
        let indexPath = tableView.indexPath(for: cell)
        let movie = movies?[(indexPath!.row)]
        
        let detailViewController = segue.destination as! DetailViewController
        detailViewController.movie = movie
        
        print("prepare for segue called")
    }
    
}

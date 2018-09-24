//
//  movieViewController.swift
//  movie
//
//  Created by Qing Ran on 9/16/18.
//  Copyright © 2018 Qing Ran. All rights reserved.
//

import UIKit
import Foundation


extension movieViewController: UISearchResultsUpdating {
   
    func updateSearchResults(for searchController: UISearchController) {
       
        
    }
}

class movieViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    let searchController = UISearchController(searchResultsController: nil)

    var movieInformation: [NSDictionary]?
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieInformation?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
      //  tableView.rowHeight = UITableViewAutomaticDimension
      //  tableView.estimatedRowHeight = 400
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieDetail", for: indexPath) as! movieTableViewCell
        let movieInfoString = movieInformation![indexPath.row] as! NSDictionary
   //     print(movieInfoString)
        let movieReleaseDate = movieInfoString["release_date"] as! String
        let movieTitleString = movieInfoString["original_title"] as! String
        let movieDetailString = movieInfoString["overview"] as! String
        let movieVoteString = movieInfoString["vote_count"] as! Int
        let movieRating = movieInfoString["vote_average"] as! Double
       
        let movieVoteString2 = String(movieVoteString)
      //  print(movieVoteString2)
        cell.movieRate.text = String(movieRating)
        if (movieRating > 7.0) {
            cell.movieRate.backgroundColor = UIColor(red:0.73, green:0.00, blue:0.05, alpha:1.0)
        } else if (movieRating > 6.0) {
            cell.movieRate.backgroundColor = UIColor(red:0.96, green:0.26, blue:0.21, alpha:1.0)
        } else if (movieRating > 1.0) {
            cell.movieRate.backgroundColor = UIColor(red:1.00, green:0.47, blue:0.38, alpha:1.0)
        } else {
          //  cell.movieRate.backgroundColor = UIColor.gray
        }
        cell.movieRate.layer.masksToBounds = true
        cell.movieRate.layer.cornerRadius = 6
        
        
        cell.movieTitle.text = movieTitleString
        cell.movieDetail.text = movieDetailString
     //   print(movieVoteString)
        cell.movieRelease.text = "Released on: " + movieReleaseDate
        cell.movieVote.text = movieVoteString2 + " votes"
        let moviePosterString = movieInfoString["backdrop_path"] as! String
        let moviePosterURL = "https://image.tmdb.org/t/p/w185" + moviePosterString
    //    print(moviePosterURL)
        let url = URL(string: moviePosterURL)
        let data = try? Data(contentsOf: url!)
   
        
       // var imageFrame = UIImageView(frame: CGRect(origin: 100, size: 200))
        
        cell.movieImage.image = UIImage(data: data!)
        
        let postData = NSData(data: "{}".data(using: String.Encoding.utf8)!)
        
        var request = NSMutableURLRequest(url: NSURL(string: "https://api.themoviedb.org/3/genre/movie/list?language=en-US&api_key=%3C%3Capi_key%3E%3E")! as URL)
        request.httpMethod = "GET"
        request.httpBody = postData as Data
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
            //   print(error)
            } else {
                let httpResponse = response as? HTTPURLResponse
              //  print(httpResponse)
            }
        })
        
        dataTask.resume()
        
        return cell
    }
    

    @IBOutlet weak var movieTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search movies"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        
        movieTableView.dataSource = self
        movieTableView.delegate = self
        
        // usinng api from the movie database
        // reference: https://developers.themoviedb.org/3/getting-started/search-and-query-for-details
        let apiKey = "27f3d572aca003e31fe96cbd34927e72"
        let apiURL = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=" + apiKey)!
        
     //   let apiRequest = URLRequest(url: apiURL)
      /*  let apiTask: NSURLSession*/
        
        let task = URLSession.shared.dataTask(with: apiURL) {(data, response, error) in
            
            guard error == nil else {
                print("returning error")
                return
            }
            
            guard let content = data else {
                print("not returning data")
                return
            }
            
            
            guard let json = (try? JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers)) as? [String: Any] else {
                print("Not containing JSON")
                return
            }
            
           // if let array = json["companies"] as? [String] {
           //     self.tableArray = array
         //   }
            
         //   print(self.tableArray)
            
            //print(json)
            self.movieInformation = json["results"] as! [NSDictionary]
            DispatchQueue.main.async {
                self.movieTableView.reloadData()
            }
        }
        task.resume()

        // the next line not sure
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

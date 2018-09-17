//
//  movieViewController.swift
//  movie
//
//  Created by Qing Ran on 9/16/18.
//  Copyright © 2018 Qing Ran. All rights reserved.
//

import UIKit

class movieViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    

    var movieInformation: [NSDictionary]?
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieInformation?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieDetail", for: indexPath) as! movieTableViewCell
        let movieInfoString = movieInformation![indexPath.row] as! NSDictionary
        let movieTitleString = movieInfoString["original_title"] as! String
        let movieDetailString = movieInfoString["overview"] as! String
        cell.movieTitle.text = movieTitleString
        cell.movieDetail.text = movieDetailString
        
        let moviePosterString = movieInfoString["backdrop_path"] as! String
        let moviePosterURL = "https://image.tmdb.org/t/p/w185" + moviePosterString
        
        let url = URL(string: moviePosterURL)
        let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
        cell.movieImage.image = UIImage(data: data!)
        
        
        
        
    //    cell.movieTitle.text = movieTitleString as String
      
    
        /*display*/
        
      //  cell.textLabel?.text = movieTitleString as String
        return cell
    }
    

    @IBOutlet weak var movieTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
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

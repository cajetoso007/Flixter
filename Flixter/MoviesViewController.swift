//
//  MoviesViewController.swift
//  Flixter
//
//  Created by Manny Reyes on 2/5/21.
//

import UIKit
//import AlamofireImage


class MoviesViewController: UIViewController, UITableViewDataSource,UITableViewDelegate {
    
   
    @IBOutlet weak var tableView: UITableView!
    
    var movies = [[String:Any]]() //indicTES THE creation of an array of dictionaries...LOOK UP
    

    override func viewDidLoad() {
        super.viewDidLoad()
        /*
         
         */
        tableView.dataSource = self
        tableView.delegate = self

        // Do any additional setup after loading the view.
        print("hello")
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
           // This will run when the network request returns
           if let error = error {
              print(error.localizedDescription)
           } else if let data = data  {
            //this thing has the data here
              let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]

              // TODO: Get the array of movies
              // TODO: Store the movies in a property to use elsewhere
              // TODO: Reload your table view data
            self.movies = dataDictionary["results"] as! [[String:Any]] //needed to add self in front of movies. Stores movies in to an array
            
            self.tableView.reloadData()     //This throws an error
          
            print(dataDictionary) //prints into the information in to the console below

           }
        }
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //need thes two functions to work with  A data view
    
        return movies.count
        //return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell
        //cell.textLabel!.text = "row: \(indexPath.row)"
        let movie = movies[indexPath.row]
        let title = movie["title"] as! String // casting to String
        let synopsis = movie["overview"] as! String
        //chNGE the references to title
        //cell.textLabel?.text = title
        cell.titleLabel.text = title
        cell.synopsisLabel.text = synopsis
        
        let baseUrl = "https://image.tmbd.org/t/p/w185"
        let posterPath = movie["poster_path"] as! String
        let posterUrl = URL(string: baseUrl + posterPath)
        
        
        //pod was not installed for some reason
        //cell.posterView.af_setImage(withURL: posterUrl!)
        return cell
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        //need to do two tasks> 1.) find the selected movie
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)!
        let movie = movies[indexPath.row]
                                //2.) pass the selected moview to the details view controller
        
        let detailsViewController = segue.destination as! MovieDetailsViewController
        detailsViewController.movie = movie
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    

}

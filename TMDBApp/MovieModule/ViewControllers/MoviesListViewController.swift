//
//  ViewController.swift
//  TMDBApp
//
//  Created by Damian Modernell on 07/11/2018.
//  Copyright © 2018 Damian Modernell. All rights reserved.
//

import UIKit

class MoviesListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var moviesListTableVIew: UITableView!
    var presenter:MoviesPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "TMDB list"
        self.presenter?.fetchMovies(searchParams: SearchObject())
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView?) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.presenter!.getMoviesCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell  {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell", for: indexPath as IndexPath) as! MovieTableViewCell
        
        cell.setMovie(movie: self.presenter!.getMovieAtIndex(indexPath:indexPath.row)!)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func moviesFetchedWithSuccess() {
        self.moviesListTableVIew.reloadData()
    }

    func moviesFetchWithError(error:Error) {
        self.showAlertView(msg:error.localizedDescription)
    }
    
    func showAlertView(msg:String) -> () {
        let alert = UIAlertController(title: "Alert", message: msg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}


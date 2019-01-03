//
//  TMDBCoreDataConnector.swift
//  TMDBApp
//
//  Created by Damian Modernell on 07/11/2018.
//  Copyright © 2018 Damian Modernell. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class TMDBCoreDataConnector: DataConnector {
    
    static let shared = TMDBCoreDataConnector()
    
    func getManagedContext() -> NSManagedObjectContext? {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return nil
        }
        
        return appDelegate.persistentContainer.viewContext
    }
    
    func getMovies(searchParams: SearchObject, completion: @escaping QueryResut) {
        
        let managedObjectContext = self.getManagedContext()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Movies")
        fetchRequest.predicate = NSPredicate(format: "category == %@", searchParams.filter.rawValue)
        
        do {
            let movieRecords = try managedObjectContext!.fetch(fetchRequest) as! [NSManagedObject]
            var movies:[Movie] = Array()
            
            for fetchedMovie in movieRecords {
                let movie = Movie()
                movie.title = fetchedMovie.value(forKey: "title") as! String
                movie.movieId = fetchedMovie.value(forKey:"id") as! Int
                movie.setCategory(category: MovieFilter( rawValue: fetchedMovie.value(forKey:"category") as! String)!)
                movie.overview = fetchedMovie.value(forKey:"overview") as! String
                movie.imageURLPath = fetchedMovie.value(forKey:"image") as? String
                movie.voteAverage = (fetchedMovie.value(forKey:"vote_average") as? Double)!
                movie.popularity = (fetchedMovie.value(forKey:"popularity") as? Double)!

                movies.append(movie)
            }
            completion(movies, nil)
            
        } catch let error {
            print("Could not save. \(error), \(error.localizedDescription)")
            completion(nil, error)
        }
    }
    
    
    func storeMovies(movies:[Movie]) throws {
        
        let managedObjectContext = self.getManagedContext()
        managedObjectContext!.mergePolicy = NSOverwriteMergePolicy
        
        for movie in movies {
            
            let newMovie = NSEntityDescription.insertNewObject(forEntityName: "Movies", into: managedObjectContext!)
            newMovie.setValue(movie.title, forKeyPath: "title")
            newMovie.setValue(movie.movieId, forKeyPath: "id")
            newMovie.setValue(movie.category?.rawValue, forKeyPath: "category")
            newMovie.setValue(movie.popularity, forKeyPath: "popularity")
            newMovie.setValue(movie.overview, forKeyPath: "overview")
            newMovie.setValue(movie.imageURLPath, forKeyPath: "image")
            newMovie.setValue(movie.voteAverage, forKeyPath: "vote_average")

            do {
                try managedObjectContext!.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }
    
    func saveImage(imageData: Data, with fileName: String, and imageName: String?) {
        
        let documentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first
        let imageStore = documentsDirectory?.appendingPathComponent(fileName)
        
        do {
            try imageData.write(to: imageStore!)
        } catch {
            print("Couldn't write the image to disk.")
        }
    }
    
    func loadImage(from url: String, completion: @escaping (UIImage?) -> ()) {
        let documentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first
        let fileURL = documentsDirectory!.appendingPathComponent(url)
        do {
            let imageData = try Data(contentsOf: fileURL)
            completion(UIImage(data: imageData))
        } catch {
            print("Error loading image : \(error)")
        }
    }
    
}

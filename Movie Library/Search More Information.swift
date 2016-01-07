//
//  Search More Information.swift
//  Movie Library
//
//  Created by Thomas Krnc on 5/01/2016.
//  Copyright © 2016 Thomas Krnc. All rights reserved.
//

import UIKit
import CoreData

class SearchMoreInformation: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //segue data
    var dataToDisplay: String = ""
    
    //all the movies currently saved to cordata
    var moviesAdded: Array<String> = []
    
    //attributes to display
    var attributes = ["Title", "Rated", "Genre", "Type", "Released", "Runtime", "Plot", "Director", "Writer", "Actors", "Language", "Country","Awards" , "Metascore", "imdbRating"]
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if Reachability.isConnectedToNetwork() == true {
            
            //get more spesific data on the movie
            currentMovie = API().returnAPI(dataToDisplay, type: .ID, plot: "long") as! Dictionary<String, String>
            
            //set the title of the navigation bar to the title of the movie
            self.title = currentMovie["Title"]
            
            //reload the tableview with the new data
            tableView.reloadData()
            
            //reset the list of movies added to not create duplicates
            moviesAdded = []
            
            //fetch the added movies ids from core data
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
            let managedContext = appDelegate.managedObjectContext
            
            let fetchRequest = NSFetchRequest(entityName: "SavedMovies")
            
            do {
                let results = try managedContext.executeFetchRequest(fetchRequest)
                let movies = results as! [NSManagedObject]
                
                for i in movies {
                    moviesAdded.append(i.valueForKey("aimdbID") as! String)
                }
            }
            catch let error as NSError {
                print("Could not fetch \(error), \(error.userInfo)")
            }
            
        }
            
            //if the user dosnt have an internet connection
        else {
            
            //alert the user that they need to have an internet connection
            let alert = UIAlertController(title: "Unable to connect!", message: "This app requires an internet connection to search", preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            
            presentViewController(alert, animated: true, completion: nil)
        }
        
    }
 
    //save the data from the api results
    var currentMovie: Dictionary<String,String> = ["Title": ""]
    
    
    //return the amount of cells to display
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return attributes.count
        
    }
    
    func tableView(tableView: UITableView,cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //create the prototype cell
        let cell = tableView.dequeueReusableCellWithIdentifier("SearchMoreInformationCell", forIndexPath: indexPath) as! SearchMoreInformationCell
        
        //set the values inside the cells
        cell.property.text = attributes[indexPath.row]
        cell.value.text = currentMovie[attributes[indexPath.row]]
        
        //return the cell
        return cell
    }
    
    //set the height of each cell
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
     
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
     
        return 110
    }
    
    @IBAction func addButton(sender: AnyObject) {
        
        if (moviesAdded.contains(currentMovie["imdbID"]!) == false) {
            
            //get the delegate and context from core data
            let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let context = delegate.managedObjectContext
        
            //create entity for movie
            let entity = NSEntityDescription.entityForName("SavedMovies", inManagedObjectContext: context)
            let savedMovies = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: context)
        
            //add the values to the saved movies entity. (the a is infront because attributes inside entitys cant start with capital letters
            savedMovies.setValue(currentMovie["Actors"], forKey: "aActors")
            savedMovies.setValue(currentMovie["Awards"], forKey: "aAwards")
            savedMovies.setValue(currentMovie["Country"], forKey: "aCountry")
            savedMovies.setValue(currentMovie["Director"], forKey: "aDirector")
            savedMovies.setValue(currentMovie["Genre"], forKey: "aGenre")
            savedMovies.setValue(currentMovie["imdbID"], forKey: "aimdbID")
            savedMovies.setValue(currentMovie["imdbRating"], forKey: "aimdbRaiting")
            savedMovies.setValue(currentMovie["Language"], forKey: "aLanguage")
            savedMovies.setValue(currentMovie["Metascore"], forKey: "aMetaScore")
            savedMovies.setValue(currentMovie["Plot"], forKey: "aPlot")
            savedMovies.setValue(currentMovie["Rated"], forKey: "aRated")
            savedMovies.setValue(currentMovie["Released"], forKey: "aReleased")
            savedMovies.setValue(currentMovie["Runtime"], forKey: "aRuntime")
            savedMovies.setValue(currentMovie["Title"], forKey: "aTitle")
            savedMovies.setValue(currentMovie["Type"], forKey: "aType")
            savedMovies.setValue(currentMovie["Writer"], forKey: "aWriter")
            savedMovies.setValue(currentMovie["Year"], forKey: "aYear")
        
            //add the binary data to the saved movies entity
            let data = NSData(contentsOfURL:  NSURL(string: currentMovie["Poster"]!)!)
            savedMovies.setValue(data, forKey: "aPoster")
        
            do {
                //save the entity
                try context.save()
            }
                
            catch let error as NSError {
                print("Found an error \(error): \(error.userInfo)")
            }
        
            //show alert saying that the movie was successfully saved
            let alert = UIAlertController(title: "Saved", message: currentMovie["Title"]! + " was successfully saved to your collection!", preferredStyle: UIAlertControllerStyle.Alert)
        
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        
            presentViewController(alert, animated: true, completion: nil)
        
        }
    
        else {
    
            //show alert saying could not be added as it is already in you collection
            let alert = UIAlertController(title: "Unable to save", message: currentMovie["Title"]! + " is already saved in your collection!", preferredStyle: UIAlertControllerStyle.Alert)
				
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
    
            presentViewController(alert, animated: true, completion: nil)
        }

    }


}


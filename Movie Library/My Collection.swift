//
//  My Collection.swift
//  Movie Library
//
//  Created by Thomas Krnc on 5/01/2016.
//  Copyright © 2016 Thomas Krnc. All rights reserved.
//

import UIKit
import CoreData

class MyCollection: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
  
    @IBAction func startEditing(sender: UIBarButtonItem) {
        
         tableView.editing = !tableView.editing
    }
    var movies:[NSManagedObject] = []
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // Do any additional setup after loading the view, typically from a nib.
        
        //fetch saved movies from core data
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "SavedMovies")
        
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            movies = results as! [NSManagedObject]
          
            //reload the tableview with the new data
            tableView.reloadData()
        }
        catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }

    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    //set the amount of cells that will be displayed
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return movies.count
    }
    
    func tableView(tableView: UITableView,cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MyCollectionCell", forIndexPath: indexPath) as! MyCollectionCell
        
        //set the values of the cell
        cell.movieTitle.text = movies[indexPath.row].valueForKey("aTitle")! as? String
        cell.movieYear.text =  movies[indexPath.row].valueForKey("aYear")! as? String
        
        
        //check if the binary data of the movie is not nil, and if it is, set the poster to be that
        if movies[indexPath.row].valueForKey("aPoster") != nil {
            cell.moviePoster.image = UIImage(data: movies[indexPath.row].valueForKey("aPoster") as! NSData)
        }
            
        //if the binary data is nil, set the poster to be a question mark
        else {
            cell.moviePoster.image = UIImage(named: "questionmark")
        }


        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
        
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 110
    }
 
    //allow user to delete cell
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        //if the editing style is delete (the delete button has been clicked)
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            
            //load coredata stuff
            let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let context = delegate.managedObjectContext
            
            //delete object from coredata
            context.deleteObject(movies[indexPath.row] as NSManagedObject)
            
            //remove from movies array
            movies.removeAtIndex(indexPath.row)
            
            do {
                //save to coredata
                try context.save()
            }
            catch _ {
                print("Cannot save delete")
            }
            
            //remove cell from tableview with animation
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
    }
    

    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        let itemToMove = movies[fromIndexPath.row]
        movies.removeAtIndex(fromIndexPath.row)
        movies.insert(itemToMove, atIndex: toIndexPath.row)
    }


    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // Check this is the correct segue
        if segue.identifier == "MyCollectionCellSegue" {
            
            // Get a reference to the destination view controller
            let viewControllerRef = segue.destinationViewController as! MyCollectionMoreInformation
            
            // Get a reference to the index path for the row that was tapped
            let indexPath = self.tableView.indexPathForCell(sender as! UITableViewCell)
            
            // Get the data to segue
            let dataToSet = self.movies[indexPath!.row]
            
            // Set the object on the destination view controller
            viewControllerRef.dataToDisplay = dataToSet
            
        }
    }
}

//
//  Search.swift
//  Movie Library
//
//  Created by Thomas Krnc on 5/01/2016.
//  Copyright © 2016 Thomas Krnc. All rights reserved.
//

import UIKit

class Search: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {

    
    @IBOutlet weak var tableView: UITableView!
    
    //search button next to the search field
    @IBOutlet weak var searchBarTextField: UITextField!
    
    var currentSearch: Array<Dictionary<String, String>> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       
        //sets the delegate of the search bar to itself
        self.searchBarTextField.delegate = self;
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        //hides the keyboard when the search button at the bottom of the keyboard is tapped
        self.view.endEditing(true)
        
        //runs the search function to display new results
        searchBarSearchButton("1")
        
        return false
    }
   
    
    @IBAction func searchBarSearchButton(sender: AnyObject) {
        
        //hides the keyboard when the search button is tapped
        if String(sender) != "1" {
            textFieldShouldReturn(searchBarTextField)
        }
        //if the device has a network connections
        if Reachability.isConnectedToNetwork() == true {
            
            //get the results of the api and store them in a variable
            if  API().returnAPI(searchBarTextField.text!, type: .Search, plot: "long") != nil {
                currentSearch = API().returnAPI(searchBarTextField.text!, type: .Search, plot: "long") as! Array<Dictionary<String, String>>
            }
                
            else {
                
                //if there where not valiid results reset the variable that stores the movies
                currentSearch = []
            }
            
            //reload the tableview with the new search results
            tableView.reloadData()
        }
            
        //if the user dosnt have an internet connection
        else {
            
            //alert the user that they need to have an internet connection
            let alert = UIAlertController(title: "Unable to connect!", message: "This app requires an internet connection to search", preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            
            presentViewController(alert, animated: true, completion: nil)
        }
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        //return how many tableview cells to display
        return currentSearch.count
        
    }
    
    func tableView(tableView: UITableView,cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SearchCell", forIndexPath: indexPath) as! SearchCell
       
        //set the values of the cell
        cell.movieTitle.text = currentSearch[indexPath.row]["Title"]
        cell.movieYear.text = currentSearch[indexPath.row]["Year"]
       
        //gets the url stored in the array to download the poster of the film
        let data = NSData(contentsOfURL:  NSURL(string: currentSearch[indexPath.row]["Poster"]!)!)
        
        //if the url links to a result set the UIImage view in the cell to the movie poster
        if (data != nil) {
            cell.moviePoster.image = UIImage(data: data!)
        }
        
        //if there is no poster set as default image
        else {
            cell.moviePoster.image = UIImage(named: "questionmark")
        }

        return cell
    }    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // Check this is the correct segue
        if segue.identifier == "SearchCellSegue" {
            
            // Get a reference to the destination view controller
            let viewControllerRef = segue.destinationViewController as! SearchMoreInformation;
            
            // Get a reference to the index path for the row that was tapped
            let indexPath = self.tableView.indexPathForCell(sender as! UITableViewCell)
            
            // Get the id from the tapped cell
            let dataToSet = self.currentSearch[indexPath!.row]["imdbID"]
           
            // Set the object on the destination view controller
            viewControllerRef.dataToDisplay = dataToSet!
            
        }
    }
}
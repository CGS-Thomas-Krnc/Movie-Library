//
//  My Collection More Information.swift
//  Movie Library
//
//  Created by Thomas Krnc on 5/01/2016.
//  Copyright © 2016 Thomas Krnc. All rights reserved.
//

import UIKit
import CoreData

class MyCollectionMoreInformation: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var dataToDisplay: NSManagedObject?
    
    var attributes = ["Title", "Rated", "Genre", "Type", "Released", "Runtime", "Plot", "Director", "Writer", "Actors", "Language", "Country","Awards" , "MetaScore", "imdbRaiting"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //change the title of the naviagtion controller
        self.title = String(dataToDisplay?.valueForKey("aTitle") as! String)
    }

    
    //set the amount of cells to display
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return attributes.count
        
    }
    
    func tableView(tableView: UITableView,cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MyCollectionMoreInformationCell", forIndexPath: indexPath) as! MyCollectionMoreInformationCell
        
        //set the values of the cell
        cell.property.text = attributes[indexPath.row]
        
        cell.value.text = String(dataToDisplay!.valueForKey("a" + attributes[indexPath.row]) as! String)
        
        return cell
    }
    
    //set the height of each cell
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
        
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 110
    }
}

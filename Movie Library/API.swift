//
//  API.swift
//  Movie Library
//
//  Created by Thomas Krnc on 5/01/2016.
//  Copyright © 2016 Thomas Krnc. All rights reserved.
//

import Foundation

class API{
    
    func getResult(urlPath:String) -> AnyObject {
        
        let url: NSURL = NSURL(string: urlPath)!
        
        let request1: NSURLRequest = NSURLRequest(URL: url)
        
        let response: AutoreleasingUnsafeMutablePointer<NSURLResponse? >= nil
        
        let dataVal: NSData = try! NSURLConnection.sendSynchronousRequest(request1, returningResponse: response)
        
        let jsonResult = (try! NSJSONSerialization.JSONObjectWithData(dataVal, options: NSJSONReadingOptions.MutableContainers))
        
        return jsonResult
    }
    
    //enum for type of type of search the api will reques
    enum Type {
        case Search, ID, Title
    }
    
    
    //this function gets multiple types of api results and returns them
    //format: returnAPI(name, type: .Search/.ID/.Title, plot: short/long)
    //e.g returnAPI("Frozen", type: .Search, plot: "long")
    func returnAPI(query: String, type: Type, plot: String) -> AnyObject! {
        
        //store the url that will be created
        var url: String = ""
        
        //replaces " " with "+" so that the user can search for sentences aswell as strings
        var text = query.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.LiteralSearch, range: nil)
        
        //if the user enters a " " as the last character this removes it as it effects the search results
        if (text.characters.last == "+") {
            text = String(text.characters.dropLast())
        }
        
        //deal with the differnt types of inputs (search, by id, by title)
        switch type {
            
            //3 case statements to deal with all the possible results
        case Type.Search:
            
            //generates a url based on what the user inputed and what kind of movie description they want
            url = "http://www.omdbapi.com/?s=" + text + "&r=json"
            
        case Type.ID:
            url = "http://www.omdbapi.com/?i=" + text + "&plot=" + plot + "&r=json"
            
        case Type.Title:
            url = "http://www.omdbapi.com/?t=" + text + "&plot=" + plot + "&r=json"
            
        }
        
        //gets the results from the api and stores them in a variable
        let results = getResult(url)
        
        //The only time there is no response key is when there is a valid search result
        if (results["Response"]! == nil) {
            
            return results["Search"]!
        }
            
            //handling for search by id and title when there are results
        else if (results["Response"]! as! String == "True"){
            return results
        }
            
            //handling for when there are no results
        else {
            return nil
        }
    }
    
}
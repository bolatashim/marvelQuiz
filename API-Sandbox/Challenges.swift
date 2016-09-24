//
//  Challenges.swift
//  API-Sandbox
//
//  Created by Dion Larson on 6/26/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import Foundation
import SwiftyJSON

internal func exerciseOne() {
    // This would normally be network calls that return `NSData`. We'll show you how to do those soon!
    // In this case, we are using a local JSON file.
    guard let jsonURL = NSBundle.mainBundle().URLForResource("Random-User", withExtension: "json") else {
        print("Could not find Random-User.json!")
        return
    }
  
    /*why do we unwrap this straight away? should not we check if it really contains a value and not a nil?*/
    
    let jsonData = NSData(contentsOfURL: jsonURL)!
    
    
    // Enter SwiftyJSON!
    // userData now contains a JSON object representing all the data in the JSON file.
    // This JSON file contains the same data as the tutorial example.
    let userData = JSON(data: jsonData)
    
    // Alright, now we have a JSON object from SwiftyJSON containing the user data!
    // Let's save the user's first name to a constant!
    let firstName = userData["results"][0]["name"]["first"].stringValue
    let lastName = userData["results"][0]["name"]["last"].stringValue
    let streetName = userData["results"][0]["location"]["street"].stringValue
    let city = userData["results"][0]["location"]["city"].stringValue
    let state = userData["results"][0]["location"]["state"].stringValue
    let postcode = userData["results"][0]["location"]["postcode"].intValue
    let title = userData["results"][0]["name"]["title"].stringValue
    let emailAddress = userData["results"][0]["email"].stringValue
    let cellPhone = userData["results"][0]["cell"].stringValue
    
    // Do you see what we did there? We navigated down the JSON heirarchy, asked for "results",
    // then the first dictionary value of that array, then the dictionary stored in "name",
    // then the value stored in "first". We  then told it that we wanted the value as a string.
    
    /*
     
     Now it's your turn to get the rest of the values needed to print the following:
     <first name> <last name> lives at <street name> in <city>, <state>, <post code>. If you want to contact <title>. <last name>, you can email <email address> or call at <cell phone number>.

     
     "<first name> <last name> lives at <street name> in <city>, <state>, <post code>.
     If you want to contact <title>. <last name>, you can email <email address> or
     call at <cell phone number>."
     
     */
    
    print("\(firstName) \(lastName) lives at \(streetName) in \(city), \(state), \(postcode). If you want to contact \(title). \(lastName), you can email \(emailAddress) or call at \(cellPhone)")
}

internal func exerciseTwo() {
    // This would normally be network calls that return `NSData`. We'll show you how to do those soon!
    // In this case, we are using a local JSON file.
    guard let jsonURL = NSBundle.mainBundle().URLForResource("iTunes-Movies", withExtension: "json") else {
        print("Could not find Random-User.json!")
        return
    }
    let jsonData = NSData(contentsOfURL: jsonURL)!
    
    
    // Enter SwiftyJSON!
    // moviesData now contains a JSON object representing all the data in the JSON file.
    // This JSON file contains the same data as the tutorial example.
    let moviesData = JSON(data: jsonData)
    
    // We save the value for ["feed"]["entry"][0] to topMovieData to pull out just the first movie's data
    let topMovieData = moviesData["feed"]["entry"][0]
    let topMovie = Movie(json: topMovieData)
    
    // Uncomment this print statement when you are ready to check your code!
    
    print("The top movie is \(topMovie.name) by \(topMovie.rightsOwner). It costs $\(topMovie.price) and was released on \(topMovie.releaseDate). You can view it on iTunes here: \(topMovie.link)")
}

internal func exerciseThree() {
    // This would normally be network calls that return `NSData`. We'll show you how to do those soon!
    // In this case, we are using a local JSON file.
    guard let jsonURL = NSBundle.mainBundle().URLForResource("iTunes-Movies", withExtension: "json") else {
        print("Could not find Random-User.json!")
        return
    }
    let jsonData = NSData(contentsOfURL: jsonURL)!
    
    // Enter SwiftyJSON!
    // moviesData now contains a JSON object representing all the data in the JSON file.
    // This JSON file contains the same data as the tutorial example.
    let moviesData = JSON(data: jsonData)
    
    // We've done you the favor of grabbing an array of JSON objects representing each movie
    let allMoviesData = moviesData["feed"]["entry"].arrayValue
    
    /*
     
     Figure out a way to turn the allMoviesData array into Movie structs!
     
     */
    var allMovies: [Movie] = []
    
    for movie in allMoviesData{
        allMovies.append(Movie(json: movie))
    }
    
    
    /*
     
     Uncomment the below print statement and then print out the names of the two Disney
     movies in allMovies. A movie is considered to be a "Disney movie" if `rightsOwner`
     contains the `String` "Disney". Iterate over all the values in `allMovies` to check!
     
     */
    print("The following movies are Disney movies:")
    
    for movie in allMovies{
        if movie.rightsOwner.containsString("Disney"){
            print("\(movie.name)")
        }
    }
    
    
    
    /*
     
     Uncomment the below print statement and then print out the name and price of each
     movie that costs less than $15. Iterate over all the values in `allMovies` to check!
     
     */
    print("The following movies are cost less than $15:")
    
    for movie in allMovies{
        if movie.price < 15.0{
            print("\(movie.name): \(movie.price)")
        }
    }
    
    
    /*
     
     Uncomment the below print statement and then print out the name and release date of
     each movie released in 2016. Iterate over all the values in `allMovies` to check!
     
     */
    print("The following movies were released in 2016:")
    
    for movie in allMovies{
        
        if movie.releaseDate.containsString("2016"){
            print("\(movie.name) was released on \(movie.releaseDate)")
        }
    }
    
    
    
}

//
//  RdioSearchDelegate.swift
//  RdioParty
//
//  Created by Gabe Kangas on 3/1/15.
//

import UIKit

class RdioSearchDelegate: NSObject, MLPAutoCompleteTextFieldDataSource, RdioDelegate {
    
    func autoCompleteTextField(textField: MLPAutoCompleteTextField!, possibleCompletionsForString string: String!, completionHandler handler: (([AnyObject]!) -> Void)!) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            var parameters:Dictionary<String, AnyObject!> = ["query": string, "types": "Track", "countryCode": "US"]
            
            UIApplication.rdioPartyApp.session.rdio.callAPIMethod("search",
                withParameters: parameters,
                success: { (result) -> Void in
                    println(result)
                    var autoCompleteResults = Array<AutoCompleteObject>()
                    
                    if let tracks = result["results"] as? Array<Dictionary<NSObject, AnyObject>> {
                        for track in tracks {
                            var autocomplete = AutoCompleteObject()
                            var trackName = track["name"] as! String
                            var artistName = track["artist"] as! String
                            autocomplete.string = String(stringInterpolation: artistName, " - ", trackName)
                            autocomplete.trackKey = track["key"] as! String
                            autocomplete.image = track["icon"] as! String
                            autoCompleteResults.append(autocomplete)
                        }
                    }
                    handler(autoCompleteResults)

                    
                }) { (error) -> Void in
                    // Error
                    println(error)
            }

        })
        
    }
}

class AutoCompleteObject : NSObject, MLPAutoCompletionObject {
    var string = ""
    var trackKey :String!
    var image :String!
    
    @objc func autocompleteString() -> String! {
        return self.string
    }
}

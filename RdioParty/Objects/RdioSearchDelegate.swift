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
            let parameters:Dictionary<String, AnyObject!> = ["query": string, "types": "Track", "countryCode": "US"]
            
            UIApplication.rdioPartyApp.session.rdio.callAPIMethod("search",
                withParameters: parameters,
                success: { (result) -> Void in
                    print(result)
                    var autoCompleteResults = Array<AutoCompleteObject>()
                    
                    if let tracks = result["results"] as? Array<Dictionary<NSObject, AnyObject>> {
                        for track in tracks {
                            let autocomplete = AutoCompleteObject()
                            let trackName = track["name"] as! String
                            let artistName = track["artist"] as! String
                            autocomplete.string = String(stringInterpolation: artistName, " - ", trackName)
                            autocomplete.trackKey = track["key"] as! String
                            autocomplete.image = track["icon"] as! String
                            autoCompleteResults.append(autocomplete)
                        }
                    }
                    handler(autoCompleteResults)

                    
                }) { (error) -> Void in
                    // Error
                    print(error)
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

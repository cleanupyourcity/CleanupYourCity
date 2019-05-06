//
//  File.swift
//  CleanUpYourCity
//
//  Created by Diana Danvers on 5/1/19.
//  Copyright © 2019 Group3. All rights reserved.
//

class Event {
    

    //   eventIcons
    //[true, true, true, true, t...]
   
   // eventLocation
   // [0° N, 0° E]

  //  eventPhotoID
//    "garbageExampleID"
   
    
    var eventSeverityLevel: String?
    var eventDescription: String?
    var eventPoster: String?
    var eventName: String?
    
    init(eventSeverityLevel: String?, eventDescription: String?, eventPoster: String?, eventName: String?){
        self.eventDescription = eventDescription
        self.eventSeverityLevel = eventSeverityLevel
        self.eventPoster = eventPoster
        self.eventName = eventName
    }
}

//
//  Annotations.swift
//  FindWay_Naveen_c0765772
//
//  Created by Navi Malhotra on 2020-06-15.
//  Copyright © 2020 Naveen Kumar. All rights reserved.
//

import Foundation
import MapKit

class Annotations: NSObject , MKAnnotation{
    
    var coordinate: CLLocationCoordinate2D
    var identifier:String
    
    init(coordinate:CLLocationCoordinate2D , identifier:String){
        
        self.coordinate = coordinate
        self.identifier = identifier
        super.init()
    }
     
}

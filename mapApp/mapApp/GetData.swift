//
//  GetData.swift
//  mapApp
//
//  Created by Lijie Zhao on 8/29/17.
//  Copyright © 2017 team_lk. All rights reserved.
//

import UIKit
import Foundation

func getData(){
    var infos:[PakingInfo] = []
    
    let url = URL(string: "http://www.cityofmadison.com/parking-utility/data/ramp-availability.json")
    var request = URLRequest(url: url!)
    
    request.httpMethod = "GET"
    let session = URLSession.shared
    
    let task = session.dataTask(with: request) { (data, response, error) in
        print("start of closure")
        
        guard case let messageResponse as HTTPURLResponse = response else {
            print("response error")
            return
        }
        
        guard let status = HTTPStatusCode(rawValue: messageResponse.statusCode) else {
            print("status error")
            return
        }
        
        switch status {
        case .ok:
            print("success OK")
            
            guard let returnedData = data else {
                print("no data")
                return
            }
            
            let decoder = JSONDecoder()
            let newInfos = try? decoder.decode([PakingInfo].self, from: returnedData)
            
            infos = newInfos ?? []
            
            if infos.count == 6 {
                availabilityDictionary.updateValue(infos[0].vacant_stalls, forKey: "Brayton Lot")
                availabilityDictionary.updateValue(infos[1].vacant_stalls, forKey: "Capitol Square North Garage")
                availabilityDictionary.updateValue(infos[2].vacant_stalls, forKey: "Government East Garage")
                availabilityDictionary.updateValue(infos[3].vacant_stalls, forKey: "Overture Center Garage")
                availabilityDictionary.updateValue(infos[4].vacant_stalls, forKey: "State Street Campus Garage")
                availabilityDictionary.updateValue(infos[5].vacant_stalls, forKey: "State Street Capitol Garage")
                print("called")
            }
            
            //print(infos.description)
        default:
            print("status gone \(status)")
        }
    }
    task.resume()
}



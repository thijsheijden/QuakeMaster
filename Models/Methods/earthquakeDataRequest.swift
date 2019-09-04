//
//  earthquakeDataRequest.swift
//  Quakes
//
//  Created by Thijs van der Heijden on 04/09/2019.
//  Copyright © 2019 Thijs van der Heijden. All rights reserved.
//

import Foundation

func earthquakeDataRequest(completion: @escaping (EarthquakeDataStruct) -> Void) {
    let session = URLSession.shared
    
    let requestURL: URL = URL(string: "https://earthquake-report.com/feeds/recent-eq?json")!
    
    let task = session.dataTask(with: requestURL, completionHandler: { data, response, error in
        if error == nil {
            guard let data = data else {return}
            do {
                let earthquakeData = try JSONDecoder().decode(EarthquakeDataStruct.self, from: data)
                completion(earthquakeData)
            } catch let error {
                print(error)
            }
        }
    })
    
    task.resume()
}

//
//  JSONHandler.swift
//  QFree
//
//  Created by User on 14.04.2021.
//

import Foundation

class ServerHandler{
    static func submitAction(data: [Product : Int], id : Int, time : String) {
        var elems: [Any] = []
        for (product, amount) in data {
            for _ in 0..<amount{
                elems.append(product.name as NSString)
                //item["image"] = product.imageLink as NSString
                //item["price"] = String(product.price) as NSString
                //item["restaurantID"] = product.restaurantID as NSString
                //item["amount"] = String(amount) as NSString
                //item["category"] = product.category.map { $0.rawValue } as NSArray
                //elems.append(item)
            }
        }
        var json = [String: Any]()
        json["id"] = id
        json["menu"] = elems
        json["time"] = time
        print(json)
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        let url = URL(string: "http://192.168.1.15:3000/new_order")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {
            data, response, error in
            guard error == nil else {
                return
            }
            guard let data = data else {
                return
            }
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    print(json)
                } else {
                    print(data)
                }
            } catch let error {
                print(error.localizedDescription)
            }
        })
        task.resume()
    }
    
    
}

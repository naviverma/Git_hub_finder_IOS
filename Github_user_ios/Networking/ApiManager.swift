//
//  ApiManager.swift
//  Github_user_ios
//
//  Created by Navdeep on 05/07/2023.
//

import Foundation

class ApiManager{
    
    func hitApi(_ final_url_string:String,completion: @escaping (Data?, Error?,String?) -> Void){
        guard let url = URL(string: final_url_string) else { return }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("[DATA TASK ERROR: \(error.localizedDescription)]")
                completion(nil,error,"error error")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("[SERVER ERROR]")
                completion(nil,error,"response error")
                return
            }
            
            guard let data = data else {
                print("No data is received")
                completion(nil,error,"data error")
                return
            }
            completion(data,nil,nil)
        }
        task.resume()
    }
}

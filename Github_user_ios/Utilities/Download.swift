//
//  Download.swift
//  Github_user_ios
//
//  Created by Navdeep on 09/07/2023.
//

import Foundation
import UIKit

class Download{
    func downloadImage(from urlString: String,completion:@escaping(Data?)->Void){
                let instance = ApiManager()
        instance.hitApi(urlString){
            (data,error,situation) in
                do{
                    completion(data!)
                    }
                }
            }
    func downloadImage(from urlString: String,indexi index:IndexPath,completion:@escaping(Data?)->Void){
        let instance = ApiManager()
        instance.hitApi(urlString){
            (data,error,situation) in
                do{
                    completion(data!)
                    }
                }
            }
        }

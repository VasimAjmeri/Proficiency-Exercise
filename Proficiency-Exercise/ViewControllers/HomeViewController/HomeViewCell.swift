//
//  HomeViewCell.swift
//  Proficiency-Exercise
//
//  Created by Vasim Ajmeri on 17/06/18.
//  Copyright © 2018 Vasim Ajmeri. All rights reserved.
//

import UIKit
import Foundation

class HomeViewCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    
    
// download image
    
    func setImageForCell(_ imgUrl: String){
        
        self.imgView.loadImageUsingUrlString(imgUrl)
    }
    
    
}

//cached image
let imageCache = NSCache<NSString, UIImage>()

extension UIImageView{
    
    func loadImageUsingUrlString(_ strUrl: String){
        let imgUrl = URL.init(string: strUrl)!
        
        self.image = nil
        
        if let imageFromCache = imageCache.object(forKey: strUrl as NSString){//load from cache
            self.image = imageFromCache
       
        }else{//download image
            URLSession.shared.dataTask(with: imgUrl) { (data, response, error) in
                
                if error != nil{
                    print(error ?? "Error")
                    return
                }
                
                DispatchQueue.main.async {//load image on main thread
                    
                    if let data = data{
                        let image = UIImage.init(data: data)
                        if let image = image{
                            self.image = image
                            imageCache.setObject(image, forKey: strUrl as NSString)
                        }else{
                            print("NO IMAGE")
                        }
                    }
                    
                }
            }.resume()
        }
    }
    
}


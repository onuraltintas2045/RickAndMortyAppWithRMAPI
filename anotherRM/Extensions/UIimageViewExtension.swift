//
//  UIimageViewExtension.swift
//  anotherRM
//
//  Created by Onur on 1.09.2023.
//

import Foundation
import UIKit

extension UIImageView{
    
    func loadImage(url: URL){
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Error loading image: \(error)")
                return
            }
            
            if let imageData = data, let image = UIImage(data: imageData) {
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        }.resume()
    }
    
}

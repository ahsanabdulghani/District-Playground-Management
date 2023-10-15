//
//  Utilities.swift
//  FYPProject
//
//  Created by apple on 02/04/2023.
//

import Foundation
import UIKit

class Utilities
{
    public static func getImageFromURL(name:String)->UIImage?{
        let _url = URL(string:"http://10.211.55.4/DPMSapi/Content/Uploads/\(name.replacingOccurrences(of: " ", with: "%20"))")
        guard let url = _url else{
            return nil
        }
        let _data = try? Data(contentsOf: url)
        guard let data = _data else {
            return nil
        }
        let image = UIImage(data: data)
        return image
    }
    
    
    
}

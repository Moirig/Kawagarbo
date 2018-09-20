//
//  Data+Extension.swift
//  KawagarboExample
//
//  Created by 温一鸿 on 2018/9/20.
//  Copyright © 2018年 Moirig. All rights reserved.
//

import Foundation

extension Data {
    
    var dictionary: [String: Any]? {
        
        do {
            let dict = try JSONSerialization.jsonObject(with: self, options: .allowFragments) as? [String: Any]
            return dict
        }
        catch {
            debugPrint(error)
            return nil
        }
        
    }
    
}

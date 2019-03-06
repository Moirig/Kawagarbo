//
//  KGRequestTarget.swift
//  Alamofire
//
//  Created by 温一鸿 on 2019/3/5.
//

import UIKit
import SolarNetwork

struct KGTarget: SLTarget {
    
    var baseURLString: String { return "" }
    
}

let KGNetwork = SLNetwork(KGTarget())


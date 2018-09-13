//
//  Data.swift
//  iOSTaskCornerWearables
//
//  Created by Bálint Németh on 2018. 09. 10..
//  Copyright © 2018. Németh Bálint. All rights reserved.
//

import Foundation

class Data {

    private var _ts: String!
    private var _punch_type_id: Int!
    private var _speed_mph: Double!
    private var _power_g: Double!

    var ts: String {
        return _ts
    }

    var punch_type_id: Int {
        return _punch_type_id
    }

    var speed_mph: Double {
        return _speed_mph
    }

    var power_g: Double {
        return _power_g
    }

    init(ts: String, punch_type_id: Int, speed_mph: Double, power_g: Double){
        
        self._ts = ts
        self._punch_type_id = punch_type_id
        self._speed_mph = speed_mph
        self._power_g = power_g
    }
    
}



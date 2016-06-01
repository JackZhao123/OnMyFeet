//
//  Operators+Additions.swift
//  onMyFeet
//
//  Created by Jack Zhao on 2016-06-01.
//  Copyright © 2016 OnMyFeet Group. All rights reserved.
//

import Foundation

func +=<U,T> (inout lhs: [U:T], rhs: [U:T]) {
    for (key, value) in rhs {
        lhs[key] = value
    }
}
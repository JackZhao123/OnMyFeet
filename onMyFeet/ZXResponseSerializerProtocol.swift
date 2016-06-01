//
//  ZXResponseSerializerProtocol.swift
//  onMyFeet
//
//  Created by Jack Zhao on 2016-06-01.
//  Copyright © 2016 OnMyFeet Group. All rights reserved.
//

import Foundation

protocol ZXResponseSerializerProtocol {
    func serializeResponseObjectToModel(responseObject:NSData?, requestUserInfo:NSDictionary?);
}

//
//  PFObject+Extension.swift
//  Relentless
//
//  Created by pixable on 7/12/15.
//  Copyright (c) 2015 Zachary Shakked. All rights reserved.
//

import Foundation

extension PFObject {
    class func objectify(objectIds: [String]) -> [PFObject] {
        var objects : [PFObject] = []
        for objectId in objectIds {
            objects.append(PFObject(withoutDataWithObjectId: objectId))
        }
        return objects
    }
}
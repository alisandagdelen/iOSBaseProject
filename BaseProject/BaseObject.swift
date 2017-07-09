//
//  BaseObject.swift
//  BaseProject
//
//  Created by alişan dağdelen on 9.07.2017.
//  Copyright © 2017 alisandagdeleb. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

class BaseObject:Object, Mappable {

    dynamic var id:String = UUID().uuidString
    dynamic var createdAt:Date = Date()
    dynamic var updatedAt:Date = Date()

    class func url() -> String {
        return ""
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    required convenience public init?(map: Map) {
        self.init()
    }
    
    public func mapping(map: Map) {
        
        if map.mappingType == .toJSON {
            var id = self.id
            id  <- map["id"]
        }
        else {
            if id == ""  { // ||
                id  <- map["id"]
            }
        }
        createdAt   <-  (map["createdAt"], DateTransform())
        updatedAt   <-  (map["updatedAt"], DateTransform())
    }
    
    class func objectForPrimaryKey<T:Object>(_ type: T.Type, key:String) -> T? {
        return _realm.object(ofType: type, forPrimaryKey:key as AnyObject)
    }
}

class DateTransform:TransformType {
    
    typealias Object = Date
    typealias JSON = String
    
    
    
    func transformFromJSON(_ value: Any?) -> Object? {
        if let timeStr = value as? String {
            let date = Date.dateFromServerString(timeStr)
            return date as DateTransform.Object?
        }
        return nil
    }
    
    func transformToJSON(_ value: Object?) -> JSON? {
        if let date = value {
            return date.serverString()
        }
        
        return ""
    }
    
}

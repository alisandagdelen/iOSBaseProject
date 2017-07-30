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
    dynamic var active = true
    
    //Will not posted to server
    dynamic var isDirty = false
    
    dynamic var isNew = false
    
    
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
            if id == ""  {
                id  <- map["id"]
            }
        }
        createdAt   <-  (map["createdAt"], DateTransform())
        updatedAt   <-  (map["updatedAt"], DateTransform())
    }
    
    func clearUp() {
        if !delete() {
            print("Object NOT cleared!")
        }
    }
    
    func delete() -> Bool {
        let willCommit = beginWrite2()
        _realm.delete(self)
        if willCommit {
            commitWrite()
        }
        return self.isInvalidated
    }
    
    class func objectWithId<T:Object>(_ type: T.Type, key:String) -> T? {
        return _realm.object(ofType: type, forPrimaryKey:key as AnyObject)
    }
    
    class func allObjects<T:Object>(_ type: T.Type) -> Results<T> {
        return _realm.objects(type)
    }
    
    class func saveLocal(_ obj:Any, isNew:Bool, isDirty:Bool=false) -> BaseObject! {
        var changed = false
        let savedObj = saveLocal(obj, isNew:isNew, isDirty:isDirty, changed:&changed)
        return savedObj
    }

    fileprivate class func saveLocal(_ obj:Any, isNew:Bool, isDirty:Bool=false, changed:inout Bool) -> BaseObject! {
        
        var baseObject:BaseObject!
        baseObject = obj as! BaseObject

        var newObject:BaseObject!
        let willCommit = beginWrite2()
        
        baseObject.isDirty = isDirty
        baseObject.isNew = isNew
        
        if isNew {
            baseObject.createdAt = Date()
            baseObject.updatedAt = Date()
            baseObject.isDirty = true
        }
        
        
        let type = type(of: baseObject!)
        if let _ = primaryKey() {
            if let existing = allObjects(type).filter("id = '\(baseObject.id)'").first {
                if existing.updatedAt >= baseObject.updatedAt {
                    do {
                        try _realm.commitWrite()
                        return existing
                    }
                    catch {
                        return nil
                    }
                }
                else {
                    if baseObject.active {
                        _realm.add(baseObject, update:true)
                        newObject = baseObject
                    }
                    else {
                        existing.clearUp()
                        newObject = baseObject
                    }
                }
            }
            else {
                if baseObject.active {
                    newObject = _realm.create(type, value:baseObject, update:true)
                }
            }
            
        }
        else {
            newObject = _realm.create(type, value:baseObject, update:false)
        }
        
        
        if willCommit {
            do {
                beginWrite()
                try _realm.commitWrite()
                changed = true
                return newObject
            }
            catch {
                return nil
            }
        }
        else {
            changed = true
            return newObject
        }
        
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

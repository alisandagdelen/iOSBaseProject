//
//  RealmHelper.swift
//  BaseProject
//
//  Created by alişan dağdelen on 9.07.2017.
//  Copyright © 2017 alisandagdeleb. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

private var internalRealm:Realm!
private let schemaVersion:UInt64 = 1
public var _realm:Realm! {
    
    if internalRealm == nil {
        refreshRealm()
    }
    
    return internalRealm
}


public func refreshRealm() {
    do {
        let config = Realm.Configuration(schemaVersion:schemaVersion)
        Realm.Configuration.defaultConfiguration = config
        try internalRealm = Realm()
    }
    catch {
        print("Cannot create Realm instance!")
    }
}

func beginWrite() {
    if !_realm.isInWriteTransaction {
        _realm.beginWrite()
    }
}

func beginWrite2() -> Bool {
    if !_realm.isInWriteTransaction {
        _realm.beginWrite()
        return true
    }
    
    return false
}

func commitWrite() {
    if _realm.isInWriteTransaction {
        do {
            try _realm.commitWrite()
        }
        catch {
            print("!!! REALM CommitWrite FAILED !!!")
        }
    }
}


func commitWrite2() -> Bool {
    if _realm.isInWriteTransaction {
        do {
            try _realm.commitWrite()
            return true
        }
        catch {
            print("Local Object update failed!")
        }
    }
    
    return false
}

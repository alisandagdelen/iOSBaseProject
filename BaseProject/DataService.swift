//
//  DataService.swift
//  BaseProject
//
//  Created by alişan dağdelen on 9.07.2017.
//  Copyright © 2017 alisandagdeleb. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import ObjectMapper


typealias BaseObjectBlock = (_ object:BaseObject?, _ error: Error?)-> Void
typealias BaseArrayBlock = (_ object:[BaseObject]?, _ error: Error?)-> Void
typealias GenericObjectBlock<T> = (_ object:T?, _ error: Error?)-> Void
typealias GenericArrayBlock<T> = (_ object:[T]?, _ error: Error?)-> Void
typealias ResultBlock = (_ succeeded:Bool, _ error:String?) -> ()

class DataService{
    
    static let sharedInstance = DataService()
    fileprivate init() {}
    
    struct Router: URLRequestConvertible {
        
        var method: Alamofire.HTTPMethod
        var path: String
        let params: [String : Any]?
        
        init(method:Alamofire.HTTPMethod, path:String, params: [String : Any]?) {
            self.method = method
            self.path = path
            self.params = params
        }
        
        
        public func asURLRequest() throws -> URLRequest {
            return urlRequest
        }
        
        var urlRequest: URLRequest {
            let URL = Foundation.URL(string:API.BaseURL + path)!
            
            var req = URLRequest(url:URL)
            req.httpMethod = method.rawValue
            
            do {
                return try Alamofire.JSONEncoding().encode(req, with:params)
            }
            catch{
                return req
            }
        }
        
    }
    
    //MARK: - Service Methods
    
    private func callRequest(_ req:Router) -> DataRequest {
        return Alamofire.request(req).validate()
    }
    
    private func getOrDeleteObject<T:BaseObject>(type:BaseObject.Type, method:Alamofire.HTTPMethod, path:String? , params:[String : Any]?, _ result:@escaping GenericObjectBlock<T>){
        
        let url:String! = path ?? type.url()
        
        callRequest(Router(method: method, path: url, params: params)).responseObject { (response:DataResponse<T>) -> Void in
            if let object = response.result.value {
                result(object, nil)
            }else {
                result(nil, response.result.error)
            }
        }
    }
    
    private func sendObject<T:BaseObject>(_ object:BaseObject?, type:BaseObject.Type, method:Alamofire.HTTPMethod, path:String? , params:[String : Any]?, _ result:@escaping GenericObjectBlock<T>) {
        
        let url:String! = path ?? type.url()
        let reqParams = object?.toJSON() ?? params
        
        callRequest(Router(method: .post, path: url, params: reqParams)).responseObject { (response:DataResponse<T>) -> Void in
            if let object = response.result.value {
                result(object, nil)
            } else {
                result(nil, response.result.error)
            }
        }
    }
    
    private func getObjects<T:BaseObject>(type:BaseObject.Type, method:Alamofire.HTTPMethod, path:String? , params:[String : Any]?, _ result:@escaping GenericArrayBlock<T>) {
        
        let url:String! = path ?? type.url()
        
        callRequest(Router(method: .get, path: url, params: params)).responseArray { (response:DataResponse<[T]>) -> Void in
            if let object = response.result.value {
                result(object, nil)
            }else {
                result(nil, response.result.error)
            }
        }
    }
    
    private func getObject<T:BaseObject>(type:BaseObject.Type, path:String? , params:[String : Any]?, _ result:@escaping GenericObjectBlock<T>) {
        getOrDeleteObject(type: type, method: .get, path: path, params: params, result)
    }
    
    private func deleteObject<T:BaseObject>(type:BaseObject.Type, path:String? , params:[String : Any]?, _ result:@escaping GenericObjectBlock<T>) {
        getOrDeleteObject(type: type, method: .delete, path: path, params: params, result)
    }
    
    private func putObject<T:BaseObject>(_ object:BaseObject, type:BaseObject.Type, path:String? , params:[String : Any]?, _ result:@escaping GenericObjectBlock<T>) {
        sendObject(object, type: type, method: .put, path: path, params: params, result)
    }
    
    private func postObject<T:BaseObject>(_ object:BaseObject?, type:BaseObject.Type, path:String? , params:[String : Any]?, _ result:@escaping GenericObjectBlock<T>) {
        sendObject(object, type: type, method: .post, path: path, params: params, result)
    }
    
    private func patchObject<T:BaseObject>(_ object:BaseObject, type:BaseObject.Type, path:String? , params:[String : Any]?, _ result:@escaping GenericObjectBlock<T>) {
        sendObject(object, type: type, method: .patch, path: path, params: params, result)
    }
    
    
}












//
//  ServiceNetworkLayer.swift
//  NetworkLayer
//
//  Created by David Duarte on 14/12/2018.
//  Copyright © 2018 David Duarte. All rights reserved.
//

import Foundation
import Alamofire

// Alias para las funciones callback
public typealias APISuccessHandler<T> = (_ result: T, _ httpResponse: HttpResponse?) -> Void
public typealias APIFailureHandler = (Error, _ httpResponse: HttpResponse?) -> Void


public class HttpClient {
    
    public static let shared = HttpClient() // Singleton de HttpClient, publico para poder acceder
    
    private let sessionManager = Session() // nos genera una sola instancia del session manager
    
    private init() {
        
    }
    
    // Ejecuta un post http
    public func callPost <T: Codable> (serviceUrl : String, parameters: Parameters, encoding: ParameterEncoding = JSONEncoding.default, headers: HTTPHeaders = [:], success: @escaping APISuccessHandler<T>, failure: APIFailureHandler? = nil) {
        call(serviceUrl: serviceUrl, method: .post, parameters: parameters, encoding: encoding, headers: headers, success: success, failure: failure)
    }
    
    // Ejecuta un get http
    public func callGet <T: Codable> (serviceUrl : String, parameters: Parameters = [:], encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders = [:], success: @escaping APISuccessHandler<T>, failure: APIFailureHandler? = nil) {
        call(serviceUrl: serviceUrl, method: .get, parameters: parameters, encoding: encoding, headers: headers, success: success, failure: failure)
    }
    
    // Ejecuta un delete http
    public func callDelete<T: Codable> (serviceUrl : String, parameters: Parameters = [:], encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders = [:], success: @escaping APISuccessHandler<T>, failure: APIFailureHandler? = nil){
        call(serviceUrl: serviceUrl, method: .delete, parameters: parameters, encoding: encoding, headers: headers, success: success, failure: failure)
    }
    
    // Ejecuta un put http
    public func callPut<T: Codable> (serviceUrl : String, parameters: Parameters, encoding: ParameterEncoding = JSONEncoding.default, headers:HTTPHeaders = [:], success: @escaping APISuccessHandler<T>, failure:  APIFailureHandler? = nil) {
        call(serviceUrl: serviceUrl, method: .put, parameters: parameters, encoding: encoding, headers: headers, success: success, failure: failure)
    }
    
    // Ejecuta un patch http
    public func callPatch<T: Codable> (serviceUrl : String, parameters: Parameters, encoding: ParameterEncoding = JSONEncoding.default, headers:HTTPHeaders = [:], success: @escaping APISuccessHandler<T>, failure:  APIFailureHandler? = nil) {
        call(serviceUrl: serviceUrl, method: .patch, parameters: parameters, encoding: encoding, headers: headers, success: success, failure: failure)
    }
    
    // Crea un nuevo request utilizando el sessionManager
    private func createRequest (serviceUrl : String,
                               method: HTTPMethod,
                               parameters: Parameters? = nil,
                               encoding: ParameterEncoding,
                               headers:HTTPHeaders? = nil
                                ) -> DataRequest {
        
        let request = self.sessionManager.request(serviceUrl, method: method, parameters: parameters, encoding: encoding, headers: headers).validate()
        // Genero request
        return request
    }
    
    // Llamada general http usando alamofire
    private func call<T: Codable> (serviceUrl : String,
                                   method: HTTPMethod,
                                   parameters: Parameters,
                                   encoding: ParameterEncoding,
                                   headers:HTTPHeaders,
                                   success: @escaping APISuccessHandler<T>,
                                   failure: APIFailureHandler? = nil) {
        let request = self.createRequest (serviceUrl: serviceUrl, method: method, parameters: parameters, encoding: encoding )
        
        request.responseJSON { response in
            do {
                switch(response.result) {
                case .failure (let value):
                    failure!(value, nil)
                    break
                case .success:
                    // Deserialización de respuesta Json a Objeto
                    let decoder = JSONDecoder()
                    let arrayResponse = try decoder.decode(T.self, from: response.data!)
                    success(arrayResponse, nil)
                }
            } catch {
                failure!(error, nil)
            }
        }
    }
}

// Extension para transformar el objeto a un diccionario. Para utilizar en la capa de networking
public extension Encodable {
    func dictionary() -> [String: Any]? {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .millisecondsSince1970
        guard let json = try? encoder.encode(self),
            let dict = try? JSONSerialization.jsonObject(with: json, options: []) as? [String: Any] else {
                return nil
        }
        return dict
    }
}

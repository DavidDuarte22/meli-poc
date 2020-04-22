//
//  HttpResponse.swift
//  NetworkLayer
//
//  Created by David Duarte on 16/01/2019.
//

import Foundation
import Alamofire

// Clase base para una respuesta http
public class HttpResponse {
    public var response: DataResponse<Any, Error>
    public var httpError: HttpError?
    
    public init(_ response: DataResponse<Any, Error>){
        self.response = response
    }
    
    // Devuelve si hubo un error en la invocacion en base al statusCode
    public func hasError() -> Bool{
        var error = false
        if response.response != nil {
            // Errores en cliente y en servidor
            error = response.response!.statusCode >= 400 && response.response!.statusCode < 600
        }
        return error
    }
}

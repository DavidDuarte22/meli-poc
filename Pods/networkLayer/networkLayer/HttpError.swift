//
//  HttpError.swift
//  NetworkLayer
//
//  Created by David Duarte on 15/01/2019.
//

import Foundation

// Serveridad de un error
public enum ErrorSeverity:String,Decodable{
    case LOW
    case HIGH
}

// Clase base para representar errores estandarizados de la golden API
public class HttpError:Decodable{
   public var error: String
   public var severity: ErrorSeverity
   public var message: String
    
    public init(){
        self.error = ""
        self.severity = ErrorSeverity.LOW
        self.message = ""
    }
}

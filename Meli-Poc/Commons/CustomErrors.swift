//
//  Error.swift
//  Meli-Poc
//
//  Created by David Duarte on 13/09/2019.
//  Copyright © 2019 David Duarte. All rights reserved.
//

import Foundation
import UIKit

enum MeliError: Error {
    case networkError
    case defaultError
}

struct ErrorStruct {
    var title: String
    var message: String
    var type: MeliError?
    
    init(title: String, message: String, errorType: MeliError?) {
        self.title = title
        self.message = message
        self.type = errorType
    }
}

class ErrorHandler {
    func tableError(error: Error) -> ErrorStruct {
        if case is MeliError = error {
            if case MeliError.networkError = error {
              return ErrorStruct(title: "It seems you aren't connect to Internet", message: "Please, check your connection", errorType: MeliError.networkError)
            }
           return ErrorStruct(title: "This is embarrassing, an error happened", message: "Please, try it again", errorType: MeliError.defaultError)
        }
        return ErrorStruct(title: "This is embarrassing, an error happened", message: "Please, try it again", errorType: nil)
    }
}

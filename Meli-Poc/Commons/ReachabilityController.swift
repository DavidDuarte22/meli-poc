//
//  ReachabilityController.swift
//  Meli-Poc
//
//  Created by David Duarte on 13/09/2019.
//  Copyright © 2019 David Duarte. All rights reserved.
//

import SystemConfiguration
import Foundation

// Reachability network class.
// We'll use as a middleware before all http request to provide an earlier response to the user if it isn't connect
class ReachabilityController {
    private let reachability = SCNetworkReachabilityCreateWithName(nil, Bundle.main.infoDictionary?["MELI_API_ENDPOINT"] as! String)
    
    public func checkReachable() throws -> MeliError? {
        var flags = SCNetworkReachabilityFlags()
        SCNetworkReachabilityGetFlags(self.reachability!, &flags)
        
        if(isNetworkReachable(with: flags)) {
            if flags.contains(.isWWAN) {
                return nil
            }
            return nil
        } else if(!isNetworkReachable(with: flags)){
            print(flags)
            throw MeliError.networkError
        }
        throw MeliError.networkError
    }
    
    private func isNetworkReachable(with flags: SCNetworkReachabilityFlags) -> Bool {
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        let canConnectAutomatically = flags.contains(.connectionOnDemand) || flags.contains(.connectionOnTraffic)
        let canConnectWithoutInteraction = canConnectAutomatically && !flags.contains(.interventionRequired)
        return isReachable && (!needsConnection || canConnectWithoutInteraction)
    }
}

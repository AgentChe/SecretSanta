//
//  ShareDataRequest.swift
//  SecretSanta
//
//  Created by Андрей Чернышев on 12.12.2025.
//

import Alamofire

struct ShareDataRequest {
    let pairs: [String: URL]
    
    var url: String {
        GlobalDefinitions.domain + "/api/v1/send"
    }
    
    var body: [String: URL] {
        pairs
    }
}

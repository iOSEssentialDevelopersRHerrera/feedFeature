//
//  HTTPClient.swift
//  EssentialFeed
//
//  Created by Ricardo Herrera Petit on 12/1/19.
//  Copyright © 2019 Ricardo Herrera Petit. All rights reserved.
//

import Foundation

public enum HTTPClientResult {
    case success(Data, HTTPURLResponse)
    case failure(Error)
}

public protocol HttpClient {
    func get(from url:URL, completion: @escaping (HTTPClientResult) -> Void)
}

//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Ricardo Herrera Petit on 11/4/19.
//  Copyright © 2019 Ricardo Herrera Petit. All rights reserved.
//

import XCTest

class RemoteFeedLoader {
    
}

class HttpClient {
    var requestedURL: URL?
}

class RemoteFeedLoaderTests: XCTestCase {
    
    func test_init_doesNotrequestDataFromURL() {
        let client = HttpClient()
        _ = RemoteFeedLoader()
        
        XCTAssertNil(client.requestedURL)
    }
   
}

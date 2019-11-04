//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Ricardo Herrera Petit on 11/4/19.
//  Copyright © 2019 Ricardo Herrera Petit. All rights reserved.
//

import XCTest

class RemoteFeedLoader {
    func load() {
        HttpClient.shared.get(from: URL(string: "https://a-url.com")!)
    }
}

class HttpClient {
    static var shared = HttpClient()
    func get(from url:URL) { }
    
}

class HttpClientSpy : HttpClient {
   override func get(from url:URL) {
           requestedURL = url
       }
       
       var requestedURL: URL?
}

class RemoteFeedLoaderTests: XCTestCase {
    
    func test_init_doesNotrequestDataFromURL() {
        let client = HttpClientSpy()
        HttpClient.shared = client
        _ = RemoteFeedLoader()
        
        XCTAssertNil(client.requestedURL)
    }
   
    func test_load_requestDataFromURL() {
        let client = HttpClientSpy()
        HttpClient.shared = client
        let sut = RemoteFeedLoader()
        
        sut.load()
        
        XCTAssertNotNil(client.requestedURL)
    }
}

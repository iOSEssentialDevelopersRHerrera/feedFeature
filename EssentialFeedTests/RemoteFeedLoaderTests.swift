//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Ricardo Herrera Petit on 11/4/19.
//  Copyright © 2019 Ricardo Herrera Petit. All rights reserved.
//

import XCTest

class RemoteFeedLoader {
    let client:HttpClient
    init(client:HttpClient) {
        self.client = client
    }
    func load() {
        client.get(from: URL(string: "https://a-url.com")!)
    }
}

protocol HttpClient {
    func get(from url:URL)
}

class HttpClientSpy : HttpClient {
    func get(from url:URL) {
           requestedURL = url
       }
       
       var requestedURL: URL?
}

class RemoteFeedLoaderTests: XCTestCase {
    
    func test_init_doesNotrequestDataFromURL() {
        let client = HttpClientSpy()
        _ = RemoteFeedLoader(client: client)
        
        XCTAssertNil(client.requestedURL)
    }
   
    func test_load_requestDataFromURL() {
        let client = HttpClientSpy()
        let sut = RemoteFeedLoader(client:client)
        
        sut.load()
        
        XCTAssertNotNil(client.requestedURL)
    }
}

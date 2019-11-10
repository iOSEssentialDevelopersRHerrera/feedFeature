//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Ricardo Herrera Petit on 11/4/19.
//  Copyright © 2019 Ricardo Herrera Petit. All rights reserved.
//

import XCTest
import EssentialFeed

class RemoteFeedLoaderTests: XCTestCase {
    
    func test_init_doesNotrequestDataFromURL() {
        let (_, client) = makeSUT()
        
        XCTAssertNil(client.requestedURL)
    }
    
    func test_load_requestDataFromURL() {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)
        
        sut.load()
        
        XCTAssertEqual(client.requestedURL, url)
    }
    
    //MARK: - Helpers
    private func makeSUT(url: URL =  URL(string: "https://a-url.com")!) -> (sut:RemoteFeedLoader, client:HttpClientSpy) {
        let client = HttpClientSpy()
        let sut = RemoteFeedLoader(url: url, client:client)
        return (sut, client)
    }
    
    private class HttpClientSpy : HttpClient {
        var requestedURL: URL?
        func get(from url:URL) {
            requestedURL = url
        }
    }
}

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
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_load_requestsDataFromURL() {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)
        
        sut.load()
        
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_loadTwice_requestsDataFromURLTwice() {
          let url = URL(string: "https://a-given-url.com")!
          let (sut, client) = makeSUT(url: url)
          
          sut.load()
          sut.load()
          
          
          XCTAssertEqual(client.requestedURLs, [url, url])
      }
    
    func test_load_deiversErrorOnClientError() {
        let (sut, client) = makeSUT()
        client.error = NSError(domain: "Test", code: 0)
        var capturedError: RemoteFeedLoader.Error?
        sut.load() { error in capturedError = error }
        XCTAssertEqual(capturedError, .connectivity)
    }
    
    //MARK: - Helpers
    private func makeSUT(url: URL =  URL(string: "https://a-url.com")!) -> (sut:RemoteFeedLoader, client:HttpClientSpy) {
        let client = HttpClientSpy()
        let sut = RemoteFeedLoader(url: url, client:client)
        return (sut, client)
    }
    
    private class HttpClientSpy : HttpClient {
        var requestedURLs = [URL]()
        var error: Error?
        
        func get(from url:URL, completion: @escaping (Error) -> Void) {
            if let error = error {
                completion(error)
            }
            requestedURLs.append(url)
            
        }
    }
}

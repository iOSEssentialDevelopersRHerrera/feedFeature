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
        
        sut.load()  { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_loadTwice_requestsDataFromURLTwice() {
          let url = URL(string: "https://a-given-url.com")!
          let (sut, client) = makeSUT(url: url)
          
          sut.load()   { _ in }
          sut.load()  { _ in }
          
          
          XCTAssertEqual(client.requestedURLs, [url, url])
      }
    
    func test_load_deiversErrorOnClientError() {
        let (sut, client) = makeSUT()
        
        var capturedErrors = [RemoteFeedLoader.Error]()
        sut.load() { capturedErrors.append($0) }
        
        let clientError = NSError(domain: "Test", code: 0)
        
        client.complete(with: clientError)
        
        XCTAssertEqual(capturedErrors, [.connectivity])
    }
    
    
       func test_load_deiversErrorOnNon200HttpResponse() {
           let (sut, client) = makeSUT()
           
           var capturedErrors = [RemoteFeedLoader.Error]()
           sut.load() { capturedErrors.append($0) }
           
        
           client.complete(withStatusCode: 400)
           
           XCTAssertEqual(capturedErrors, [.invalidData])
       }
    
    
    //MARK: - Helpers
    private func makeSUT(url: URL =  URL(string: "https://a-url.com")!) -> (sut:RemoteFeedLoader, client:HttpClientSpy) {
        let client = HttpClientSpy()
        let sut = RemoteFeedLoader(url: url, client:client)
        return (sut, client)
    }
    
    private class HttpClientSpy : HttpClient {
        private var messages = [(url: URL, completion: (Error?, HTTPURLResponse?) -> Void)]()
        
        var requestedURLs:[URL] {
            return messages.map { $0.url }
        }
        
        func get(from url:URL, completion: @escaping (Error?, HTTPURLResponse?) -> Void) {
            messages.append((url, completion))
            
        }
        
        func complete(with error: Error, at index:Int = 0) {
            messages[index].completion(error, nil)
        }
        
        func complete(withStatusCode code: Int, at index:Int = 0) {
            let response = HTTPURLResponse(url: requestedURLs[index],
                        statusCode: code,
                        httpVersion: nil,
                        headerFields: nil)
            
            messages[index].completion(nil, response)
        }
    }
    
}

import XCTest
import EssentialFeed

class ValidateFeedCacheUseCaseTests: XCTestCase {
    
    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) =  makeSUT()
        XCTAssertEqual(store.receivedMessages, [])
    }
    
    func test_validateCAche_deletesCacheOnRetrievalError() {
        let (sut, store) = makeSUT()
        
        sut.validateCache()
        store.completeRetrieval(with: anyNSError())
        
        XCTAssertEqual(store.receivedMessages, [.retrieve, .deleteCachedFeed])
    }
    
    func test_validateCache_doesNotdeleteCacheOnEmptyCache() {
        let (sut, store) = makeSUT()
        
        sut.validateCache()
        store.completeRetrievalWithEmptyCache()
        
        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }
    
    func test_validateCache_doesNotdeleteCacheLessThanSevenDaysOldCache() {
        let feed = uniqueImageFeed()
        let fixedCurrentDate = Date()
        let lessThanSevenDaysOldTimestamp = fixedCurrentDate.adding(days: -7).adding(seconds: 1)
        let (sut, store) =  makeSUT(currentDate: { fixedCurrentDate })
        
        sut.validateCache()
        store.completeRetrieval(with: feed.local, timestamp: lessThanSevenDaysOldTimestamp)
        
        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }
    
    func test_validateCache_deletesOnSevenDaysOldCache() {
         let feed = uniqueImageFeed()
         let fixedCurrentDate = Date()
         let sevenDaysOldTimestamp = fixedCurrentDate.adding(days: -7)
         let (sut, store) =  makeSUT(currentDate: { fixedCurrentDate })
         
        sut.validateCache()
         store.completeRetrieval(with: feed.local, timestamp: sevenDaysOldTimestamp)
         
        XCTAssertEqual(store.receivedMessages, [.retrieve, .deleteCachedFeed])
     }
    
    func test_validateCache_deletesOnMoreThanSevenDaysOldCache() {
            let feed = uniqueImageFeed()
            let fixedCurrentDate = Date()
            let moreTahnSevenDaysOldTimestamp = fixedCurrentDate.adding(days: -7).adding(seconds: -1)
            let (sut, store) =  makeSUT(currentDate: { fixedCurrentDate })
            
            sut.validateCache()
            store.completeRetrieval(with: feed.local, timestamp: moreTahnSevenDaysOldTimestamp)
            
        XCTAssertEqual(store.receivedMessages, [.retrieve, .deleteCachedFeed])
    }
    
    func test_validateCache_doesNotdelteInvalidCacheAfterSUTInstancehasbeenDeallocated() {
        let store = FeedStoreSpy()
        var sut: LocalFeedLoader? = LocalFeedLoader(store: store, currentDate: Date.init)
        
        sut?.validateCache()
        
        sut = nil
        store.completeRetrieval(with: anyNSError())

        
        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }
    
    //MARK - Helpers
    private func makeSUT(currentDate: @escaping () -> Date = Date.init,  file: StaticString = #file, line:UInt = #line) -> (sut: LocalFeedLoader, store: FeedStoreSpy) {
        let store = FeedStoreSpy()
        let sut = LocalFeedLoader(store: store, currentDate: currentDate)
        trackForMemoryLeaks(store, file: file, line:line)
        trackForMemoryLeaks(sut, file: file, line:line)
        return (sut, store)
    }
    
  
}



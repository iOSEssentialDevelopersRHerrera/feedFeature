import XCTest

extension XCTestCase  {
     func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #file, line: UInt = #line) {
           addTeardownBlock { [weak instance] in
               XCTAssertNil(instance, "Instance should have been deallocated. Potentuak memory leak", file: file, line: line)
           }
       }
}

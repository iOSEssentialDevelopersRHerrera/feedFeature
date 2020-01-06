import Foundation

public enum HTTPClientResult {
    case success(Data, HTTPURLResponse)
    case failure(Error)
}

public protocol HttpClient {
    ///The completion handler can be invoke in any thread.
    /// Clients are repsonisble to dispatch to appropiate threads if needed.
    func get(from url:URL, completion: @escaping (HTTPClientResult) -> Void)
}

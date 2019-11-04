//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Ricardo Herrera Petit on 11/4/19.
//  Copyright © 2019 Ricardo Herrera Petit. All rights reserved.
//

import Foundation

enum LoadFeedResult {
    case success([FeedItem])
    case error(Error)
}

protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> Void)
}

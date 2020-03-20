//
//  RouteContextCache.swift
//  
//
//  Created by Mathew Polzin on 3/20/20.
//

import Foundation
import VaporTypedRoutes

struct RouteContextKey<T: RouteContext>: Hashable {
    public typealias Context = T

    public func hash(into hasher: inout Hasher) {
        hasher.combine("\(String(reflecting: Context.self))_key")
    }
}

extension RouteContext {
    static var key: RouteContextKey<Self> { .init() }
}

class RouteContextCache {
    private var cache: [AnyHashable: Any]

    private init() { cache = [:] }

    private subscript<T: RouteContext>(key: RouteContextKey<T>, default default: () -> T) -> T {

        if let shared = cache[key] as? T {
            return shared
        }

        let shared = `default`()
        self.cache[key] = shared
        return shared
    }

    private static let shared: RouteContextCache = RouteContextCache()

    public static subscript<T: RouteContext>(key: RouteContextKey<T>, default default: @autoclosure () -> T) -> T {
        return shared[key, default: `default`]
    }
}

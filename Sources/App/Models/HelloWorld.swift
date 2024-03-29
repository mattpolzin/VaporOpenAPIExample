//
//  HelloWorld.swift
//  
//
//  Created by Mathew Polzin on 12/28/19.
//

import Foundation
import Vapor
import Sampleable
import OpenAPIKit
import OpenAPIReflection

struct HelloWorld: Codable {

    let language: Language
    let greeting: String

    init(language: Language) {
        self.language = language
        switch language {
        case .english:
            greeting = "Hello World!"
        case .spanish:
            greeting = "¡Hola Mundo!"
        }
    }

    enum Language: String, CaseIterable, AnyJSONCaseIterable, Codable {
        case english
        case spanish

        static var allCasesString: String {
            Self.allCases.map { $0.rawValue }.joined(separator: ", ")
        }
    }
}

extension HelloWorld: ResponseEncodable {
    func encodeResponse(for request: Request) -> EventLoopFuture<Response> {
        return request.eventLoop
            .makeSucceededFuture(())
            .flatMapThrowing {
                try Response(body: .init(data: JSONEncoder().encode(self)))
        }
    }
}

extension HelloWorld: AsyncResponseEncodable {
    func encodeResponse(for request: Request) async throws -> Response {
        try Response(body: .init(data: JSONEncoder().encode(self)))
    }
}

extension HelloWorld: Sampleable {
    static var sample: HelloWorld {
        .init(language: .english)
    }
}

extension HelloWorld: OpenAPIEncodedSchemaType {
    static func openAPISchema(using encoder: JSONEncoder) throws -> JSONSchema {
        return try genericOpenAPISchemaGuess(using: encoder)
    }
}

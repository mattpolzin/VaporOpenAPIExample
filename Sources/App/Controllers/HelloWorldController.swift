//
//  HelloWorldController.swift
//  
//
//  Created by Mathew Polzin on 12/28/19.
//

import Vapor
import VaporOpenAPI

final class HelloWorldController {
    static func show(_ req: TypedRequest<ShowContext>) -> EventLoopFuture<Response> {
        let requestedLanguage = req.query.language
            .flatMap { HelloWorld.Language(rawValue: $0) }

        guard let language = requestedLanguage else {
            return req.response.unavailableLanguage
        }

        return req
            .response
            .success
            .encode(.init(language: language))
    }

    static func create(_ req: TypedRequest<CreateContext>) -> EventLoopFuture<Response> {
        // does not actually do anything, sorry to say.

        return req
            .response
            .success
            .encode(.init(language: .english))
    }

    static func delete(_ req: TypedRequest<DeleteContext>) -> EventLoopFuture<Response> {
        // also does not actually perform a DELETE

        return req
            .response
            .success
            .encodeEmptyResponse()
    }
}

// MARK: - Contexts
extension HelloWorldController {
    struct ShowContext: RouteContext {
        typealias RequestBodyType = EmptyRequestBody

        static let defaultContentType: HTTPMediaType? = nil
        static let shared = Self()

        let language: StringQueryParam = .init(
            name: "language",
            defaultValue: HelloWorld.Language.english.rawValue,
            allowedValues: HelloWorld.Language.allCases.map { $0.rawValue }
        )

        let success: ResponseContext<HelloWorld> = .init { response in
            response.headers.contentType = .json
            response.status = .ok
        }

        let unavailableLanguage: CannedResponse<String> = .init(
            response: Response(
                status: .badRequest,
                headers: ["Content-Type": "text/plain"],
                body: .init(
                    string: "The only available languages are \(HelloWorld.Language.allCasesString)")
            )
        )
    }

    struct CreateContext: RouteContext {
        typealias RequestBodyType = HelloWorld

        static let defaultContentType: HTTPMediaType? = nil
        static let shared = Self()

        let success: ResponseContext<HelloWorld> = .init { response in
            response.headers.contentType = .json
            response.status = .created
        }
    }

    struct DeleteContext: RouteContext {
        typealias RequestBodyType = EmptyRequestBody

        static let defaultContentType: HTTPMediaType? = nil
        static let shared = Self()

        let success: ResponseContext<EmptyResponseBody> = .init { response in
            response.status = .noContent
        }
    }
}

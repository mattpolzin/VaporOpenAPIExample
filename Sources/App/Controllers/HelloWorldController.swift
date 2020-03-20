//
//  HelloWorldController.swift
//  
//
//  Created by Mathew Polzin on 12/28/19.
//

import Vapor
import VaporOpenAPI

final class HelloWorldController {
    func show(_ req: TypedRequest<ShowContext>) -> EventLoopFuture<Response> {
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

    func create(_ req: TypedRequest<CreateContext>) -> EventLoopFuture<Response> {
        // does not actually do anything, sorry to say.

        return req
            .response
            .success
            .encode(.init(language: .english))
    }
}

// MARK: - Contexts
extension HelloWorldController {
    struct ShowContext: RouteContext {
        typealias RequestBodyType = EmptyRequestBody

        static var shared: Self { RouteContextCache[key, default: Self()] }

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

        static var shared: Self { RouteContextCache[key, default: Self()] }

        let success: ResponseContext<HelloWorld> = .init { response in
            response.headers.contentType = .json
            response.status = .created
        }
    }
}

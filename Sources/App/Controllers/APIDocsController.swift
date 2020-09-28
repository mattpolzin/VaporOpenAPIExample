//
//  APIDocsController.swift
//  
//
//  Created by Mathew Polzin on 12/28/19.
//

import Vapor
import VaporOpenAPI
import Foundation
import Yams

final class APIDocsController {

    let app: Application

    init(app: Application) {
        self.app = app
    }

    func view(_ req: TypedRequest<ViewContext>) -> EventLoopFuture<Response> {
        let html =
        """
        <!DOCTYPE html>
        <html>
          <head>
            <title>ReDoc</title>
            <!-- needed for adaptive design -->
            <meta charset="utf-8"/>
            <meta name="viewport" content="width=device-width, initial-scale=1">
            <link href="https://fonts.googleapis.com/css?family=Montserrat:300,400,700|Roboto:300,400,700" rel="stylesheet">

            <!--
            ReDoc doesn't change outer page styles
            -->
            <style>
              body {
                margin: 0;
                padding: 0;
              }
            </style>
          </head>
          <body>
            <redoc spec-url='/docs/openapi.yml'></redoc>
            <script src="https://cdn.jsdelivr.net/npm/redoc@next/bundles/redoc.standalone.js"> </script>
          </body>
        </html>
        """

        return req.response.success.encode(html)
    }

    func show(_ req: TypedRequest<ShowContext>) throws -> EventLoopFuture<Response> {

        // TODO: Add support for ContentEncoder to JSONAPIOpenAPI
        let jsonEncoder = JSONEncoder()
        if #available(macOS 10.12, *) {
            jsonEncoder.dateEncodingStrategy = .iso8601
            jsonEncoder.outputFormatting = .sortedKeys
        }
        #if os(Linux)
        jsonEncoder.dateEncodingStrategy = .iso8601
        jsonEncoder.outputFormatting = .sortedKeys
        #endif

        let info = OpenAPI.Document.Info(
            title: "Vapor OpenAPI Example API",
            description:
            ###"""
            ## Descriptive Text
            This text supports _markdown_!
            """###,
            version: "1.0"
        )

        let servers = [
            OpenAPI.Server(url: URL(string: "https://\(app.http.server.configuration.hostname)")!)
        ]

        let paths = try app.routes.openAPIPathItems(using: jsonEncoder)

        let document = OpenAPI.Document(
            info: info,
            servers: servers,
            paths: paths,
            components: .noComponents,
            security: []
        )

        return req
            .response
            .success
            .encode(try YAMLEncoder().encode(document))
    }
}

// MARK: - Contexts
extension APIDocsController {
    struct ShowContext: RouteContext {
        typealias RequestBodyType = EmptyRequestBody

        static let defaultContentType: HTTPMediaType? = nil
        static let shared = Self()

        let success: ResponseContext<String> = .init { response in
            response.headers.contentType = .init(type: "application", subType: "x-yaml")
            response.status = .ok
        }
    }

    struct ViewContext: RouteContext {
        typealias RequestBodyType = EmptyRequestBody

        static let defaultContentType: HTTPMediaType? = nil
        static let shared = Self()

        let success: ResponseContext<String> = .init { response in
            response.headers.contentType = .html
            response.status = .ok
        }
    }
}

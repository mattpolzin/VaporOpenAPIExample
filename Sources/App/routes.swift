import Vapor

func routes(_ app: Application) throws {
    let apiDocsController = APIDocsController(app: app)

    app.get("docs", use: apiDocsController.view)
        .summary("View API Documentation")
        .description("API Documentation is served using the Redoc web app.")
        .tags("Documentation")

    app.get("docs", "openapi.yml", use: apiDocsController.show)
        .summary("Download API Documentation")
        .description("Retrieve the OpenAPI documentation as a YAML file.")
        .tags("Documentation")


    app.get("hello", use: HelloWorldController.show)
        .summary("View a greeting")
        .description("Say hello in one of the supported languages!")
        .tags("Greetings")

    app.post("hello", use: HelloWorldController.create)
        .summary("Create a greeting")
        .description("The endpoint is not actually implemented. It is just mocked up.")
        .tags("Greetings")

    app.delete("hello", use: HelloWorldController.delete)
        .summary("Delete a greeting")
        .tags("Greetings")
}

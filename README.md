# VaporOpenAPIExample

This example shows off an early stage project to both add type information to Vapor requests/responses and also take advantage of that information to generate OpenAPI documentation.

Note that this app and the libraries it showcases are built off of Vapor 4.

The example app serves up OpenAPI documentation on itself using the beautiful Redoc viewer.

The OpenAPI document produced is compatible with the OpenAPI specification v3.1.x.

![Documentation served by example app](./Screen%20Shot%202019-12-28%20at%207.18.48%20PM.png)

The OpenAPI it produces contains (among other things) routes, path and query parameters, and success and error responses including response body schemas.

```yaml
openapi: 3.0.0
info:
  title: Vapor OpenAPI Example API
  description: '## Descriptive Text

    This text supports _markdown_!'
  version: '1.0'
servers:
- url: https://127.0.0.1
paths:
  /docs:
    get:
      tags:
      - Documentation
      summary: View API Documentation
      description: API Documentation is served using the Redoc web app.
      responses:
        200:
          description: OK
          content:
            text/html:
              schema:
                type: string
  /docs/openapi.yml:
    get:
      tags:
      - Documentation
      summary: Download API Documentation
      description: Retrieve the OpenAPI documentation as a YAML file.
      responses:
        200:
          description: OK
          content:
            application/x-yaml:
              schema:
                type: string
  /hello:
    get:
      tags:
      - Greetings
      summary: View a greeting
      description: Say hello in one of the supported languages!
      parameters:
      - name: language
        in: query
        schema:
          type: string
          enum:
          - english
          - spanish
      responses:
        200:
          description: OK
          content:
            application/json:
              schema:
                type: object
                properties:
                  greeting:
                    type: string
                  language:
                    type: string
                    enum:
                    - english
                    - spanish
                required:
                - greeting
                - language
        400:
          description: Bad Request
          content:
            text/plain:
              schema:
                type: string
    post:
      tags:
      - Greetings
      summary: Create a greeting
      description: The endpoint is not actually implemented. It is just mocked up.
      requestBody:
        content:
          application/json:
            schema:
              type: object
              properties:
                language:
                  type: string
                  enum:
                  - english
                  - spanish
                greeting:
                  type: string
              required:
              - greeting
              - language
      responses:
        201:
          description: Created
          content:
            application/json:
              schema:
                type: object
                properties:
                  greeting:
                    type: string
                  language:
                    type: string
                    enum:
                    - english
                    - spanish
                required:
                - greeting
                - language
    delete:
      tags:
      - Greetings
      summary: Delete a greeting
      responses:
        204:
          description: No Content
```

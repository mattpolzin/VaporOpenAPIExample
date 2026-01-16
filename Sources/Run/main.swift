import App
import Vapor

var env = try Environment.detect()
try LoggingSystem.bootstrap(from: &env)
let app = try await Application.make(env)
try configure(app)
try await app.execute()
try await app.asyncShutdown()

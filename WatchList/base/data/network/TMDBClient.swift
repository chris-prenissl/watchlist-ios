import OpenAPIRuntime
import Foundation
import OpenAPIURLSession

class TMDBClient {
    let client: Client

    init() {
        guard let url = Bundle.main.url(forResource: "Secrets", withExtension: "plist"),
                      let data = try? Data(contentsOf: url),
                      let plist = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil),
                      let secretsDict = plist as? [String: Any] else {
                    fatalError("Failed to load Secrets.plist")
                }
        let authMiddleware = BearerTokenMiddleware(
            bearerToken: secretsDict["TMDB_API_KEY"] as! String
        )
        self.client = Client(
            serverURL: try! Servers.Server1.url(),
            transport: URLSessionTransport(),
            middlewares: [authMiddleware]
        )
    }
}

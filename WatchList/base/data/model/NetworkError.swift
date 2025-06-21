import Foundation

enum NetworkError: Error, LocalizedError, Equatable {
    case invalidResponse
    case httpError(statusCode: Int)
    case networkError(URLError)
    case unknownError(Error)

    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return NSLocalizedString("error_invalid_response", comment: "Invalid response from server")
        case .httpError(let statusCode):
            return String(format: NSLocalizedString("error_http_status", comment: "HTTP error with status code"), statusCode)
        case .networkError(let error):
            return String(format: NSLocalizedString("error_network", comment: "Network error occurred"), error.localizedDescription)
        case .unknownError(let error):
            return String(format: NSLocalizedString("error_unknown", comment: "Unknown error occurred"), error.localizedDescription)
        }
    }
    
    static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        lhs.localizedDescription == rhs.localizedDescription
    }
}

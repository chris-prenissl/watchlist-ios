import Foundation
import Combine
import OpenAPIRuntime
import OpenAPIURLSession

class SearchViewModel: ObservableObject {
    private let searchRepository: SearchRepository
    
    @Published var movieSearchItems: [MovieSearchItem] = []
    private var cancellables: Set<AnyCancellable> = []
    
    init(searchRepository: SearchRepository) {
        self.searchRepository = searchRepository
    }
    
    func searchMovies(query: String) async {
        do {
            let result = try await searchRepository.search(query: query)
            await MainActor.run {
                movieSearchItems = result
            }
        } catch {
            print("Error: \(error)")
        }
    }
}

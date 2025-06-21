import Combine
import Foundation

@Observable
class SearchViewModel: ObservableObject {
    private let searchRepository: SearchRepository

    var state: ViewState
    var movieSearchItems: [MovieSearchItem] = []

    init(
        searchRepository: SearchRepository,
        state: ViewState = .loaded,
        movieSearchItems: [MovieSearchItem] = [],
    ) {
        self.searchRepository = searchRepository
        self.state = state
        self.movieSearchItems = movieSearchItems
    }

    func searchMovies(query: String) async {
        let trimmedQuery = query.trimmingCharacters(in: .whitespaces)
        if trimmedQuery.isEmpty {
            await MainActor.run {
                movieSearchItems = []
                state = .loaded
            }
            return
        }

        do {
            await MainActor.run {
                state = .loading
            }
            let result = try await searchRepository.search(query: trimmedQuery)

            await MainActor.run {
                movieSearchItems = result
                state = .loaded
            }
        } catch let error as NetworkError {
            await MainActor.run {
                state = .error(error.localizedDescription)
            }
        } catch {
            await MainActor.run {
                state = .error("An unknown error occurred.")
            }
        }
    }
}

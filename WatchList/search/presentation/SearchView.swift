import SwiftUI

struct SearchView: View {
    @State private var searchText = ""
    @Environment(SearchViewModel.self) private var viewModel

    var body: some View {
        NavigationView {
            List(viewModel.movieSearchItems) { movie in
                VStack {
                    Text(movie.title)
                    Text(movie.description)
                }
            }
            .searchable(text: $searchText, prompt: "Search movie")
            .onChange(of: searchText) {
                Task {
                    await viewModel.searchMovies(query: searchText)
                }
            }
        }
    }
}

#Preview {
    SearchView()
        .environment(
            SearchViewModel(
                movieSearchItems: [
                    MovieSearchItem(
                        id: 1,
                        title: "Title",
                        description: "Description"
                    ),
                    MovieSearchItem(
                        id: 2,
                        title: "Matrix",
                        description: "Epic sci-fi action film"
                    )
                ],
                searchRepository: SearchRepository(
                    client: PreviewSearchClient()
                )
            )
        )
}

struct PreviewSearchClient: TMDBClientProtocol {
    func searchMovie(query: String) async -> [MovieSearchItemDto] {
        [MovieSearchItemDto(id: 1, title: "Title", overview: "Overview")]
    }
}

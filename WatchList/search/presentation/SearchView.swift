import SwiftUI

struct SearchView: View {
    @State private var searchText = ""
    @Environment(SearchViewModel.self) private var viewModel

    var body: some View {
        NavigationView {
            VStack {
                switch viewModel.state {
                case .loading:
                    ProgressView(.loading)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                case .loaded:
                    List(viewModel.movieSearchItems) { movie in
                        SearchItemView(movieSearchItem: movie)
                    }
                case .error(let errorText):
                    Label(
                        errorText,
                        systemImage: "exclamationmark.triangle.fill"
                    )
                    .foregroundStyle(.yellow)
                }
            }
            .searchable(text: $searchText, prompt: .searchMovie)
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
                searchRepository: SearchRepository(
                    client: PreviewSearchClient()
                ),
                movieSearchItems: [
                    MovieSearchItem(
                        id: 1,
                        title: "Title",
                        description: "Description"
                    )
                ]
            )
        )
}

#Preview("Loading") {
    SearchView()
        .environment(
            SearchViewModel(
                searchRepository: SearchRepository(
                    client: PreviewSearchClient()
                ),
                state: .loading,
            )
        )
}

#Preview("Error") {
    SearchView()
        .environment(
            SearchViewModel(
                searchRepository: SearchRepository(
                    client: PreviewSearchClient()
                ),
                state: .error("An error occurred"),
            )
        )
}

struct PreviewSearchClient: TMDBClientProtocol {
    func searchMovie(query: String) async -> [MovieSearchItemDto] {
        [MovieSearchItemDto(id: 1, title: "Title", overview: "Overview")]
    }
}

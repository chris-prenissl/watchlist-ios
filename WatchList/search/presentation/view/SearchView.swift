import SwiftUI

struct SearchView: View {
    @Binding var searchText: String
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
                            .swipeActions(
                                edge: .trailing,
                                allowsFullSwipe: false
                            ) {
                                Button {
                                    debugPrint("TODO: implement")
                                } label: {
                                    Label(
                                        .toWatchlist,
                                        systemImage: "plus.rectangle"
                                    )
                                }.tint(.blue)
                            }
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
            .searchToolbarBehavior(.minimize)
            .onChange(of: searchText) {
                Task {
                    await viewModel.searchMovies(query: searchText)
                }
            }
        }
    }
}

#Preview {
    SearchView(searchText: .constant("Matrix"))
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
    SearchView(searchText: .constant("Matrix"))
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
    SearchView(searchText: .constant("Matrix"))
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
        [
            MovieSearchItemDto(
                id: 1,
                title: "Title",
                overview: "Overview",
                posterPath: nil
            )
        ]
    }
}

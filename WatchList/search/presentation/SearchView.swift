import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel(
        searchRepository: SearchRepository(client:TMDBClient())
    )
    @State private var searchText = ""

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
}

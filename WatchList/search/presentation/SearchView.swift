import SwiftUI

struct Movie: Identifiable, Hashable {
    let id = UUID()
    let title: String
}

struct SearchView: View {
    @State private var searchText = ""
    @State private var selectedMovie: Movie?
    
    let movies = [
        Movie(title: "The Shawshank Redemption"),
        Movie(title: "The Godfather"),
        Movie(title: "The Dark Knight"),
        Movie(title: "Pulp Fiction"),
        Movie(title: "Forrest Gump"),
        Movie(title: "Inception"),
        Movie(title: "Fight Club"),
        Movie(title: "The Matrix")
    ]
    
    var filteredMovies: [Movie] {
        if searchText.isEmpty {
            return movies
        } else {
            return movies.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        NavigationSplitView {
            List(filteredMovies, selection: $selectedMovie) { movie in
                NavigationLink(movie.title, value: movie)
            }
            .navigationTitle("Movies")
            .searchable(text: $searchText, prompt: "Search movie")
        } detail: {
            Text(selectedMovie?.title ?? "Select a movie")
        }
    }
}

#Preview {
    SearchView()
}

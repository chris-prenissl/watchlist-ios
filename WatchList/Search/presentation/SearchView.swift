//
//  SearchView.swift
//  WatchList
//
//  Created by Christoph Prenissl on 13.04.25.
//
import SwiftUI

struct Movie: Identifiable {
    let id = UUID()
    let title: String
}

struct SearchView: View {
    @State private var searchText = ""
    
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
        NavigationView {
            List(filteredMovies) { movie in
                Text(movie.title)
            }
            .navigationTitle("Movies")
            .searchable(text: $searchText, prompt: "Search movie")
        }
    }
}

#Preview {
    SearchView()
}

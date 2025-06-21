import SwiftUI
import SwiftData

@main
struct WatchListApp: App {
    @StateObject private var searchViewModel = SearchViewModel(
        searchRepository: SearchRepository(client: TMDBClient())
    )

    var body: some Scene {
        WindowGroup {
            SearchView()
                .environmentObject(searchViewModel)
        }
    }
}

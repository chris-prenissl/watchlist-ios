import SwiftUI

struct AppTabView: View {
    @State private var searchText: String = ""
    @StateObject private var searchViewModel = SearchViewModel(
        searchRepository: SearchRepository(client: TMDBClient())
    )
    var body: some View {
        TabView {
            Tab(role: .search) {
                SearchView(searchText: $searchText)
                    .environmentObject(searchViewModel)
            }
            Tab(.watchlist, systemImage: "list.bullet") {
                WatchListView()
            }
        }
        .searchable(text: $searchText)
    }
}

#Preview {
    AppTabView()
}

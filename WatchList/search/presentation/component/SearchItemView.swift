import SwiftUI

struct SearchItemView: View {
    private let movieSearchItem: MovieSearchItem
    
    init(movieSearchItem: MovieSearchItem) {
        self.movieSearchItem = movieSearchItem
    }
    
    var body: some View {
        VStack {
            Text(movieSearchItem.title)
            Text(movieSearchItem.description)
        }
    }
}

#Preview {
    SearchItemView(
        movieSearchItem: MovieSearchItem(id: 1, title: "Title", description: "Description")
    )
}

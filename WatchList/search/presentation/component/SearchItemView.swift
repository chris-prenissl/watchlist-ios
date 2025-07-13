import SwiftUI

struct SearchItemView: View {
    private let movieSearchItem: MovieSearchItem

    init(movieSearchItem: MovieSearchItem) {
        self.movieSearchItem = movieSearchItem
    }

    var body: some View {
        HStack {
            AsyncImage(url: movieSearchItem.thumbnailUrl) { image in
                image.resizable()
                    .frame(width: searchPosterWidth, height: searchPosterHeight)
                    .clipped()
                    .clipShape(
                        RoundedRectangle(cornerRadius: standardBorderRadius)
                    )
            } placeholder: {
                Color.gray
                    .frame(width: searchPosterWidth, height: searchPosterHeight)
                    .clipShape(
                        RoundedRectangle(cornerRadius: standardBorderRadius)
                    )
            }.frame(height: 100)
                .padding(standardPadding)
            VStack {
                Text(movieSearchItem.title)
                    .font(.title2)
                    .lineLimit(1)
                Text(movieSearchItem.description)
                    .font(.subheadline)
                    .lineLimit(2)
                    .padding(.top, standardPadding)
            }
        }
    }
}

#Preview {
    SearchItemView(
        movieSearchItem: MovieSearchItem(
            id: 1,
            title: "Title",
            description: "Description",
            thumbnailUrl: URL(
                string:
                    "https://image.stern.de/35822732/t/-m/v1/w1440/r1.7778/-/taylor-swift-baldoni.jpg",
            )
        )
    )
}

import Foundation

struct MovieSearchItemDto: Codable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?

    func toEntity() -> MovieSearchItem {
        return MovieSearchItem(
            id: id,
            title: title,
            description: overview,
            thumbnailUrl: self.posterPath != nil ? URL(
                string: TMDBSchema.moviePosterPath + self.posterPath!
            )! : nil
        )
    }
}

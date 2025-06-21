struct MovieSearchItemDto: Codable {
    let id: Int
    let title: String
    let overview: String

    func toEntity() -> MovieSearchItem {
        return MovieSearchItem(id: id, title: title, description: overview)
    }
}

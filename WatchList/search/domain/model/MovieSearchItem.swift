import Foundation

struct MovieSearchItem: Identifiable {
    let id: Int
    let title: String
    let description: String
    let thumbnailUrl: URL?
    
    init(id: Int, title: String, description: String, thumbnailUrl: URL? = nil) {
        self.id = id
        self.title = title
        self.description = description
        self.thumbnailUrl = thumbnailUrl
    }
}

import Foundation

extension Bundle {
    func loadProperty<T>(
        bundleKey: String,
        propertyKey: String,
        propertyType: T.Type
    ) throws -> T where T: Hashable {
        guard
            let bundleURL = self.url(
                forResource: bundleKey,
                withExtension: "plist"
            ),
            let data = try? Data(contentsOf: bundleURL),
            let propertyList =
                try? PropertyListSerialization.propertyList(
                    from: data,
                    options: [],
                    format: nil
                ),
            let propertyDict = propertyList as? [String: T],
            let property = propertyDict[propertyKey]
        else {
            throw BundleError.failedToLoadProperty
        }

        return property
    }
}

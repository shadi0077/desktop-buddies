import Foundation

/// Which app this build is.
///
/// One codebase, two products: Desktop Buddies is the two Microsoft Agent
/// characters, MegaDrive Buddies is the Streets of Rage cast. They share the
/// whole engine and differ only in who ships with them and what the app is
/// called, so the difference lives in a manifest rather than in a fork.
struct Product {
    let id: String
    let name: String
    let tagline: String
    let cast: [String]
    let credit: String

    /// The manifest bundled with this build.
    static let current: Product = {
        // Test tools run outside any app bundle, so they say which product
        // they're exercising; the app itself reads its own manifest.
        let override = ProcessInfo.processInfo.environment["BUDDY_PRODUCT"]
            .map(URL.init(fileURLWithPath:))
        guard let url = override
                ?? Bundle.main.url(forResource: "product", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let root = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let id = root["id"] as? String,
              let name = root["name"] as? String,
              let cast = root["cast"] as? [String]
        else {
            // A build with no manifest still runs, with whoever is bundled.
            return Product(id: "unknown", name: "Buddies", tagline: "",
                           cast: [], credit: "")
        }
        return Product(id: id, name: name,
                       tagline: root["tagline"] as? String ?? "",
                       cast: cast,
                       credit: root["credit"] as? String ?? "")
    }()

    /// True when this product ships nobody who can talk — which turns off the
    /// speech half of the menu rather than offering jokes to a gorilla with no
    /// mouth frames.
    var isSilent: Bool {
        !Personality.all.contains { $0.speaks }
    }
}

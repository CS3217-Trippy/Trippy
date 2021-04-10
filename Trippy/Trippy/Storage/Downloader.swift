import Foundation

struct Downloader {
    static func getData(from url: URL?, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        guard let url = url else {
            return
        }
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    static func getDataFromString(from url: String, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let targetURL = URL(string: url)
        getData(from: targetURL, completion: completion)
    }
}

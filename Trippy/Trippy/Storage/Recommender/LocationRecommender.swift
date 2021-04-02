import Combine
protocol LocationRecommender {
    var recommendedItems: Published<[Location]>.Publisher { get }
    func fetch()
}

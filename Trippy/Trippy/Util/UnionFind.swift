final class UnionFind {
    private var parent: [Int]

    init(numOfNodes: Int) {
        parent = [Int](0...numOfNodes - 1)
    }

    func findSet(_ element: Int) -> Int {
        if parent[element] != element {
            parent[element] = findSet(parent[element])
        }
        return parent[element]
    }

    func union(_ elementA: Int, _ elementB: Int) {
        let setA = findSet(elementA)
        let setB = findSet(elementB)
        parent[setA] = setB
    }
}

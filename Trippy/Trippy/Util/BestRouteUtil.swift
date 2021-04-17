//
//  BestRouteUtil.swift
//  Trippy
//
//  Created by Fidella Widjojo on 17/4/21.
//

import Foundation

struct Edge {
    let u: Int
    let v: Int
    let weight: Double
}

struct Neighbor {
    let label: Int
    let cost: Double
}

final class BestRouteUtil {
    let numOfNodes: Int
    var adjacencyList: [[Neighbor]] = []
    var edges: [Edge] = []
    var route: [Int] = []

    init(numOfNodes: Int) {
        self.numOfNodes = numOfNodes
    }

    func addEdge(edge: Edge) {
        edges.append(edge)
    }

    func getMST() {
        edges.sort(by: { $0.weight < $1.weight })
        let unionFind = UnionFind(numOfNodes: numOfNodes)

        for edge in edges {
            if unionFind.findSet(edge.u) != unionFind.findSet(edge.v) {
                adjacencyList[edge.u].append(.init(label: edge.v, cost: edge.weight))
                adjacencyList[edge.v].append(.init(label: edge.u, cost: edge.weight))
                unionFind.union(edge.u, edge.v)
            }
        }
    }

    func dfs(node: Int, prev: Int?) {
        route.append(node)
        for neighbor in adjacencyList[node] where neighbor.label != prev {
            dfs(node: neighbor.label, prev: node)
        }
    }

    func getBestRoute() -> [Int] {
        adjacencyList = [[Neighbor]](repeating: [], count: numOfNodes)
        getMST()
        route = []
        dfs(node: 0, prev: nil)
        return route
    }
}

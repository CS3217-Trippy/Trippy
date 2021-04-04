import Foundation
 @testable import Trippy

class MockUserRelatedStorage<Storable>: UserRelatedStorage where Storable: FBUserRelatedStorable {

    var userId: String?

    var storedItems: Published<[Storable.ModelType]>.Publisher {
        $_storedItems
    }
    @Published private var _storedItems: [Storable.ModelType] = []

    func fetch() {

    }

    func fetchWithId(id: String, handler: ((Storable.ModelType) -> Void)?) {

    }

    func fetchWithField(field: String, handler: (([Storable.ModelType]) -> Void)?) {

    }

    func add(item: Storable.ModelType) throws {
        _storedItems.append(item)
    }

    func update(item: Storable.ModelType) throws {
        _storedItems.removeAll { $0.id == item.id }
        _storedItems.append(item)
    }

    func remove(item: Storable.ModelType) {
        _storedItems.removeAll { $0.id == item.id }
    }

    typealias StoredType = Storable.ModelType

 }

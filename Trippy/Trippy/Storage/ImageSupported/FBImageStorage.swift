import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift
import Firebase

class FBImageStorage: ImageStorage {

    private let imageStorage = Firebase.Storage.storage()

    func add(with images: [TrippyImage], callback: (([String]) -> Void)? = nil) {
        var imageIds: [String] = []
        for image in images {
            let imageRef = imageStorage.reference().child(image.id + ".jpeg")
            let imageObj = image.image
            addImage(image: imageObj, imageRef: imageRef) { _, error in
                if let error = error {
                    print("Error during storing of image: \(error.localizedDescription)")
                }
                guard let callback = callback else {
                    return
                }
                imageIds.append(String(imageRef.name.split(separator: ".")[0]))
                if imageIds.count == images.count {
                    callback(imageIds)
                }
            }
    }
}

    func fetch(ids: [String], callback: @escaping ([UIImage]) -> Void) {
        var images: [UIImage] = []
        for id in ids {
            let imageRef = imageStorage.reference().child(id + ".jpeg")
            let maxSizeInBytes: Int64 = 20_971_520
            imageRef.getData(maxSize: maxSizeInBytes) {data, error in
                guard let data = data, error == nil else {
                    print("unable to retrieve image")
                    return
                }
                let image = UIImage(data: data)
                guard let nImage = image else {
                    return
                }
                images.append(nImage)
                if images.count == ids.count {
                    callback(images)
                }
            }
        }
    }

    private func addImage(image: UIImage, imageRef: StorageReference, completion: ((StorageMetadata?, Error?) -> Void)?) {
        guard let data = image.jpegData(compressionQuality: 0.1) else {
            return
        }
        imageRef.putData(data, metadata: nil, completion: completion)
    }

}

import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift
import Firebase

class FBImageStorage {
    private let imageStorage = Firebase.Storage.storage()

    func upload(images: [UIImage], callback: @escaping ([URL]) -> Void) {
        var imageUrls: [URL] = []
        for image in images {
            let imageRef = imageStorage.reference().child(UUID().uuidString + ".jpeg")
            addImage(image: image, imageRef: imageRef) { _, error in
                if let error = error {
                    print("Error during storing of image: \(error.localizedDescription)")
                    return
                }

                imageRef.downloadURL { url, error in
                    if let error = error {
                        print("Error during retrieval of image url: \(error.localizedDescription)")
                    }
                    if let url = url {
                        imageUrls.append(url)
                    }

                    if imageUrls.count == images.count {
                        callback(imageUrls)
                    }
                }
            }
        }
    }

    private func addImage(image: UIImage, imageRef: StorageReference,
                          completion: ((StorageMetadata?, Error?) -> Void)?) {
        guard let data = image.jpegData(compressionQuality: 0.1) else {
            return
        }
        imageRef.putData(data, metadata: nil, completion: completion)
    }

}

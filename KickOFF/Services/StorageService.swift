import FirebaseStorage
import UIKit

protocol StorageServiceProtocol: AnyObject {
    func uploadProfileImage(_ image: UIImage, uid: String) async throws -> String
    func deleteProfileImage(uid: String) async throws
}

final class StorageService: StorageServiceProtocol {
    static let shared = StorageService()
    private let storage = Storage.storage()
    
    private init() {}
    
    func uploadProfileImage(_ image: UIImage, uid: String) async throws -> String {
        
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            throw NSError(domain: "StorageService", code: 400, userInfo: [NSLocalizedDescriptionKey: "Failed to convert image to data"])
        }
        
        let imagePath = "profile_images/\(uid).jpg"
        let storageRef = storage.reference().child(imagePath)
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        _ = try await storageRef.putDataAsync(imageData, metadata: metadata)
        let downloadURL = try await storageRef.downloadURL()
        return downloadURL.absoluteString
    }
    
    func deleteProfileImage(uid: String) async throws {
        let imagePath = "profile_images/\(uid).jpg"
        let storageRef = storage.reference().child(imagePath)
        try await storageRef.delete()
    }
}

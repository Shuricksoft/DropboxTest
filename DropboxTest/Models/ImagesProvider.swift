//
//  ImagesCache.swift
//  DropboxTest
//
//  Created by Alexander Sokolenko on 30.08.2023.
//

import UIKit
import SwiftyDropbox

final class ImagesProvider: FilesMetadataProvider {
    
    private var imagesCache = [String : UIImage]()
    
    private let errorDomain = "ImagesProvider"
    
    func image(for path : String) async throws -> UIImage {
        if let img = imagesCache[path] {
            return img
        }
        guard let client = DropboxClientsManager.authorizedClient else {
            throw NSError(domain: errorDomain, code: 2)
        }
        let img : (Files.Metadata, UIImage) = try await withCheckedThrowingContinuation({
            continuation in
            client.files.download(path: path).response(completionHandler: {
                data, error in
                guard let data, let image = UIImage(data: data.1) else {
                    continuation.resume(throwing: NSError(domain: self.errorDomain, code: 1, userInfo: [NSLocalizedDescriptionKey : error?.description ?? NSLocalizedString("Unknown error", comment: "")]))
                    return
                }
                continuation.resume(returning: (data.0, image))
            })
        })
        
        imagesCache[path] = img.1
        updateMetadata(img.0, for: path)
        return img.1
    }
    
    

}

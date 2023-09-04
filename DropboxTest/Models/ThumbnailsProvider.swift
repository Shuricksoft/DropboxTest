//
//  ThumbnailsCache.swift
//  DropboxTest
//
//  Created by Alexander Sokolenko on 29.08.2023.
//

import UIKit
import SwiftyDropbox

final class ThumbnailsProvider: NSObject {
    
    private var cache = [String : UIImage]()
    
    func image(for path : String) async -> UIImage? {
        if let img = cache[path] {
            return img
        }
        let img : UIImage? = try? await withCheckedThrowingContinuation({
            continuation in
            DropboxClientsManager.authorizedClient?.files.getThumbnail(path: path).response(completionHandler: {
                data, error in
                guard let data else {
                    print("Failed to load thumbnail for \(path)")
                    continuation.resume(throwing: NSError(domain: "Thumbnail loading", code: 1))
                    return
                }
                continuation.resume(returning: UIImage(data: data.1))
            })
        })
        cache[path] = img
        return img
    }
}

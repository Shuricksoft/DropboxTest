//
//  FilesMetadataProvider.swift
//  DropboxTest
//
//  Created by Alexander Sokolenko on 01.09.2023.
//

import UIKit
import SwiftyDropbox

class FilesMetadataProvider: NSObject {
    
    private let errorDomain = "FilesMetadataProvider"
    
    private(set) var metadataCache = [String : (metadata: Files.Metadata, date: Date)]()
    
    func metadata(for path : String) async throws -> Files.Metadata {
        if let cacheItem = metadataCache[path], Date().timeIntervalSince(cacheItem.date) < 60 {
            return cacheItem.metadata
        }
        guard let client = DropboxClientsManager.authorizedClient else {
            throw NSError(domain: errorDomain, code: 2)
        }
        let metadata : Files.Metadata = try await withCheckedThrowingContinuation({
            continuation in
            client.files.getMetadata(path: path).response(completionHandler: {
                metadata, error in
                guard let metadata else {
                    continuation.resume(throwing: NSError(domain: self.errorDomain, code: 3, userInfo: [NSLocalizedDescriptionKey : error?.description ?? NSLocalizedString("Unknown error", comment: "")]))
                    return
                }
                continuation.resume(returning: metadata)
            })
        })
        metadataCache[path] = (metadata, Date())
        return metadata
    }
    
    func filesMetadata() async throws -> Array<Files.Metadata> {
        var metadataCache = Array<Files.Metadata>()
        var result : Files.ListFolderResult = try await withCheckedThrowingContinuation {
            continuation in
            DropboxClientsManager.authorizedClient?.files.listFolder(path: "").response(completionHandler: {
                result, error in
                /*if let error = error as? AuthError {
                    error == .expiredAccessToken
                }*/
                guard let result else {
                    continuation.resume(throwing: NSError(domain: self.errorDomain, code: 5, userInfo: [NSLocalizedDescriptionKey : error?.description ?? NSLocalizedString("Unknown error", comment: "")]))
                    return
                }
                continuation.resume(returning: result)
            })
        }
        let allowedExtensions = allowedImageExtensions + allowedVideoExtensions
        metadataCache += result.entries.filter({allowedExtensions.contains($0.name.components(separatedBy: ".").last?.lowercased() ?? "")})
        while result.hasMore {
            result = try await withCheckedThrowingContinuation {
                continuation in
                DropboxClientsManager.authorizedClient?.files.listFolderContinue(cursor: result.cursor).response(completionHandler: {
                    result, error in
                    guard let result else {
                        continuation.resume(throwing: NSError(domain: self.errorDomain, code: 5, userInfo: [NSLocalizedDescriptionKey : error?.description ?? NSLocalizedString("Unknown error", comment: "")]))
                        return
                    }
                    continuation.resume(returning: result)
                })
            }
            metadataCache += result.entries.filter({allowedExtensions.contains($0.name.components(separatedBy: ".").last?.lowercased() ?? "")})
        }
        return metadataCache
    }
    
    func updateMetadata(_ metadata : Files.Metadata, for path : String) {
        metadataCache[path] = (metadata, Date())
    }

}

//
//  DataModel.swift
//  DropboxTest
//
//  Created by Alexander Sokolenko on 31.08.2023.
//

import UIKit
import SwiftyDropbox

final class DataRepository: NSObject {
    
    private let imagesCache = ImagesProvider()
    private let thumbnailsProvider = ThumbnailsProvider()
    
    private override init() {
        super.init()
    }
    
    static let shared = DataRepository()
    
    func loadFilesMetadata() async throws -> Array<Files.Metadata>{
        let metadataProvider = FilesMetadataProvider()
        return try await metadataProvider.filesMetadata()
    }
    
    func thumbnail(for path : String) async -> UIImage? {
        await thumbnailsProvider.image(for: path)
    }
    
    func image(for path : String) async throws -> (image: UIImage, metadata: Files.Metadata) {
        let img = try await imagesCache.image(for: path)
        let metadata = try await imagesCache.metadata(for: path)
        return (img, metadata)
    }
    
    func videoSteamUrl(for path : String) async throws -> (url: URL, metadata : Files.Metadata) {
        let videosProvider = VideosProvider()
        let link = try await videosProvider.streamingLink(for: path)
        let metadata = try await videosProvider.metadata(for: path)
        return (link, metadata)
    }
    
    

}

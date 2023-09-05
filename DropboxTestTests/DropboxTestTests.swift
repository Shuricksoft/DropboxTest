//
//  DropboxTestTests.swift
//  DropboxTestTests
//
//  Created by Alexander Sokolenko on 31.08.2023.
//

import XCTest
import SwiftyDropbox
@testable import DropboxTest

final class DropboxTestTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        //XCTAssertNotNil(DataRepository.shared.isDropboxLoggedIn, "You must authorize before running the tests")
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testFilesList() async throws {
        let files = try await DataRepository.shared.loadFilesMetadata()
        XCTAssertNotEqual(files.count, 0)
    }
    
    func testThumbnails() async throws {
        let files = try await DataRepository.shared.loadFilesMetadata()
        XCTAssertNotEqual(files.count, 0)
        let thumbnail = await DataRepository.shared.thumbnail(for: files.first!.pathLower!)
        XCTAssertNotNil(thumbnail)
    }
    
    func testImage() async throws {
        let files = try await DataRepository.shared.loadFilesMetadata()
        XCTAssertNotEqual(files.count, 0)
        let imagePath = files.first(where: {allowedImageExtensions.contains($0.pathLower?.components(separatedBy: ".").last ?? "")})?.pathLower
        XCTAssertNotNil(imagePath)
        let image = try await DataRepository.shared.image(for: imagePath!)
    }
    
    func testVideo() async throws {
        let files = try await DataRepository.shared.loadFilesMetadata()
        XCTAssertNotEqual(files.count, 0)
        let videoPath = files.first(where: {allowedVideoExtensions.contains($0.pathLower?.components(separatedBy: ".").last ?? "")})?.pathLower
        XCTAssertNotNil(videoPath)
        let videoUrl = try await DataRepository.shared.videoSteamUrl(for: videoPath!)
        XCTAssert(videoUrl.url.scheme!.hasPrefix("http"))
    }

    func testPerformanceFilesList() throws {
        measure {
            let e = expectation(description: #function)
            let timeout : TimeInterval = 10
            Task {
                let files = try await DataRepository.shared.loadFilesMetadata()
                e.fulfill()
            }
            waitForExpectations(timeout: timeout)
        }
    }
    
    func testPerformanceImage() throws {
        measure {
            let timeout : TimeInterval = 30
            let e = expectation(description: #function)
            Task {
                let files = try await DataRepository.shared.loadFilesMetadata()
                let imagePath = files.first(where: {allowedImageExtensions.contains($0.pathLower?.components(separatedBy: ".").last ?? "")})!.pathLower!
                let image = try await DataRepository.shared.image(for: imagePath)
                e.fulfill()
            }
            waitForExpectations(timeout: timeout)
        }
    }
    
}

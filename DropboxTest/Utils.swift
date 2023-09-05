//
//  Utils.swift
//  DropboxTest
//
//  Created by Alexander Sokolenko on 30.08.2023.
//

import Foundation
import SwiftyDropbox

let allowedImageExtensions = ["jpg", "jpeg", "bmp", "tiff", "gif"]
let allowedVideoExtensions = ["avi", "mp4", "mov"]


extension DropboxClientsManager {
    class func refreshToken() async throws {
        let url = "https://api.dropbox.com/oauth2/token"
        let refreshToken = "2M2yKeTNqmIAAAAAAAAAAa7mJSFiVxDQIbWcBcmev9v9qMV27q_O1hrU-wlmn4Ds"
        var request = try! URLRequest(url: URL(string: url)!, method: .post)
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let params = "refresh_token=\(refreshToken)&grant_type=refresh_token&client_id=wcxx84vvj7rwryu&client_secret=l0isuoezvvb4q2d"
        request.httpBody = params.data(using: .ascii)
        let response = try await URLSession.shared.data(for: request)
        guard let token = try? (JSONSerialization.jsonObject(with: response.0) as? [String : Any])?["access_token"] as? String else {
            throw NSError(domain: "Refresh token", code: 1)
        }
        self.authorizedClient = DropboxClient(accessToken: token)
    }
}

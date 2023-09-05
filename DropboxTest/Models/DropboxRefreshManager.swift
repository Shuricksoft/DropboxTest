//
//  DropboxRefreshManager.swift
//  DropboxTest
//
//  Created by Alexander Sokolenko on 05.09.2023.
//

import UIKit
import SwiftyDropbox

class DropboxRefreshManager: NSObject {
    private var expirationTimer : Timer?
    private override init() {
        super.init()
    }
    
    deinit {
        expirationTimer?.invalidate()
    }
    
    static let shared = DropboxRefreshManager()
    
    func refreshToken() async throws {
        let url = "https://api.dropbox.com/oauth2/token"
        let refreshToken = "2M2yKeTNqmIAAAAAAAAAAa7mJSFiVxDQIbWcBcmev9v9qMV27q_O1hrU-wlmn4Ds"
        var request = try! URLRequest(url: URL(string: url)!, method: .post)
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let params = "refresh_token=\(refreshToken)&grant_type=refresh_token&client_id=wcxx84vvj7rwryu&client_secret=l0isuoezvvb4q2d"
        request.httpBody = params.data(using: .ascii)
        let response = try await URLSession.shared.data(for: request)
        guard let decodedResponse = try? (JSONSerialization.jsonObject(with: response.0) as? [String : Any]), let token = decodedResponse["access_token"] as? String else {
            throw NSError(domain: "Refresh token", code: 1)
        }
        DropboxClientsManager.authorizedClient = DropboxClient(accessToken: token)
        expirationTimer?.invalidate()
        expirationTimer = Timer.scheduledTimer(withTimeInterval: decodedResponse["expires_in"] as! TimeInterval, repeats: false, block: {
            [unowned self]
            _ in
            DropboxClientsManager.authorizedClient = nil
            Task {
                try? await self.refreshToken()   
            }
        })
    }
}

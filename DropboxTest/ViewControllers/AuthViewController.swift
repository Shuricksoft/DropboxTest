//
//  AuthViewController.swift
//  DropboxTest
//
//  Created by Alexander Sokolenko on 29.08.2023.
//

import UIKit
import SwiftyDropbox

final class AuthViewController: UIViewController {
    
    override func loadView() {
        super.loadView()
        self.view.backgroundColor = .systemBackground
        let label = UILabel()
        label.text = NSLocalizedString("Welcome to the test app", comment: "")
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("Authorize", comment: ""), for: [])
        button.addTarget(self, action: #selector(authPressed), for: .touchUpInside)
        let stack = UIStackView(arrangedSubviews: [label, button])
        stack.axis = .vertical
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
    }
    

    // MARK: - Buttons callbacks
    
    @objc private func authPressed() {
        let scopeRequest = ScopeRequest(scopeType: .user, scopes: ["account_info.read", "files.metadata.read", "files.content.read"], includeGrantedScopes: false)
            DropboxClientsManager.authorizeFromControllerV2(
                UIApplication.shared,
                controller: self,
                loadingStatusDelegate: nil,
                openURL: { (url: URL) -> Void in UIApplication.shared.open(url, options: [:], completionHandler: nil) },
                scopeRequest: scopeRequest
            )
    }

}

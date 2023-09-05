//
//  AppDelegate.swift
//  DropboxTest
//
//  Created by Alexander Sokolenko on 29.08.2023.
//

import UIKit
import SwiftyDropbox

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        DropboxClientsManager.setupWithAppKey("wcxx84vvj7rwryu")
        let accessToken = "sl.Bld6b726BYDpchZ9vuDgev-bB1T6gHP4X1oPs6Fs89Io_KuQ3SI6N4HJht1ylncmItUTvFOyOt2DGN8T0gyQVGoqHW8FbKwG-F9fv3cvPZwLI1ohdejZa8RD7gepGBZXo_O6fI2K3KxM"
        let client = DropboxClient(accessToken: accessToken)
        DropboxClientsManager.authorizedClient = client
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}


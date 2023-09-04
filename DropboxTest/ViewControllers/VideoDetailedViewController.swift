//
//  VideoDetailedViewController.swift
//  DropboxTest
//
//  Created by Alexander Sokolenko on 31.08.2023.
//

import UIKit
import AVKit

final class VideoDetailedViewController: FileDetailedViewController {
    
    private let videoView = PlayerView()
    
    override func loadView() {
        super.loadView()
        videoView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(videoView)
        NSLayoutConstraint.activate([
            videoView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            videoView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            videoView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            videoView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        Task {
            [weak self] in
            do {
                let result = try await DataRepository.shared.videoSteamUrl(for: self!.path)
                guard let self else {
                    return
                }
                self.videoView.player = AVPlayer(url: result.url)
                self.videoView.player?.play()
                self.metadata = result.metadata
            }
            catch let e as NSError {
                guard let self else {
                    return
                }
                let alert = UIAlertController(title: NSLocalizedString("Error loading video", comment: ""), message: e.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default))
                self.present(alert, animated: true)
            }
            catch {
                print("Unknown error")
            }
        }
    }

}

//
//  ImageDetailedViewController.swift
//  DropboxTest
//
//  Created by Alexander Sokolenko on 31.08.2023.
//

import UIKit

final class ImageDetailedViewController: FileDetailedViewController {
    
    private let imageView = UIImageView()
    
    override func loadView() {
        super.loadView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            imageView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            imageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        Task {
            [weak self] in
            do {
                let img = try await DataRepository.shared.image(for: self!.path)
                guard let self else {
                    return
                }
                self.imageView.image = img.image
                self.metadata = img.metadata
            }
            catch let e as NSError {
                guard let self else {
                    return
                }
                let alert = UIAlertController(title: NSLocalizedString("Error loading image", comment: ""), message: e.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default))
                self.present(alert, animated: true)
            }
            catch {
                print("Unknown error")
            }
        }
    }

}

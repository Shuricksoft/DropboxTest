//
//  FileDetailedViewController.swift
//  DropboxTest
//
//  Created by Alexander Sokolenko on 30.08.2023.
//

import UIKit
import SwiftyDropbox
import AVKit

class FileDetailedViewController: UIViewController {
    
    let path : String
    var metadata : Files.Metadata? {
        didSet {
            self.navigationItem.rightBarButtonItem?.isEnabled = metadata != nil
        }
    }
    
    init(path: String) {
        self.path = path
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        self.view.backgroundColor = .black
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Info", comment: ""), style: .plain, target: self, action: #selector(infoPressed))
        self.navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    // MARK: - Buttons callbacks
    
    @objc private func infoPressed() {
        guard let metadata = metadata as? Files.FileMetadata else {
            fatalError("Unsupported file type")
        }
        let descr = """
        Name: \(metadata.name)
        Size: \(metadata.size)
        Modified: \(metadata.clientModified)
        """
        let alert = UIAlertController(title: NSLocalizedString("File info", comment: ""), message: descr, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default))
        self.present(alert, animated: true)
    }
    

}

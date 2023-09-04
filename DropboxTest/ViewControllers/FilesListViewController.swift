//
//  FilesListViewController.swift
//  DropboxTest
//
//  Created by Alexander Sokolenko on 29.08.2023.
//

import UIKit
import SwiftyDropbox

final class FilesListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    private let collectionViewLayout = UICollectionViewFlowLayout()
    private let collectionView : UICollectionView!
    private let cellId = "cell"
    private var metadataCache = Array<Files.Metadata>()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(FileCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionViewLayout.itemSize = CGSize(width: 150, height: 150)
        collectionViewLayout.minimumInteritemSpacing = 10
        collectionViewLayout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        self.view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            collectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        loadFiles()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Log out", comment: ""), style: .plain, target: self, action: #selector(logoutPressed))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Reload", comment: ""), style: .plain, target: self, action: #selector(reloadPressed))
    }
    
    private func loadFiles() {
        Task {
            do {
                metadataCache = try await DataRepository.shared.loadFilesMetadata()
                collectionView.reloadData()
            }
            catch let e as NSError {
                showAlertWithErrorText(e.localizedDescription)
            }
        }
    }
    
    private func showAlertWithErrorText(_ error : String?) {
        let alert = UIAlertController(title: NSLocalizedString("Error loading files", comment: ""), message: error?.description, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default))
        self.present(alert, animated: true)
    }
    

    // MARK: - Buttons callbacks
    
    @objc private func logoutPressed() {
        DropboxClientsManager.unlinkClients()
        let window = self.view.window!
        window.windowScene?.windows[0].rootViewController = AuthViewController()
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {})
    }
    
    @objc private func reloadPressed() {
        loadFiles()
    }
    
    // MARK: - UICollectionView data source & delegate
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        metadataCache.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! FileCollectionViewCell
        let item = metadataCache[indexPath.item]
        cell.title = item.name
        if let path = item.pathLower {
            Task {
                cell.image = await DataRepository.shared.thumbnail(for: path)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        guard let path = metadataCache[indexPath.item].pathLower else {
            return
        }
        let vc : UIViewController
        if allowedImageExtensions.contains(path.components(separatedBy: ".").last ?? "") {
            vc = ImageDetailedViewController(path: path)
        }
        else if allowedVideoExtensions.contains(path.components(separatedBy: ".").last ?? "") {
            vc = VideoDetailedViewController(path: path)
        }
        else {
            let alert = UIAlertController(title: NSLocalizedString("Unsupported format", comment: ""), message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default))
            self.present(alert, animated: true)
            return
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }

}

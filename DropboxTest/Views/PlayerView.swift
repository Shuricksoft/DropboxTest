//
//  PlayerView.swift
//  DropboxTest
//
//  Created by Alexander Sokolenko on 30.08.2023.
//

import UIKit
import AVKit

final class PlayerView: UIView {

    override class var layerClass: AnyClass {
        AVPlayerLayer.self
    }
    
    var player: AVPlayer? {
        get {
            playerLayer.player
        }
        set {
            playerLayer.player = newValue
        }
    }
    
    var playerLayer: AVPlayerLayer {
        layer as! AVPlayerLayer
    }

}

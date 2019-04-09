//
//  ViewController.swift
//  Audio Capture & Playback
//
//  Created by Jack Huffman on 4/9/19.
//  Copyright © 2019 Jack Huffman. All rights reserved.
//

import UIKit
import AVKit

class ViewController: UIViewController {

    let audioSession = AVAudioSession.sharedInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestRecordingPermission()
        
    }

    @IBAction func recordButtonPressed(_ sender: UIBarButtonItem) {
    }
    
    func requestRecordingPermission() {
        audioSession.requestRecordPermission() {
            [unowned self] allowed in
            if allowed {
                // proceed to do whatever is needed to record
            } else {
                self.alertUser(title: "Recording Forbidden", message: "This app will not be allowed to record audio, and thus will not function properly.")
            }
        }
    }
    
    func alertUser(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}


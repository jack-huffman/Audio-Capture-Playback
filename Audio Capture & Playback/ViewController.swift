//
//  ViewController.swift
//  Audio Capture & Playback
//
//  Created by Jack Huffman on 4/9/19.
//  Copyright © 2019 Jack Huffman. All rights reserved.
//

import UIKit
import AVKit

class ViewController: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate {

    let audioSession = AVAudioSession.sharedInstance()
    var recorder = AVAudioRecorder()
    var player = AVAudioPlayer()
    
    // IBOutlets
    @IBOutlet weak var recordBtn: UIBarButtonItem!
    @IBOutlet weak var playBtn: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestRecordingPermission()
        
    }

    @IBAction func recordButtonPressed(_ sender: UIBarButtonItem) {
        if sender.image == UIImage(named: "record") {
            startRecording()
        } else {
            finishRecording(success: true)
        }
    }
    
    @IBAction func playButtonPressed(_ sender: UIBarButtonItem) {
        if playBtn.image == UIImage(named: "play") {
            if let recordingURL = checkForExistingAudio() {
                do {
                    player = try AVAudioPlayer(contentsOf: recordingURL)
                    player.play()
                    playBtn.image = UIImage(named: "stop")
                    recordBtn.isEnabled = false
                } catch {
                    print("Error: Could not play audio")
                    playBtn.image = UIImage(named: "play")
                    recordBtn.isEnabled = true
                }
            }
        }
        else {
            player.stop()
            playBtn.image = UIImage(named: "play")
            recordBtn.isEnabled = true
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        playBtn.image = UIImage(named: "play")
        recordBtn.isEnabled = true
    }
    
    func requestRecordingPermission() {
        audioSession.requestRecordPermission() {
            [unowned self] allowed in
            if allowed {
                self.recordBtn.isEnabled = true
                do {
                    try self.audioSession.setCategory(.playAndRecord, mode: .default)
                    try self.audioSession.setActive(true)
                } catch {
                    self.alertUser(title: "Recording Error", message: "Application is unable to record audio.")
                }
            } else {
                self.alertUser(title: "Recording Forbidden", message: "This app will not be allowed to record audio, and thus will not function properly.")
            }
        }
    }
    
    func startRecording() {
        let audioFileName = "audio.mp4"
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 1200,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        let fileManager = FileManager.default
        let documentDirectoryPaths = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectoryURL = documentDirectoryPaths[0]
        let audioFileURL = documentDirectoryURL.appendingPathComponent(audioFileName)
        do {
            recorder = try AVAudioRecorder(url: audioFileURL, settings: settings)
            recorder.delegate = self
            self.recordBtn.image = UIImage(named: "stop")
            self.playBtn.isEnabled = false
            recorder.record()

        } catch {
            finishRecording(success: false)
        }
    }
    
    func finishRecording(success: Bool) {
        
        recorder.stop()
        if success {
            self.recordBtn.image = UIImage(named: "record")
            self.playBtn.isEnabled = true
            self.alertUser(title: "Recording Saved", message: "Recording has been made successfully.")
        } else {
            self.recordBtn.image = UIImage(named: "record")
            self.alertUser(title: "Recording Failed", message: "Recording could not be completed")
        }
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }
    
    func checkForExistingAudio() -> URL? {
        let fileManager = FileManager.default
        let documentDirectoryPaths = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectoryURL = documentDirectoryPaths[0]
        return documentDirectoryURL.appendingPathComponent("audio.mp4")
    }
    
    func alertUser(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}

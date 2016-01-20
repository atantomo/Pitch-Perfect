//
//  ViewController.swift
//  Pitch Perfect
//
//  Created by Tantomo, Andrew | Andrew | ISDOD on 1/7/16.
//  Copyright © 2016 Rakuten. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    let defaultText = "tap to record"
    let recordingText = "recording ... \n (tap again to pause)"
    let resumeText = "tap to resume"
    
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var micButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    var isRecordCreated: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        resetScreen()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "stopRecording") {
            let playSndVc = segue.destinationViewController as! PlaySoundViewController
            playSndVc.receivedAudio = recordedAudio
        }
    }
    
    @IBAction func recordAudio(sender: UIButton) {
        
        // In case record has been started, user can pause and resume recording
        if (isRecordCreated) {
            
            if (audioRecorder.recording) {
                audioRecorder.pause()
                micButton.layer.opacity = 1.0
                recordingLabel.text = resumeText
            } else {
                audioRecorder.record()
                micButton.layer.opacity = 0.7
                recordingLabel.text = recordingText
            }
            
        } else {
            
            let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
            
            let recordingName = "my_audio.wav"
            let pathArray = [dirPath, recordingName]
            let filePath = NSURL.fileURLWithPathComponents(pathArray)
            
            let session = AVAudioSession.sharedInstance()
            try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            
            try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
            audioRecorder.delegate = self
            audioRecorder.meteringEnabled = true
            audioRecorder.prepareToRecord()
            audioRecorder.record()
            activateScreen()
        }
    }
    
    @IBAction func stopButtonTapped(sender: UIButton) {
        resetScreen()
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        
        if (flag) {
            recordedAudio = RecordedAudio(fromUrl: recorder.url)
            performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        } else {
            resetScreen()
        }
    }
    
    private func resetScreen() {
        
        stopButton.hidden = true
        recordingLabel.text = defaultText
        micButton.layer.opacity = 1.0
        isRecordCreated = false
    }
    
    private func activateScreen() {
        
        stopButton.hidden = false
        recordingLabel.text = recordingText
        micButton.layer.opacity = 0.7
        isRecordCreated = true
    }

}


//
//  PlaySoundViewController.swift
//  Pitch Perfect
//
//  Created by Tantomo, Andrew | Andrew | ISDOD on 1/12/16.
//  Copyright © 2016 Rakuten. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundViewController: UIViewController {
    
    var audioPlayer: AVAudioPlayer!
    var audioFile: AVAudioFile!
    var unitTimePitch: AVAudioUnitTimePitch!
    var receivedAudio: RecordedAudio!
    var audioEngine: AVAudioEngine!

    override func viewDidLoad() {
        
        super.viewDidLoad()

        audioPlayer = try! AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl)
        audioPlayer.enableRate = true
        audioFile = try! AVAudioFile(forReading: receivedAudio.filePathUrl)
        audioEngine = AVAudioEngine()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func playSlowAudio(sender: UIButton) {
        playAudioPlayerAtRate(0.5)
    }
    
    @IBAction func playFastAudio(sender: UIButton) {
        playAudioPlayerAtRate(2.0)
    }
    
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }
    
    @IBAction func playDarthVaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
    
    @IBAction func playReverbAudio(sender: UIButton) {
        playAudioWithReverb(100)
    }
    
    @IBAction func stopButtonTapped(sender: UIButton) {
        stopAudio()
    }
    
    private func playAudioPlayerAtRate(rate: Float) {
        
        stopAudio()
        audioPlayer.rate = rate
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }
    
    private func playAudioWithVariablePitch(pitch: Float) {
        
        stopAudio()
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        
        playAudioWithSoundEffect(changePitchEffect)
        
    }
    
    private func playAudioWithReverb(wetDryMix: Float) {
        
        stopAudio()
        let reverbEffect = AVAudioUnitReverb()
        reverbEffect.wetDryMix = wetDryMix
        
        playAudioWithSoundEffect(reverbEffect)
        
    }
    
    private func playAudioWithSoundEffect(soundEffect: AVAudioUnit) {
        
        let audioPlayerNode = AVAudioPlayerNode()
        
        audioEngine.attachNode(audioPlayerNode)
        audioEngine.attachNode(soundEffect)
        
        audioEngine.connect(audioPlayerNode, to: soundEffect, format: audioFile.processingFormat)
        audioEngine.connect(soundEffect, to: audioEngine.outputNode, format: audioFile.processingFormat)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        try! audioEngine.start()
        audioPlayerNode.play()
    }
    
    
    private func stopAudio() {
        
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }

}

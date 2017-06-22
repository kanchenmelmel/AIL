//
//  AudioAnalysis.swift
//  AIL
//
//  Created by Wenyu Zhao on 21/5/17.
//  Copyright © 2017 au.com.melmel. All rights reserved.
//

import UIKit
import EZAudio


class VoiceAnalysisController: UIViewController, EZMicrophoneDelegate, EZAudioFFTDelegate {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var frequencyWaveView: FrequencyWaveView!
    @IBOutlet weak var audioPlot: EZAudioPlot!
    @IBOutlet weak var recognitionButton: UIButton!
    var fft: EZAudioFFTRolling!
    var microphone: EZMicrophone!
    
    func changeText() {
        self.textView.text = SpeechRecognitionTestData[Int(arc4random_uniform(UInt32(SpeechRecognitionTestData.count)))]
        self.audioPlot.clear()
    }
    
    override func viewDidLoad() {
        self.microphone = EZMicrophone(delegate: self)
        self.fft = EZAudioFFTRolling.fft(withWindowSize: 4096, sampleRate: Float(self.microphone.audioStreamBasicDescription().mSampleRate), delegate: self)
        
        self.navigationItem.title = "AIL读音分析"
        self.navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: "换题", style: .plain, target: self, action: #selector(VoiceAnalysisController.changeText))
        ]
        self.changeText()
        
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory("AVAudioSessionCategoryPlayAndRecord")
            try session.setActive(true)
        } catch let e {
            print("AVAudioSession error: \(e.localizedDescription)")
        }
        self.audioPlot.clipsToBounds = true
        self.audioPlot.backgroundColor = UIColor.white
        self.audioPlot.color = UIColor.tintColor()
        self.recognitionButton.setTitleColor(UIColor.tintColor(), for: .normal)
        self.audioPlot.plotType = EZPlotType.rolling;
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.textView.contentInset = UIEdgeInsetsMake(-7.0, 0.0, 0, 0.0);
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //self.stopRecognizing()
    }
    
    func microphone(_ microphone: EZMicrophone!, hasAudioReceived buffer: UnsafeMutablePointer<UnsafeMutablePointer<Float>?>!, withBufferSize bufferSize: UInt32, withNumberOfChannels numberOfChannels: UInt32) {
        self.fft.computeFFT(withBuffer: buffer[0], withBufferSize: bufferSize)
        DispatchQueue.main.async {
            self.audioPlot.updateBuffer(buffer[0], withBufferSize: bufferSize)
        }
    }
    
    func fft(_ fft: EZAudioFFT!, updatedWithFFTData fftData: UnsafeMutablePointer<Float>!, bufferSize: vDSP_Length) {
        let frequency = self.fft.maxFrequency // Assume 0 ~ 1000
        DispatchQueue.main.async {
            self.frequencyWaveView.update(frequency);
        }
        
    }
    
    var started = false
    @IBAction func onRecognitionButtonClicked(_ sender: Any) {
        if (started) {
            self.microphone.stopFetchingAudio()
            recognitionButton.setTitle("开始朗读", for: .normal)
        } else {
            self.microphone.startFetchingAudio()
            recognitionButton.setTitle("结束朗读", for: .normal)
        }
        started = !started
        
    }
    
}


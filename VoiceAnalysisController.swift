//
//  AudioAnalysis.swift
//  AIL
//
//  Created by Wenyu Zhao on 21/5/17.
//  Copyright © 2017 au.com.melmel. All rights reserved.
//

import UIKit
//import EZAudio
import AudioKit


class VoiceAnalysisController: UIViewController/*, EZMicrophoneDelegate, EZAudioFFTDelegate*/ {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var frequencyWaveView: FrequencyWaveView!
    @IBOutlet weak var audioPlot: EZAudioPlot!
    @IBOutlet weak var recognitionButton: UIButton!
    
    var plot: AKNodeOutputPlot!
    var microphone: AKMicrophone!
    var tracker: AKFrequencyTracker!
    var silence: AKBooster!
    var timer: Timer!
    
    func changeText() {
        AudioKit.stop()
        if (timer != nil) {
            timer.invalidate()
            timer = nil
        }
        self.textView.text = SpeechRecognitionTestData[Int(arc4random_uniform(UInt32(SpeechRecognitionTestData.count)))]
        if self.plot != nil {
            self.plot.clear()
        }
        self.frequencyWaveView.clear()
    }
    
    func setupPlot() {
    
        self.plot = AKNodeOutputPlot(microphone, frame: audioPlot.bounds)
        plot.plotType = .rolling
        plot.shouldFill = true
        plot.shouldMirror = true
        plot.color = UIColor.tintColor()
        plot.gain = 5
        audioPlot.addSubview(plot)
    }
    
    //var ampTracker: AKAmplitudeTracker!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AKSettings.audioInputEnabled = true
        self.microphone = AKMicrophone()
        tracker = AKFrequencyTracker(microphone)
        //ampTracker = AKAmplitudeTracker(microphone)
        silence = AKBooster(tracker)
        
        
        self.navigationItem.title = "AIL读音分析"
        self.navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: "换题", style: .plain, target: self, action: #selector(VoiceAnalysisController.changeText))
        ]
        self.changeText()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AudioKit.output = silence
        setupPlot()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.textView.contentInset = UIEdgeInsetsMake(-7.0, 0.0, 0, 0.0);
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stop()
    }
    
    func updateFrequency() {
        let frequency = tracker.frequency > 1100 || tracker.frequency < 85 ? -1 : tracker.frequency
        let decibel = 20 * log10(tracker.amplitude / 0.000020)
        print("frequency: \(frequency), decibel: \(decibel)")
        
        DispatchQueue.main.async {
            self.frequencyWaveView.update(Float(frequency));
        }
    }
    
    func start() {
        recognitionButton.setTitle("开始朗读", for: .normal)
        AudioKit.start()
        timer = Timer.scheduledTimer(timeInterval: 0.035, target: self, selector: #selector(VoiceAnalysisController.updateFrequency), userInfo: nil, repeats: true)
    }
    
    func stop() {
        recognitionButton.setTitle("结束朗读", for: .normal)
        AudioKit.stop()
        if (timer != nil) {
            timer.invalidate()
            timer = nil
        }
    }
    
    var started = false
    @IBAction func onRecognitionButtonClicked(_ sender: Any) {
        started ? stop() : start()
        started = !started
    }
}


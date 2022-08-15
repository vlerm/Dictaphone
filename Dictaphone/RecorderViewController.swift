//
//  RecorderViewController.swift
//  Dictaphone
//
//  Created by Вадим Лавор on 14.08.22.
//

import Foundation
import UIKit

class RecorderViewController: UIViewController , RecorderDelegate {
        
    var recording: Record!
    var recordDuration = Int()

    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var voiceRecord: VoiceRecord!

    override func viewDidLoad() {
        super.viewDidLoad()
        createRecorder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        voiceRecord.update(0.0)
        voiceRecord.fillColor = UIColor.systemPink
        timeLabel.text = String()
    }

    @IBAction func stopRecording() {
        dismiss(animated: true, completion: nil)
        recordDuration = Int()
        recording.stop()
        voiceRecord.update(0.0)
    }
    
    open func createRecorder() {
        recording = Record(to: "record.m4a")
        recording.delegate = self
        DispatchQueue.global().async {
            do {
                try self.recording.prepare()
            } catch {
                print(error)
            }
        }
    }

    open func startRecording() {
        recordDuration = Int()
        do {
            try recording.record()
        } catch {
            print(error)
        }
    }
    
    func audioMeterDidUpdate(_ averagePower: Float) {
        self.recording.audioRecorder?.updateMeters()
        let alpha = 0.05
        let peakPower = pow(10, (alpha * Double((self.recording.audioRecorder?.peakPower(forChannel: 0))!)))
        var rate: Double = 0.0
        if (peakPower <= 0.2) {
            rate = 0.2
        } else if (peakPower > 0.9) {
            rate = 1.0
        } else {
            rate = peakPower
        }
        voiceRecord.update(CGFloat(rate))
        voiceRecord.fillColor = UIColor.systemPink
        recordDuration += 1
        timeLabel.text = String(recordDuration)
    }

}

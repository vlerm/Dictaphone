//
//  Record.swift
//  Dictaphone
//
//  Created by Вадим Лавор on 14.08.22.
//

import Foundation
import AVFoundation
import QuartzCore

@objc public protocol RecorderDelegate: AVAudioRecorderDelegate {
    @objc optional func audioMeterDidUpdate(_ averagePower: Float)
}

open class Record: NSObject {
    
    @objc public enum State: Int {
        case none, recording, playing
    }
    
    static var documentDirectory: String {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    }
    
    open weak var delegate: RecorderDelegate?
    open fileprivate(set) var url: URL
    open fileprivate(set) var state: State = .none
    fileprivate let audioSession = AVAudioSession.sharedInstance()
    fileprivate var audioPlayer: AVAudioPlayer?
    fileprivate var displayLink: CADisplayLink?
    open var channels = 1
    open var sampleRate = 44100.0
    open var bitRate = 192000
    var audioRecorder: AVAudioRecorder?

    var metering: Bool {
        return delegate?.responds(to: #selector(RecorderDelegate.audioMeterDidUpdate(_:))) == true
    }
    
    public init(to: String) {
        url = URL(fileURLWithPath: Record.documentDirectory).appendingPathComponent(to)
        super.init()
    }
    
    open func prepare() throws {
        let settings: [String: AnyObject] = [
            AVFormatIDKey : NSNumber(value: Int32(kAudioFormatAppleLossless) as Int32),
            AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue as AnyObject,
            AVEncoderBitRateKey: bitRate as AnyObject,
            AVNumberOfChannelsKey: channels as AnyObject,
            AVSampleRateKey: sampleRate as AnyObject
        ]
        audioRecorder = try AVAudioRecorder(url: url, settings: settings)
        audioRecorder?.prepareToRecord()
        audioRecorder?.delegate = delegate
        audioRecorder?.isMeteringEnabled = metering
    }
    
    open func record() throws {
        if audioRecorder == nil {
            try prepare()
        }
        try audioSession.setCategory(AVAudioSession.Category.playAndRecord)
        try audioSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
        audioRecorder?.record()
        state = .recording
        if metering {
            startMetering()
        }
    }
    
    open func play() throws {
        try audioSession.setCategory(AVAudioSession.Category.playback)
        audioPlayer = try AVAudioPlayer(contentsOf: url)
        audioPlayer?.play()
        state = .playing
    }
    
    open func stop() {
        switch state {
        case .playing:
            audioPlayer?.stop()
            audioPlayer = nil
        case .recording:
            audioRecorder?.stop()
            audioRecorder = nil
            stopMetering()
        default:
            break
        }
        state = .none
    }
    
    @objc func updateMeter() {
        guard let recorder = audioRecorder else { return }
        recorder.updateMeters()
        let averagePower = recorder.averagePower(forChannel: 0)
        delegate?.audioMeterDidUpdate?(averagePower)
    }
    
    fileprivate func startMetering() {
        displayLink = CADisplayLink(target: self, selector: #selector(Record.updateMeter))
        displayLink?.add(to: RunLoop.current, forMode: RunLoop.Mode.common)
    }
    
    fileprivate func stopMetering() {
        displayLink?.invalidate()
        displayLink = nil
    }
    
}

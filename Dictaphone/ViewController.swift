//
//  SceneDelegate.swift
//  Dictaphone
//
//  Created by Вадим Лавор on 14.08.22.
//

import Foundation
import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    var recorderView: RecorderViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setGradientBackground(view: self)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        recorderView = storyboard.instantiateViewController(withIdentifier: "RecorderViewController") as? RecorderViewController
        recorderView.createRecorder()
        recorderView.modalTransitionStyle = .crossDissolve
        recorderView.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
    }
    
    @IBAction func start() {
        self.present(recorderView, animated: true, completion: nil)
        recorderView.startRecording()
    }
    
    @IBAction func play() {
        do {
            try recorderView.recording.play()
        } catch {
            print(error)
        }
    }
    
    func setGradientBackground(view: UIViewController) {
            let colorTop =  UIColor(red: 0.0/255.0, green: 149.0/255.0, blue: 156.0/255.0, alpha: 1.0).cgColor
            let colorBottom = UIColor(red: 156.0/255.0, green: 194.0/255.0, blue: 158.0/255.0, alpha: 1.0).cgColor
            let gradientLayer = CAGradientLayer()
            gradientLayer.colors = [colorTop, colorBottom]
            gradientLayer.locations = [0.0, 1.0]
            gradientLayer.frame = view.view.bounds
            view.view.layer.insertSublayer(gradientLayer, at:0)
        }
    
}


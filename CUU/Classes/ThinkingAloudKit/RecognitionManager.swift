//
//  RecognitionManager.swift
//  thinkingaloud
//
//  Created by Lara Marie Reimer on 20.05.18.
//  Copyright © 2018 Lara Marie Reimer. All rights reserved.
//

import Foundation
import Speech

class RecognitionManager {
    
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()
    let request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask?
    
    var lastRecognition = ""
    let audioEngine = AVAudioEngine()
    
    func recordAndRecognizeSpeech() {
        let node = audioEngine.inputNode
        let recordingFormat = node.outputFormat(forBus: 0)
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, _) in
            self.request.append(buffer)
        }
        
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            return print(error)
        }
        
        guard let myRecognizer = SFSpeechRecognizer() else { return }
        
        if !myRecognizer.isAvailable { return }
        
        recognitionTask = myRecognizer.recognitionTask(with: request, resultHandler: { (result, _) in
            if let result = result {
                self.lastRecognition = result.bestTranscription.formattedString
            }
        })
    }
    
    func checkAuthorizationAndStart(with completion:@escaping (_ granted: Bool) -> Void) {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            /* The callback may not be called on the main thread. Add an
             operation to the main queue to update the record button's state.
             */
            OperationQueue.main.addOperation {
                switch authStatus {
                case .authorized:
                    let synth = AVSpeechSynthesizer()
                    let myUtterance = AVSpeechUtterance(string: "We're ready to start! Start talking now.")
                    myUtterance.rate = 0.3
                    synth.speak(myUtterance)
                    
                    completion(true)
                case .denied:
                    completion(false)
                case .restricted:
                    completion(true)
                case .notDetermined:
                    completion(true)
                }
            }
        }
    }
    
    func stopRecording() {
        audioEngine.stop()
        request.endAudio()
        recognitionTask?.finish()
    }
}

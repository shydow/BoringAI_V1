//
//  PreviewViewController.swift
//  BoringAI
//
//  Created by Shydow Lee on 2019/12/20.
//  Copyright © 2019 Shydow Lee. All rights reserved.
//

import UIKit
import AVKit
import Vision
import SwiftUI

class PreviewViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        validPrivilege()
        setupSession()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupUI()
    }

    private var captureSession: AVCaptureSession?
    
    private func validPrivilege() {
        var allowedAccess = false
        let blocker = DispatchGroup()
        blocker.enter()
        AVCaptureDevice.requestAccess(for: .video) { flag in
            allowedAccess = flag
            blocker.leave()
        }
        blocker.wait()

        if !allowedAccess {
            print("!!! NO ACCESS TO CAMERA")
            return
        }
    }
    
    private func setupSession() {
        let session = AVCaptureSession()
        session.beginConfiguration()

        let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera,
            for: .video, position: .unspecified) //alternate AVCaptureDevice.default(for: .video)
        guard videoDevice != nil, let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice!), session.canAddInput(videoDeviceInput) else {
            print("!!! NO CAMERA DETECTED")
            return
        }
        session.addInput(videoDeviceInput)
        
        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        session.addOutput(dataOutput)

        session.commitConfiguration()
        self.captureSession = session
    }
    
    let identifierLabel =  UILabel()
    let cameraView = UIView()
    
    private func setupUI() {
        view.addSubview(identifierLabel)
        
        identifierLabel.translatesAutoresizingMaskIntoConstraints = false
        identifierLabel.layer.zPosition = 1
        
        identifierLabel.backgroundColor = .brown
        identifierLabel.textAlignment = .center
        
        identifierLabel.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        identifierLabel.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        identifierLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        identifierLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
        view.layer.addSublayer(previewLayer)
        previewLayer.frame = view.frame
    }

    private func updateLabel(content: String) {
        identifierLabel.text = content
    }
    
    public func start() {
        captureSession?.startRunning()
    }
    
    public func stop() {
        captureSession?.stopRunning()
    }
}

extension PreviewViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }

        guard let model = try? VNCoreMLModel(for: MobileNet().model) else { return }
        let request = VNCoreMLRequest(model: model) { (finishedReq, err) in
            
            guard let results = finishedReq.results as? [VNClassificationObservation] else { return }
            
            guard let firstObservation = results.first else { return }
            
            print(firstObservation.identifier, firstObservation.confidence)
            
            DispatchQueue.main.async {
                self.updateLabel(content: "\(firstObservation.identifier) \(firstObservation.confidence * 100)")
            }
            
        }
        
        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
    }

}

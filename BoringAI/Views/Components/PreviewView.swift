//
//  PreviewView.swift
//  BoringAI
//
//  Created by Shydow Lee on 2019/12/17.
//  Copyright © 2019 Shydow Lee. All rights reserved.
//

import SwiftUI

struct PreviewView: UIViewControllerRepresentable {
    @Binding var isRunning: Bool
    
    var viewController = PreviewViewController()
    
    func updateUIViewController(_ uiViewController: PreviewViewController, context: UIViewControllerRepresentableContext<PreviewView>) {
        print("status:" + String(isRunning))
        if isRunning {
            viewController.start()
        } else {
            viewController.stop()
        }
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<PreviewView>) -> PreviewViewController {
        return viewController
    }
    
    static func dismantleUIViewController(_ uiViewController: PreviewViewController, coordinator: ()) {
        uiViewController.stop()
    }
}

//struct PreviewView_Previews: PreviewProvider {
//    static var previews: some View {
//        PreviewView(isRunning: $false)
//    }
//}

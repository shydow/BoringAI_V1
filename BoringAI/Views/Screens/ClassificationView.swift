//
//  ClassificationView.swift
//  BoringAI
//
//  Created by Shydow Lee on 2019/12/12.
//  Copyright © 2019 Shydow Lee. All rights reserved.
//

import SwiftUI
import AVKit

struct ClassificationView: View {
    @State var isRunning = false
    
    var previewView: PreviewView?
    
    var body: some View {
        VStack {
            if !isRunning {
                Spacer()
                Image("Camera").resizable().scaledToFit()
                Spacer()
                Button(action: startClassify) {
                    Text("Start")
                }
            } else {
                PreviewView(isRunning: $isRunning).frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                Button(action: stopClassify) {
                    Text("Stop")
                }
            }
        }.background(Color.white)
    
    }
    
    func startClassify() {
        isRunning = true
    }

    func stopClassify() {
        isRunning = false
    }
}

struct ClassificationView_Previews: PreviewProvider {
    static var previews: some View {
        ClassificationView()
    }
}

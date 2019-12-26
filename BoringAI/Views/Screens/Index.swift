//
//  Index.swift
//  BoringAI
//
//  Created by Shydow Lee on 2019/12/12.
//  Copyright © 2019 Shydow Lee. All rights reserved.
//

import SwiftUI

struct Index: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: ClassificationView()) {
                    Text("Realtime Classification")
                }
            }
            .navigationBarTitle("Index")
        }
    }
}

struct Index_Previews: PreviewProvider {
    static var previews: some View {
        Index()
    }
}

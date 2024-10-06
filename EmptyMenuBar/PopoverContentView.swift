//
//  PopoverContentView.swift
//  EmptyMenuBar
//
//  Created by Max Remy on 06.10.2024.
//

import SwiftUI

// VIEW FOR CONTENT THAT WILL BE DISPLAYED IN POPOVER
struct PopoverContentView: View {
    @State private var counter = 0 // KEEP TRACK OF BUTTON CLICK COUNTER
    
    var body: some View {
        VStack {
            Text("Hello World")
                .font(.headline)
            Divider()
            
            // BUTTON THAT INCREMENTS COUNTER WHEN CLICKED
            Button("Click me: \(counter)") {
                counter += 1
            }
        }
        .padding()
        .frame(width: 200, height: 100)
    }
}

// PREVIEW OF POPOVERCONTENTVIEW FOR SWIFTUI PREVIEW CANVAS
#Preview {
    PopoverContentView()
}

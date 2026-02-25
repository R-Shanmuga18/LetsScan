//
//  ContentView.swift
//  LetsScan
//
//  Created by R SHANMUGA KUMARA GURU on 25/02/26.
//

import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {
    
    @StateObject private var viewModel = Scanner()
    
    var body: some View{
        VStack(spacing: 30) {
            Text("QR Code Scanner")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            ZStack{
                RoundedRectangle(cornerRadius: 20)
                    .stroke(viewModel.isHovering ? Color.blue : Color.gray, style: StrokeStyle(lineWidth: 4, dash: [10]))
                    .background(viewModel.isHovering ? Color.blue.opacity(0.1) : Color.clear)
                
                Text("Drop Image File Here")
                    .foregroundColor(.secondary)
                    .font(.title2)
            }
            .frame(width: 320, height:250)
            .onDrop(of: [.image], isTargeted: $viewModel.isHovering) { providers in
                return viewModel.processFile(providers: providers)
            }
            
            TextField("Result will appear Here", text: Binding(
                get: {viewModel.currentResult?.extractedText ?? "Drag & Drop..."},
                set: {_ in}
            ))
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .font(.title3)
            .padding(.horizontal, 40)
        }
        .padding()
        .frame(width:450, height:500)
    }
}

#Preview {
    ContentView()
}

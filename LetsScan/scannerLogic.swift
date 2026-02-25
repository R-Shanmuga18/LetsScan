//
//  scannerLogic.swift
//  LetsScan
//
//  Created by R SHANMUGA KUMARA GURU on 25/02/26.
//

import SwiftUI
import Vision
import UniformTypeIdentifiers
import Combine
import Foundation

class Scanner: ObservableObject {
    
    @Published var currentResult: QRResult?
    @Published var isHovering = false
    
    func processFile(providers: [NSItemProvider]) -> Bool {
        guard let provider = providers.first else {return false}
        
        provider.loadDataRepresentation(forTypeIdentifier: UTType.image.identifier) { data, error in
            if let data = data, let nsImage = NSImage(data: data),
               let cgImage = nsImage.cgImage(forProposedRect: nil, context: nil, hints: nil) {
                self.scanImage(image: cgImage)
            }
        }
        return true
    }
    
    private func scanImage(image: CGImage) {
        let request = VNDetectBarcodesRequest { [weak self] request, error in
            DispatchQueue.main.async {
                if let results = request.results as? [VNBarcodeObservation], let firstCode = results.first {
                    self?.currentResult = QRResult(
                        extractedText: firstCode.payloadStringValue ?? "Unreadable Qr Code",
                    scanDate: Date(),
                    isSuccess: true
                    )
                } else {
                    self?.currentResult = QRResult(extractedText: "No QR detected", scanDate: Date(), isSuccess: false)
                }
            }
        }
        let handler = VNImageRequestHandler(cgImage: image, options: [:])
        try? handler.perform([request])
    }
}

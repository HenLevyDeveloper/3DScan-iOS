//
//  CaptureService.swift
//  3DScan-iOS
//
//  Created by Hen Levi on 07/02/2025.
//

import Foundation
import RealityKit
import Photos
import ARKit
import ModelIO
import Combine

@MainActor
protocol CaptureServiceProtocol: NSObject {
    func startCapturing()
    func stopCapturing()
    func resetCapturing()
    func captureImage(from frame: ARFrame)
    
    var scanCompletion: Double { get }
    var scanCompletionPublisher: Published<Double>.Publisher { get }
    var modelProcessing: Double { get }
    var modelProcessingPublisher: Published<Double>.Publisher { get }
    var outputModelURL: URL? { get }
    var isCapturing: Bool { get }
    var fileName: String { get }
}


class CaptureService: NSObject, ObservableObject, CaptureServiceProtocol {
    @Published var scanCompletion: Double = 0.0 // Percentage of scan coverage
    @Published var modelProcessing: Double = 0.0 // Percentage of 3D Model processing progress
    
    var scanCompletionPublisher: Published<Double>.Publisher { $scanCompletion }
    var modelProcessingPublisher: Published<Double>.Publisher { $modelProcessing }
    var outputModelURL: URL?
    var isCapturing = false
    var fileName = "BodyPartModel.usdz"
    
    private var capturedImages: [URL] = []
    private var session: PhotogrammetrySession?
    private var lastPosition: SIMD4<Float> = SIMD4<Float>(0, 0, 0, 1)
    private var scannedAngles: Set<String> = []
    
    
    // Start Capturing Process
    func startCapturing() {
        capturedImages.removeAll()
        isCapturing = true
        scanCompletion = 0.0
        modelProcessing = 0.0
        outputModelURL = nil
        print("📸 Hand Capture Started")
    }

    // Capture and Save an Image
    func captureImage(from frame: ARFrame) {
        guard isCapturing else { return }
        
        // I don't want to capture another image unless you moved more
        let cameraPosition = frame.camera.transform.columns.3
        let distanceMoved = sqrt(pow(cameraPosition.x - lastPosition.x, 2) +
                                 pow(cameraPosition.y - lastPosition.y, 2) +
                                 pow(cameraPosition.z - lastPosition.z, 2))
        
        guard distanceMoved > 0.05 else { // 5cm movement threshold
            print("Move around the object to improve scan quality!")
            return
        }
        
        // Saving the captured image so later on I can create a 3D model from it
        let imageURL = saveImage(frame.capturedImage)
        if let imageURL = imageURL {
            capturedImages.append(imageURL)
            print("✅ Image Captured: \(imageURL.lastPathComponent)")
        }
        
        // Save the covered angles until reach the target
        let cameraTransform = frame.camera.transform
        let rotation = cameraTransform.columns.2
        let angleKey = String(format: "%.1f,%.1f,%.1f", rotation.x, rotation.y, rotation.z)
        
        if !scannedAngles.contains(angleKey) {
            scannedAngles.insert(angleKey)
            scanCompletion = Double(scannedAngles.count) / 30.0 // Assume 30 different views needed
        }
        
        print("Scanned \(scannedAngles.count)/30 unique angles. Completion: \(scanCompletion * 100)%")
        
        lastPosition = cameraPosition

        if scanCompletion >= 1.0 {
            stopCapturing()
        }
    }

    // Stop Capturing & Start Photogrammetry Processing
    func stopCapturing() {
        isCapturing = false
        scanCompletion = 1.0
        
        print("📸 Stopped Capturing. Processing 3D Model...")

        // Process images asynchronously
        Task {
            await processImagesTo3D()
        }
    }
    
    func resetCapturing() {
        isCapturing = false
        scanCompletion = 0.0
        modelProcessing = 0.0
        outputModelURL = nil
    }

    // Save Image to Temp Directory
    private func saveImage(_ pixelBuffer: CVPixelBuffer) -> URL? {
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        let context = CIContext()
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else { return nil }

        let imageURL = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString + ".jpg")
        let uiImage = UIImage(cgImage: cgImage)
        guard let imageData = uiImage.jpegData(compressionQuality: 0.6) else { return nil }

        do {
            try imageData.write(to: imageURL)
            return imageURL
        } catch {
            print("❌ Failed to save image: \(error)")
            return nil
        }
    }

    private func processImagesTo3D() async {
        guard !capturedImages.isEmpty else {
            print("❌ No images to process")
            return
        }

        do {
            let tempDirectory = FileManager.default.temporaryDirectory.appendingPathComponent("ScanImages", isDirectory: true)
            let outputURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)

            // Ensure the folder exists
            try? FileManager.default.removeItem(at: tempDirectory)
            try FileManager.default.createDirectory(at: tempDirectory, withIntermediateDirectories: true, attributes: nil)

            // Move all captured images to this folder
            for imageUrl in capturedImages {
                if FileManager.default.fileExists(atPath: imageUrl.path) {
                    let destinationURL = tempDirectory.appendingPathComponent(imageUrl.lastPathComponent)
                    try FileManager.default.moveItem(at: imageUrl, to: destinationURL)
                } else {
                    print("⚠️ Warning: Skipping invalid image - \(imageUrl)")
                }
            }
            
            // Delete existing output file if it exists
            if FileManager.default.fileExists(atPath: outputURL.path) {
                try FileManager.default.removeItem(at: outputURL)
            }

            // Create PhotogrammetrySession with the folder
            session = try PhotogrammetrySession(input: tempDirectory, configuration: .init())

            Task {
                for try await result in session!.outputs {
                    switch result {
                    case .processingComplete:
                        print("🎉 Processing Complete!")
                        await MainActor.run {
                            self.outputModelURL = outputURL
                            self.modelProcessing = 1.0
                        }

                    case .requestError(let request, let error):
                        print("❌ Request Error: \(request) - \(error)")
                        return

                    case .processingCancelled:
                        print("❌ Processing Cancelled")
                        return

                    case .requestProgress(_, let fractionComplete):
                        await MainActor.run {
                            self.modelProcessing = fractionComplete
                            print("⏳ Progress: \(self.modelProcessing * 100)%")
                        }

                    default:
                        break
                    }
                }
            }

            // Process request
            try session?.process(requests: [.modelFile(url: outputURL)])

        } catch {
            print("❌ Error creating Photogrammetry Session: \(error)")
        }
    }

}

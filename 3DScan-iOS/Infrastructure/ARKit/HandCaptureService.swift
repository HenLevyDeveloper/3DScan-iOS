//
//  HandCaptureService.swift
//  3DScan-iOS
//
//  Created by Hen Levi on 07/02/2025.
//

import Foundation
import RealityKit
import Photos
import ARKit
import ModelIO

@MainActor
class HandCaptureService: NSObject, ObservableObject {
    private var capturedImages: [URL] = []
    private var session: PhotogrammetrySession?

    @Published var isCapturing = false
    @Published var progress: Double = 0.0
    @Published var outputModelURL: URL?

    // ✅ Start Capturing Process
    func startCapturing() {
        capturedImages.removeAll()
        isCapturing = true
        print("📸 Hand Capture Started")
    }

    // ✅ Capture and Save an Image
    func captureImage(from frame: ARFrame) {
        guard isCapturing else { return }

        let imageURL = saveImage(frame.capturedImage)
        if let imageURL = imageURL {
            capturedImages.append(imageURL)
            print("✅ Image Captured: \(imageURL.lastPathComponent)")

            // Stop capturing after 50 images
            if capturedImages.count >= 50 {
                stopCapturing()
            }
        }
    }

    // ✅ Stop Capturing & Start Photogrammetry Processing
    func stopCapturing() {
        isCapturing = false
        print("📸 Stopped Capturing. Processing 3D Model...")

        // ✅ Process images asynchronously
        Task {
            await processImagesTo3D()
        }
    }

    // ✅ Save Image to Temp Directory
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
            let tempDirectory = FileManager.default.temporaryDirectory.appendingPathComponent("HandScanImages", isDirectory: true)
            let outputURL = FileManager.default.temporaryDirectory.appendingPathComponent("handModel.usdz")

            // ✅ Ensure the folder exists
            try? FileManager.default.removeItem(at: tempDirectory)
            try FileManager.default.createDirectory(at: tempDirectory, withIntermediateDirectories: true, attributes: nil)

            // ✅ Move all captured images to this folder
            for imageUrl in capturedImages {
                if FileManager.default.fileExists(atPath: imageUrl.path) {
                    let destinationURL = tempDirectory.appendingPathComponent(imageUrl.lastPathComponent)
                    try FileManager.default.moveItem(at: imageUrl, to: destinationURL)
                } else {
                    print("⚠️ Warning: Skipping invalid image - \(imageUrl)")
                }
            }

            // ✅ Ensure there are enough images
            let validImages = try FileManager.default.contentsOfDirectory(at: tempDirectory, includingPropertiesForKeys: nil)
            if validImages.count < 50 {
                print("❌ Not enough valid images! Need at least 50.")
                return
            }

            // ✅ Delete existing output file if it exists
            if FileManager.default.fileExists(atPath: outputURL.path) {
                try FileManager.default.removeItem(at: outputURL)
            }

            // ✅ Create PhotogrammetrySession with the folder
            session = try PhotogrammetrySession(input: tempDirectory, configuration: .init())

            Task {
                for try await result in session!.outputs {
                    switch result {
                    case .processingComplete:
                        print("🎉 Processing Complete!")
                        await MainActor.run {
                            self.outputModelURL = outputURL
                        }

                    case .requestError(let request, let error):
                        print("❌ Request Error: \(request) - \(error)")
                        return

                    case .processingCancelled:
                        print("❌ Processing Cancelled")
                        return

                    case .requestProgress(_, let fractionComplete):
                        await MainActor.run {
                            self.progress = fractionComplete
                            print("⏳ Progress: \(self.progress * 100)%")
                        }

                    default:
                        break
                    }
                }
            }

            // ✅ Process request
            try session?.process(requests: [.modelFile(url: outputURL)])

        } catch {
            print("❌ Error creating Photogrammetry Session: \(error)")
        }
    }

}

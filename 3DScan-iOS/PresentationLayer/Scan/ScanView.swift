import SwiftUI

struct ScanView: View {
    @StateObject var viewModel: ScanViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            switch viewModel.status {
            case .scanning:
                ARViewController(captureService: viewModel.getCaptureService())
                    .edgesIgnoringSafeArea(.all)
                    .overlay(overlayView, alignment: .bottom)
                    .mask(RoundedRectangle(cornerRadius: 20).edgesIgnoringSafeArea(.all))
                    .overlay(alignment: .topTrailing) {
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .resizable()
                                .frame(width: 32, height: 32)
                                .foregroundColor(.white)
                                .shadow(radius: 3)
                                .padding()
                        }
                    }
            
            case .proccesing(let progress):
                Color.black.opacity(0.5)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    CircularProgressView(progress: progress)
                        .frame(width: 120, height: 120)
                        .padding()
                    
                    Text(progress < 0.5 ? "Proccesing scan..." : "Creating your 3D model...")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.black.opacity(0.7))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            
            case .done(let outputModelURL):
                ScanResultView(modelURL: outputModelURL, onClose: { dismiss() })
                    .edgesIgnoringSafeArea(.all)
            }
        }
    }
    
    private var overlayView: some View {
        VStack(spacing: 16) {
            if viewModel.isCapturing {
                ProgressView(value: viewModel.scanProgress, total: 1.0)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.black.opacity(0.7))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            
            Text(viewModel.scanProgress < 1.0 ?
                 "Move around the object for a full scan" :
                    "Scan Complete!")
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .background(Color.black.opacity(0.7))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
            Button(action: viewModel.toggleCapture) {
                Text(viewModel.isCapturing ? "Stop Capture" : "Start Capture")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.mustard)
                    .foregroundColor(.darkGray)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding(.horizontal)
        }
        .padding(.bottom, 30)
    }
}

#Preview {
    ScanView(viewModel: .create())
}

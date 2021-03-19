//
//  EffectView.swift
//  MyCamera
//
//  Created by daito yamashita on 2021/03/17.
//

import SwiftUI

// フィルタ名を列挙した配列
// 0.モノクロ
// 1.Chrome
// 2.Fade
// 3.Instant
// 4.noir
// 5.Process
// 6.Tonal
// 7.Transfer
// 8.sepiaTone
let filterArray = [
    "CIPhotoEffectMono",
    "CIPhotoEffectChrome",
    "CIPhotoEffectFade",
    "CIPhotoEffectInstant",
    "CIPhotoEffectNoir",
    "CIPhotoEffectProcess",
    "CIPhotoEffectTonal",
    "CIPhotoEffectTransfer",
    "CISepiaTone"
]

// 選択中のエフェクト（filterArrayの添字）
var filterSelectNumber = 0

struct EffectView: View {
    
    @Binding var isShowSheet: Bool
    
    let captureImage: UIImage
    
    @State var showImage: UIImage?
    
    @State var isShowActivity = false
    
    var body: some View {
        VStack {
            Spacer()
            
            if let unwrapShowImage = showImage {
                Image(uiImage: unwrapShowImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            
            Spacer()
            
            Button(action: {
                // フィルタ名を配列から取得
                let filterName = filterArray[filterSelectNumber]
                
                // 次回に適用するフィルタを決める
                filterSelectNumber += 1
                
                // 最後のフィルタまで適用した場合
                if filterSelectNumber == filterArray.count {
                    filterSelectNumber = 0
                }
                
                let rotate = captureImage.imageOrientation
                
                let inputImage = CIImage(image: captureImage)
                
                guard let effectFilter = CIFilter(name: filterName) else {
                    return
                }
                
                effectFilter.setDefaults()
                
                effectFilter.setValue(
                    inputImage,
                    forKey: kCIInputImageKey
                )
                
                guard let outputImage = effectFilter.outputImage else {
                    return
                }
                
                let ciContext = CIContext(options: nil)
                
                guard let cgImage = ciContext.createCGImage(
                    outputImage,
                    from: outputImage.extent
                ) else {
                    return
                }
                
                showImage = UIImage(
                    cgImage: cgImage,
                    scale: 1.0,
                    orientation: rotate
                )
                
                
            }) {
                Text("エフェクト")
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .multilineTextAlignment(.center)
                    .background(Color.blue)
                    .foregroundColor(Color.white)
            }
            
            .padding()
            
            Button(action: {
                isShowActivity = true
            }) {
                Text("シェア")
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .multilineTextAlignment(.center)
                    .background(Color.blue)
                    .foregroundColor(Color.white)
            }
            
            .sheet(isPresented: $isShowActivity) {
                ActivityView(shareItems: [showImage!.resize()!])
            }
            
            .padding()
            
            Button(action: {
                isShowSheet = false
            }) {
                Text("閉じる")
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .multilineTextAlignment(.center)
                    .background(Color.blue)
                    .foregroundColor(Color.white)
            }
            
            .padding()
        }
        
        .onAppear {
            showImage = captureImage
        }
    }
}

struct EffectView_Previews: PreviewProvider {
    static var previews: some View {
        EffectView(
            isShowSheet: Binding.constant(true),
            captureImage: UIImage(named: "preview_use")!
        )
    }
}

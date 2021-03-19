//
//  PHPickerView.swift
//  MyCamera
//
//  Created by daito yamashita on 2021/03/16.
//

import SwiftUI
import PhotosUI

struct PHPickerView: UIViewControllerRepresentable {
    
    @Binding var isShowSheet: Bool
    
    @Binding var captureImage: UIImage?
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        var parent: PHPickerView
        
        init(parent: PHPickerView) {
            self.parent = parent
        }
        
        // フォトライブラリで写真を選択、キャンセルしたときに実行される delegate メソッド
        // 必ず必要
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            if let result = results.first {
                result.itemProvider.loadObject(ofClass: UIImage.self) {
                    (image, error) in
                    
                    if let unwrapImage = image as? UIImage {
                        self.parent.captureImage = unwrapImage
                    } else {
                        print("使用できる写真がないです")
                    }
                }
            } else {
                print("選択された写真はないです")
            }
            
            parent.isShowSheet = false
        }
    }
    
    // Coodinatorを生成、SwiftUIによって自動的に呼び出し
    func makeCoordinator() -> Coordinator {
        
        // Coordinatorクラスのインスタンス生成
        Coordinator(parent: self)
    
    }
    
    // Viewを生成するときに実行
    func makeUIViewController(context: UIViewControllerRepresentableContext<PHPickerView>) -> PHPickerViewController {
        
        var configration = PHPickerConfiguration()
        
        configration.filter = .images
        
        configration.selectionLimit = 1
        
        let picker = PHPickerViewController(configuration: configration)
        
        picker.delegate = context.coordinator
        
        return picker
    }
    
    // Viewが更新されたときに実行
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: UIViewControllerRepresentableContext<PHPickerView>) {
        // 処理なし
    }
}

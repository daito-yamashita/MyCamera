//
//  ContentView.swift
//  MyCamera13
//
//  Created by daito yamashita on 2021/03/16.
//

import SwiftUI

@available(iOS 14, *)
struct ContentView: View {
    // 撮影する写真を保持する状態変数
    @State var captureImage: UIImage? = nil
    
    // 撮影画面のsheet
    @State var isShowSheet = false
    
    // share画面のsheet
    @State var isShowActivity = false
    
    // フォトライブラリかカメラを保持する状態変数
    @State var isPhotolibrary = false
    
    // ActionSheetのsheet
    @State var isShowAction = false
    
    var body: some View {
        VStack {
            Spacer()
            
            // 撮影した写真があるとき
            if let unwrapCaptureImage = captureImage {
                // 撮影写真を表示
                Image(uiImage: unwrapCaptureImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            
            Spacer()
            
            Button(action: {
                // ボタンをタップしたときの処理
                // カメラが利用可能かチェック
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    
                    print("カメラは利用できます")
                    
                    isShowAction = true
                    
                } else {
                    print("カメラは利用できません")
                }
            }) {
                Text("カメラを起動する")
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .multilineTextAlignment(.center)
                    .background(Color.blue)
                    .foregroundColor(Color.white)
            }
            
            .padding()
            
            // sheetを表示
            .sheet(isPresented: $isShowSheet) {
                if isPhotolibrary {
                    // PHPickerViewController（フォトライブラリ）を表示
                    PHPickerView(
                        isShowSheet: $isShowSheet,
                        captureImage: $captureImage
                    )
                } else {
                    // UIImagePickerController（写真撮影）を表示
                    ImagePickerView (
                        isShowSheet: $isShowSheet,
                        captureImage: $captureImage
                    )

                }
            }
            
            .actionSheet(isPresented: $isShowAction) {
                // ActionSheetを表示
                ActionSheet(title: Text("確認"),
                            message: Text("選択してください"),
                            buttons: [
                                .default(Text("カメラ"), action: {
                                    // カメラを選択
                                    isPhotolibrary = false
                                    
                                    // カメラが利用可能かチェック
                                    if UIImagePickerController.isSourceTypeAvailable(.camera) {
                                        print("カメラは利用できます")
                                        
                                        isShowSheet = true
                                    } else {
                                        print("カメラは利用できません")
                                    }
                                }),
                                .default(Text("フォトライブラリ"), action: {
                                    // フォトライブラリを選択
                                    isPhotolibrary = true
                                    
                                    isShowSheet = true
                                }),
                                .cancel(),
                            ])
            }
            
            // 「SNSに投稿する」ボタン
            Button(action: {
                // ボタンをタップした時のアクション
                if let _ = captureImage {
                    isShowActivity = true
                }
            }) {
                Text("SNSに投稿する")
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .multilineTextAlignment(.center)
                    .background(Color.blue)
                    .foregroundColor(Color.white)
            }
            
            .padding()
            
            // sheetを表示
            .sheet(isPresented: $isShowActivity) {
                ActivityView(shareItems: [captureImage!])
            }
        }
    }
}

@available(iOS 14, *)
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

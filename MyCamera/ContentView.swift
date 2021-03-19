//
//  ContentView.swift
//  MyCamera
//
//  Created by daito yamashita on 2021/03/16.
//

import SwiftUI

struct ContentView: View {
    // 撮影する写真を保持する状態変数
    @State var captureImage: UIImage? = nil
    
    // 撮影画面のsheet
    @State var isShowSheet = false
    
    // フォトライブラリかカメラを保持する状態変数
    @State var isPhotolibrary = false
    
    // ActionSheetのsheet
    @State var isShowAction = false
    
    var body: some View {
        VStack {
            
            Spacer()
            
            Button(action: {
                // ボタンをタップしたときの処理
                //撮影写真を初期化する
                captureImage = nil
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
                if let unwrapCaptureImage = captureImage {
                    // 撮影した写真がある->EffectViewを表示する
                    EffectView(
                        isShowSheet: $isShowSheet,
                        captureImage: unwrapCaptureImage
                    )
                } else {
                    // フォトライブラリが選択された
                    if isPhotolibrary {
                        PHPickerView(
                            isShowSheet: $isShowSheet,
                            captureImage: $captureImage
                        )
                    } else {
                        ImagePickerView(
                            isShowSheet: $isShowSheet,
                            captureImage: $captureImage
                        )
                    }
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
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

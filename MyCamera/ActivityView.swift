//
//  ActivityView.swift
//  MyCamera
//
//  Created by daito yamashita on 2021/03/16.
//

import SwiftUI

struct ActivityView: UIViewControllerRepresentable {
    
    let shareItems: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ActivityView>) {
        // 処理なし
    }
}

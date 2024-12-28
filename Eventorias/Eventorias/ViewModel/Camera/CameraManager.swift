//
//  CameraPreview.swift
//  Eventorias
//
//  Created by KEITA on 17/12/2024.
//
import Foundation
import SwiftUI
import AVFoundation
import Photos

class CameraManager: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    var parent: accessCameraView
    
    init(parent: accessCameraView) {
        self.parent = parent
    }
    
    func showCameraUnavailableAlert() {
        DispatchQueue.main.async {
            guard let rootViewController = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .flatMap({ $0.windows })
                .first(where: { $0.isKeyWindow })?.rootViewController else {
                return
            }
            
            let alert = UIAlertController(
                title: "Caméra non disponible",
                message: "La caméra n'est pas disponible sur cet appareil. Utilisez la galerie de photos.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            rootViewController.present(alert, animated: true, completion: nil)
        }
    }
    
    // Implémentation de la méthode déléguée pour sélectionner l'image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[.originalImage] as? UIImage {
            parent.selectedImage = image
        }
        parent.isPresented.wrappedValue.dismiss()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        parent.isPresented.wrappedValue.dismiss()
    }
}


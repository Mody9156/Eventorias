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
    var picker: accessCameraView

    init(picker: accessCameraView) {
        self.picker = picker
    }

    func showCameraUnavailableAlert() {
        // Création de l'alerte si la caméra n'est pas disponible
        guard let rootViewController = UIApplication.shared.windows.first?.rootViewController else { return }
        
        let alert = UIAlertController(title: "Caméra non disponible", message: "La caméra n'est pas disponible sur cet appareil. Utilisez la galerie de photos.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        rootViewController.present(alert, animated: true, completion: nil)
    }
    
    // Implémentation de la méthode déléguée pour sélectionner l'image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            self.picker.selectedImage = image
        }
        self.picker.isPresented.wrappedValue.dismiss()
    }

    // Implémentation de la méthode déléguée pour annuler la sélection
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.picker.isPresented.wrappedValue.dismiss()
    }
}



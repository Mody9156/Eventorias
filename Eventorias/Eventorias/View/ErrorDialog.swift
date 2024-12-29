//
//  ErrorDialog.swift
//  Eventorias
//
//  Created by KEITA on 24/12/2024.
//

import SwiftUI

struct ErrorDialog: View {
    @StateObject var listViewModel : ListViewModel
    @State private var isLoading = false
    
    var body: some View {
        ZStack {
            Color("Background")
                .ignoresSafeArea()
            
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
            } else {
                
                VStack {
                    ZStack{
                        Circle()
                            .frame(height: 64)
                            .foregroundColor(Color("BackgroundDocument"))
                        
                        Image(systemName:"exclamationmark")
                            .resizable()
                            .foregroundColor(.white)
                            .frame(width: 5, height: 24)
                        
                    }
                    .padding()
                    
                    Text("Error")
                        .font(.custom("Inter-SemiBold", size: 20))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .kerning(0.02)
                    
                    VStack(alignment: .leading){
                        Text("An error has occurred, please try again later")
                            .font(.custom("Inter-Regular", size: 16))
                            .multilineTextAlignment(.center)
                            .lineSpacing(6)
                            .frame(width: 164, height: 44)
                            .foregroundColor(.white)
                    }
                    .padding(.bottom)
                    
                    Button(action: {
                        isLoading = true
                        Task {
                            try? await listViewModel.getAllProducts()
                            isLoading = false
                        }
                    }) {
                        
                        Text("Try again")
                            .frame(width: 159, height: 40)
                            .background(Color("Button"))
                            .foregroundColor(.white)
                            .cornerRadius(4)
                        
                    }
                    .disabled(isLoading)
                    
                }
            }
        }
    }
}

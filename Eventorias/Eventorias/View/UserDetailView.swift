//
//  UserDetailView.swift
//  Eventorias
//
//  Created by KEITA on 01/12/2024.
//

import SwiftUI

struct UserDetailView: View {
    let eventEntry : EventEntry
    @StateObject var userDetailViewModel : UserDetailViewModel
    @StateObject  var locationCoordinate : LocationCoordinate
    @State var maps : UIImage?
    @Binding var address : String
    @State var coordString = ""
    
    var body: some View {
        VStack {
            ZStack {
                Color("Background")
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading) {
                        VStack{
                            
                            AsyncImage(url:URL(string:"\(eventEntry.poster)")){ image in
                                image
                                    .resizable()
                                
                            } placeholder:{
                                
                            }
                            .frame(width: 358, height: 364)
                            .cornerRadius(12)
                            
                            HStack {
                                VStack(alignment: .leading) {
                                    Label("\(eventEntry.dateCreation, format: .dateTime.day().month().year())",image:"event")
                                        .foregroundColor(.white)
                                        .frame(width: 141, height: 24)
                                    
                                    
                                    Label("\(userDetailViewModel.formatHourString(eventEntry.hourCreation))",image: "Time")
                                        .foregroundColor(.white)
                                        .frame(width: 109, height:24)
                                    
                                }
                                .padding()
                                Spacer()
                                
                                AsyncImage(url:URL(string:"\(eventEntry.picture)")){ image in
                                    image
                                        .resizable()
                                    
                                } placeholder:{
                                    ProgressView()
                                }
                                .frame(width: 60, height: 60)
                                .padding()
                                
                            }
                            
                            ScrollView {
                                Text(eventEntry.description)
                                    .font(.custom("Inter", size: 14))
                                    .fontWeight(.regular)
                                    .lineSpacing(20 - 14)
                                    .multilineTextAlignment(.leading)
                                    .foregroundColor(.white)
                                    .padding()
                            }
                        }
                        VStack(alignment: .leading) {
                            HStack {
                                VStack (alignment: .leading){
                                    Text(eventEntry.place.street)
                                        .foregroundColor(.white)
                                        .font(.custom("Inter-Medium", size: 16))
                                        .lineSpacing(24 - 16)
                                        .multilineTextAlignment(.leading)
                                    
                                    HStack {
                                        Text("\(eventEntry.place.city),")
                                            .foregroundColor(.white)
                                            .font(.custom("Inter-Medium", size: 16))
                                        Text("\(eventEntry.place.postalCode),")
                                            .foregroundColor(.white)
                                            .font(.custom("Inter-Medium", size: 16))
                                        Text(eventEntry.place.country)
                                            .foregroundColor(.white)
                                            .font(.custom("Inter-Medium", size: 16))
                                    }
                                }
                                .frame(width: 167, height: 72)
                                
                                Spacer()
                                
                                if let picture = maps {
                                    Image(uiImage: picture)
                                        .cornerRadius(20)
                                }
                            }.onAppear{
                                Task {
                                    
                                    locationCoordinate.geocodeAddress(address: address){ coords in
                                        coordString = "\(coords.latitude), \(coords.longitude)"
                                    }
//                                    let imageData =  try await userDetailViewModel.showMapsStatic(self.locationCoordinate.latitude,self.locationCoordinate.longitude)
//
//                                    if let image = UIImage(data: imageData){
//                                        maps = image
//                                    }
                                }
                            }
                        }
                        .padding()
                        
                    }
                }
            }
        }
        .onAppear{
            
        }
    }
}
//
//struct UserDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        UserDetailView(eventEntry: EventEntry(picture: "MusicFestival", title: "Music festival"
//, dateCreation: Date.now, poster: "https://s3-alpha-sig.figma.com/img/1826/61cb/1851012ea9af9e0347043719d004ab89?Expires=1734912000&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=RJThaTMTQemLGIekREGN9rKLQ5RyMOjMWCXsKyEn~4agSqW1lcPkeIp6tDfeS3T1o-YiNoDUaDhlClwnI2T--aOfkZfrxmGqxGQWj93mSBFQmSVTDVXWUCKKw0~N7UiFf9Ia7VmVTuGzb2JwWjI9D8vACaptRvrShdaAgkgtlBYxSaOPWLD56F-9YV3x69K7VBbtHri1MHmp~MoRTpIZtzF9a1MXdP8Mfy9jZMRZ6NDuYDboO6xHEZV20ZeOs2AUfHS8zEe7LAs5XFIrjso~Ypa0qRHMAv-UCX4yzkfr36y1tUXPOEtRtqLok0IAah3yNDtvkTtcSNQxVuZk5krZ~Q__"
//, description: "Join us for an unforgettable Music Festival celebrating the vibrant sounds of today's most talented artists. This event will feature an exciting lineup of performances, ranging from electrifying live bands to soulful solo acts, offering a diverse and immersive musical experience. Whether you're a devoted music enthusiast or simply looking for a weekend of fun, you'll have the chance to enjoy an eclectic mix of genres and discover emerging talent. Don't miss this opportunity to connect with fellow music lovers and create lasting memories in an energetic, festival atmosphere!", hour: "12:00", category: "Music", place: Address(street: "81-800 Avenue 51", city: "Indio", postalCode: "92201", country: "USA", localisation: GeoPoint(latitude: 33.71275, longitude: -116.20614))), userDetailViewModel: UserDetailViewModel(eventEntry: [EventEntry(picture: "MusicFestival", title: "Music festival"
//                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              , dateCreation: Date.now, poster: "https://s3-alpha-sig.figma.com/img/1826/61cb/1851012ea9af9e0347043719d004ab89?Expires=1734912000&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=RJThaTMTQemLGIekREGN9rKLQ5RyMOjMWCXsKyEn~4agSqW1lcPkeIp6tDfeS3T1o-YiNoDUaDhlClwnI2T--aOfkZfrxmGqxGQWj93mSBFQmSVTDVXWUCKKw0~N7UiFf9Ia7VmVTuGzb2JwWjI9D8vACaptRvrShdaAgkgtlBYxSaOPWLD56F-9YV3x69K7VBbtHri1MHmp~MoRTpIZtzF9a1MXdP8Mfy9jZMRZ6NDuYDboO6xHEZV20ZeOs2AUfHS8zEe7LAs5XFIrjso~Ypa0qRHMAv-UCX4yzkfr36y1tUXPOEtRtqLok0IAah3yNDtvkTtcSNQxVuZk5krZ~Q__"
//                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              , description: "Join us for an unforgettable Music Festival celebrating the vibrant sounds of today's most talented artists. This event will feature an exciting lineup of performances, ranging from electrifying live bands to soulful solo acts, offering a diverse and immersive musical experience. Whether you're a devoted music enthusiast or simply looking for a weekend of fun, you'll have the chance to enjoy an eclectic mix of genres and discover emerging talent. Don't miss this opportunity to connect with fellow music lovers and create lasting memories in an energetic, festival atmosphere!", hour: "12:00", category: "Music", place: Address(street: "81-800 Avenue 51", city: "Indio", postalCode: "92201", country: "USA", localisation: GeoPoint(latitude: 33.71275, longitude: -116.20614)))], listViewModel: ListViewModel(), googleMapView: GoogleMapView()))
//    }
//}

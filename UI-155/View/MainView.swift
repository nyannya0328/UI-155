//
//  MainView.swift
//  UI-155
//
//  Created by にゃんにゃん丸 on 2021/04/02.
//

import SwiftUI
import CoreLocation

struct MainView: View {
    @StateObject var MapModel = MapViewModel()
    @State var locationManger = CLLocationManager()
    var body: some View {
        ZStack{
            
            MapView()
                .ignoresSafeArea(.all, edges: .all)
                .environmentObject(MapModel)
            
            VStack{
                
                VStack {
                    HStack{
                        
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            
                        
                        TextField("Search Location", text: $MapModel.searchText)
                    }
                    .padding(.vertical,10)
                    .padding(.horizontal)
                    .background(Color.white)
                    
                    .cornerRadius(8)
                
                    
                    
                    if !MapModel.places.isEmpty && MapModel.searchText != ""{
                        
                        
                        ScrollView(.vertical, showsIndicators: false, content: {
                            
                            ForEach(MapModel.places){place in
                                
                                Text(place.placemark.name ?? "")
                                
                                
                                    .fontWeight(.bold)
                                    .foregroundColor(.black)
                                    .frame(maxWidth: .infinity,alignment: .leading)
                                    .onTapGesture {
                                        MapModel.selectPlace(place: place)
                                    }
                                Divider()
                                
                                
                                
                            }
                            .padding(.top)
                            
                            
                            
                        })
                        .background(Color.white)
                        
                    }
                    
                }
                .padding()
                
                Spacer()
                
                VStack{
                    
                    
                    NavigationLink(
                        destination: Home(),
                        label: {
                            Image(systemName: "tv")
                                .font(.title2)
                                .padding(10)
                                .background(Color.primary)
                                .clipShape(Circle())
                                
                        })
                    
                    Button(action: {
                        
                        MapModel.foucusLocation()
                    }) {
                        
                        Image(systemName: "location.fill")
                            .font(.title2)
                            .padding(10)
                            .background(Color.primary)
                            .clipShape(Circle())
                    }
                    
                    Button(action: {
                        MapModel.updateMaptype()
                        
                        
                    }) {
                        Image(systemName: MapModel.mapType == .standard ? "network" : "map")
                            .font(.title2)
                            .padding(10)
                            .background(Color.primary)
                            .clipShape(Circle())
                        
                    }
                    
                }
                .frame(maxWidth: .infinity,alignment: .trailing)
                .padding()
                
                
            }
        }
        .onAppear(perform: {
            locationManger.delegate = MapModel
            locationManger.requestWhenInUseAuthorization()
            
            
        })
        .alert(isPresented: $MapModel.perMissonDenid, content: {
            
            
            Alert(title: Text("Permisson Denied"), message: Text("Please Enable permisson in Appsetting"), dismissButton: .default(Text("Go to Settings"),action: {
                
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                
            }))
        })
        .onChange(of: MapModel.searchText) { (value) in
            let delay = 0.3
            
            DispatchQueue.main.asyncAfter(deadline:.now() + delay) {
                if value == MapModel.searchText{
                    
                    self.MapModel.searchQuery()
                }
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

//
//  MapViewModel.swift
//  UI-155
//
//  Created by にゃんにゃん丸 on 2021/04/02.
//

import SwiftUI
import CoreLocation
import MapKit


class MapViewModel: NSObject, ObservableObject,CLLocationManagerDelegate {
    @Published var mapView = MKMapView()
    @Published var region : MKCoordinateRegion!
    @Published var perMissonDenid = false
    
    @Published var mapType : MKMapType = .standard
    
    @Published var places : [Place] = []
    
    @Published var searchText = ""
    
    
    func selectPlace(place : Place){
        
        searchText = ""
        
        guard let cordinate = place.placemark.location?.coordinate else{return}
        
        let pointAnotation = MKPointAnnotation()
        pointAnotation.coordinate = cordinate
        pointAnotation.title = place.placemark.name ?? "No name"
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotation(pointAnotation)
        
        let coorDinateRegion = MKCoordinateRegion(center: cordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
        mapView.setRegion(coorDinateRegion, animated: true)
        mapView.setVisibleMapRect(mapView.visibleMapRect, animated: true)
        
    }
    
    
    func searchQuery(){
        
        places.removeAll()
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        
        MKLocalSearch(request: request).start { (respnce, _) in
            guard let result = respnce else{return}
            
            self.places = result.mapItems.compactMap({ (item) -> Place? in
                return Place(placemark: item.placemark)
            })
        }
        
    }
    
    func updateMaptype(){
        
        if mapType == .standard{
            mapType = .hybrid
            mapView.mapType = mapType
            
        }
        else{
            
            mapType = .standard
            mapView.mapType = mapType
        }
        
    }
    
    func foucusLocation(){
        
        guard let _ = region else{return}
        mapView.setRegion(region, animated: true)
        mapView.setVisibleMapRect(mapView.visibleMapRect, animated: true)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        switch manager.authorizationStatus{
        
        case.denied :perMissonDenid.toggle()
        case.notDetermined : manager.requestWhenInUseAuthorization()
        case.authorizedWhenInUse : manager.requestLocation()
        default : ()
        
        
        
        }
        
        
        
        
        
        
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else{return}
        
        self.region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 100000, longitudinalMeters: 100000)
        self.mapView.setRegion(self.region, animated: true)
        self.mapView.setVisibleMapRect(self.mapView.visibleMapRect, animated: true)
    }
}


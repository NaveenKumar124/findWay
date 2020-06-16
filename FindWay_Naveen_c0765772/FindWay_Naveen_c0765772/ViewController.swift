//
//  ViewController.swift
//  FindWay_Naveen_c0765772
//
//  Created by Navi Malhotra on 2020-06-14.
//  Copyright © 2020 Naveen Kumar. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController , UIGestureRecognizerDelegate  {

    @IBOutlet weak var automobileButton: UIButton!
    
    @IBOutlet weak var zoomLabel: UILabel!
    
    @IBOutlet weak var walkButton: UIButton!
    
    @IBOutlet weak var mapView: MKMapView!
    
//    let pinchgesture = UIPinchGestureRecognizer()
//    
    var locationManager = CLLocationManager()
    var authorisationStatus = CLLocationManager.authorizationStatus()
    var radius:Double = 1000
    var type:Bool?
    var cooArr = [CLLocationCoordinate2D]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        
        locationManager.delegate = self
        mapView.delegate = self
        
        configureLocation()
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        doubleTap()
        Longpress()
        
        automobileButton.layer.cornerRadius = automobileButton.bounds.height/2
        
//        mapView.addGestureRecognizer(pinchgesture)
//        pinchgesture.addTarget(self, action: #selector(pinchaction))
//
    }
    
//    @objc func pinchaction(){
//        guard let gestureview = pinchgesture.view else{
//            return
//        }
//        gestureview.transform = gestureview.transform.scaledBy(x: pinchgesture.scale, y: pinchgesture.scale)
//        pinchgesture.scale = 1
//    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
                           let region = locationManager.location?.coordinate
        
                                 let regioncoordinate = MKCoordinateRegion(center: region!, latitudinalMeters: 1000*2, longitudinalMeters: 1000*2)
        
                                 mapView.setRegion(regioncoordinate, animated: true)
                       
    }
    
    func Longpress(){
        
        let tripleTap = UILongPressGestureRecognizer(target: self, action: #selector(longPressed))
        
        tripleTap.delegate = self
        
        mapView.addGestureRecognizer(tripleTap)
       
    }
    
    @objc func longPressed(){
        
        let coordinates = mapView.userLocation.coordinate
        
        let region = MKCoordinateRegion(center: coordinates, latitudinalMeters: 100000*2, longitudinalMeters: 100000*2)
        
        mapView.setRegion(region, animated: true)
        zoomLabel.isHidden = true
        
        
    }
    
//    func PinchGesture(){
//
//        let pinched = UIPinchGestureRecognizer(target: self, action: #selector(pinchGesture))
//
//        pinched.delegate = self
//
//        mapView.addGestureRecognizer(pinched)
//
//    }
//
//    @objc func pinchGesture(){
//
//        guard let gestureview = PinchGesture
//
//        mapView.setRegion(region, animated: true)
//        zoomLabel.isHidden = true
//
//
//    }
    
    
    @IBAction func walkButtonPressed(_ sender: UIButton) {
        
        type = true
        if mapView.annotations.count > 1{
            getDirection(destination: cooArr.last!)
        }
       
        
        
    }
    
    func doubleTap(){
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(userTapped(sender:)))
        
        doubleTap.numberOfTapsRequired = 2
        
       
        doubleTap.delegate = self
        mapView.addGestureRecognizer(doubleTap)
        
    }
    
    @objc func userTapped(sender:UITapGestureRecognizer){
        
        removeAnnotation()
        let touchPoint = sender.location(in: mapView)
        
        let coordinates = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        
        cooArr.append(coordinates)
        
        let annotation = Annotations(coordinate: coordinates, identifier: "pin")
        
        mapView.addAnnotation(annotation)
        
        mapView.removeOverlays(mapView.overlays)
        
    }
    
    func getDirection(destination:CLLocationCoordinate2D ){
        
        
        let destinationRequest = MKDirections.Request()
        
        let sourceCoordinates = mapView.userLocation.coordinate
       
    
        let source = CLLocationCoordinate2DMake((sourceCoordinates.latitude), (sourceCoordinates.longitude))
        let destination = CLLocationCoordinate2DMake(destination.latitude, destination.longitude)
        
        print(source)
        print(destination)
        
        let sourcePlacemark = MKPlacemark(coordinate: source)
        let destinationPlacemark = MKPlacemark(coordinate: destination)
        
        let finalSource = MKMapItem(placemark: sourcePlacemark)
        let finalDestination = MKMapItem(placemark: destinationPlacemark)
        
        destinationRequest.source = finalSource
        destinationRequest.destination = finalDestination
      
         
       if type == true{
            
        destinationRequest.transportType = .walking
        
        }
        
       else{
         destinationRequest.transportType = .automobile
        }
        
        let direction = MKDirections(request: destinationRequest)
        
        
        direction.calculate { (responce, error) in
            
            guard let responce = responce else {
                
                if let error = error {
                    print(error)
                    
                }
                return
            }
            let route = responce.routes[0]
            
            self.mapView.addOverlay(route.polyline, level: .aboveRoads)
            self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            
        }
        
    }
    
    @IBAction func navigationButtonPressed(_ sender: UIButton) {
        
        if mapView.annotations.count > 1{
            getDirection(destination:cooArr.last!)
        }
       
    }
    
    func userLoacation(){
        
        let region = MKCoordinateRegion(center: mapView.userLocation.coordinate, latitudinalMeters: 1000*2, longitudinalMeters: 1000*2)
        
        mapView.setRegion(region, animated: true)
        
    }
    
    @IBAction func carButtonPressed(_ sender: UIButton) {       // Your Location Button in View
        
        userLoacation()
       
    }
    
}

extension ViewController: MKMapViewDelegate{
    
    func removeAnnotation(){
       
        for annotations in mapView.annotations{
            
            mapView.removeAnnotation(annotations)
            
        }
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation{
                    
           return nil
        
        }
        
      let annotation = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
        
        return annotation
        
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {

            let render = MKPolylineRenderer(overlay: overlay)

            render.strokeColor = UIColor.orange

            render.lineWidth = 3

            return render

        }

        return MKOverlayRenderer()
    }
   
}

extension ViewController: CLLocationManagerDelegate{
    
    func configureLocation(){
        
        locationManager.requestAlwaysAuthorization()
        
    }
    
}



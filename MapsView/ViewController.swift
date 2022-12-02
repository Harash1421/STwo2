import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{
    
    @IBOutlet weak var main_MapsView: MKMapView!
    var locationManger = CLLocationManager()
    
    //Title
    var titleInfo = ""
    var subTitleInfo = ""
    //Location
    var lat:Double? = nil
    var long:Double? = nil
    var Location = CLLocation()
    override func viewDidLoad() {
        super.viewDidLoad()
        main_MapsView.delegate = self
        locationManger.delegate = self
        //Location Manger Coding
        locationManger.desiredAccuracy = kCLLocationAccuracyBest
        locationManger.requestWhenInUseAuthorization()
        locationManger.startUpdatingLocation()
        
        //Gesture Reconizers
        let mapPress = UILongPressGestureRecognizer(target: self, action: #selector(mapPress(mapPress:)))
        mapPress.minimumPressDuration = 1
        main_MapsView.addGestureRecognizer(mapPress)
    }
    
    //Location Manger Functions
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let latitude = locations[0].coordinate.latitude
        let longitude = locations[0].coordinate.longitude
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let span = MKCoordinateSpan(latitudeDelta: 4.0, longitudeDelta: 4.0)
        let region = MKCoordinateRegion(center: location, span: span)
        main_MapsView.setRegion(region, animated: true)
        main_MapsView.showsUserLocation = true
        if(lat != 0.0 && long != 0.0){
            locationManger.stopUpdatingLocation()
        }
    }
    
    
    //press On Map Coding
    @objc func mapPress(mapPress:UILongPressGestureRecognizer){
        //If Map Gesture Reconizers
        if(mapPress.state == .began){
            //Tuouch Point
            let touchPoint = mapPress.location(in: self.main_MapsView)
            let touchCoordinates = self.main_MapsView.convert(touchPoint, toCoordinateFrom: self.main_MapsView)
            //Latitude And Longitude
            lat = touchCoordinates.latitude
            long = touchCoordinates.longitude
            
            Location = CLLocation(latitude: lat!, longitude: long!)
            
            //GeoCoder
            CLGeocoder().reverseGeocodeLocation(Location) { placeMark, error in
                let placeInfo = placeMark?.first
                if let error = error {
                    print(error.localizedDescription)
                }
                else {
                    if let title = placeInfo?.locality{
                        self.titleInfo = title
                        if let subTitle = placeInfo?.name{
                            self.subTitleInfo = subTitle
                            let annotation = MKPointAnnotation()
                            annotation.coordinate = touchCoordinates
                            annotation.title = self.titleInfo
                            annotation.subtitle = self.subTitleInfo
                            print(self.titleInfo)
                            self.main_MapsView.removeAnnotations(self.main_MapsView.annotations)
                            self.main_MapsView.addAnnotation(annotation)
                        }
                    }
                    //Else If
                }
                //CLGeocoder
            }
            //If Map Press
        }
        //Map Press Function
    }

}


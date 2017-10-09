import CoreLocation

class LocationController: NSObject, CLLocationManagerDelegate {
    var locationManager: CLLocationManager!
    public static var sharedInstance = LocationController()

    override init() {
        super.init()
        locationManager = CLLocationManager()
        locationManager.delegate = self
    }

    func requestAuthorization() {
        let status = CLLocationManager.authorizationStatus()
        if status == CLAuthorizationStatus.notDetermined {
            locationManager.requestAlwaysAuthorization()
        }
    }

    func startUpdatingLocation() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.distanceFilter = 3
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("locationManager status is...")
        switch status {
        case .notDetermined:
            print("notDetermined")
            break
        case .denied:
            print("denied")
            break
        case .restricted:
            print("restricted")
            break
        case .authorizedAlways:
            print("authorizedAlways")
            startUpdatingLocation()
            break
        case .authorizedWhenInUse:
            print("authorizedWhenInUse")
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for location in locations {
            RSLocation.lat = location.coordinate.latitude
            RSLocation.lng = location.coordinate.longitude
        }
    }
}

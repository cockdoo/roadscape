import UIKit
import MapKit

class PlayViewController: UIViewController, MKMapViewDelegate {
    var activity: ActivityTable!

    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()

        var coordinates = [CLLocationCoordinate2D]()

        for trackPoint in activity.trackPoints {
            let coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(trackPoint.lat), longitude: CLLocationDegrees(trackPoint.lng))
            coordinates.append(coordinate)
        }
        let line: MKPolyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
        mapView.add(line)

        mapView.setCenter(mapView.userLocation.coordinate, animated: false)
        mapView.userTrackingMode = .follow
        mapView.delegate = self

        mapView.mapType = .satelliteFlyover
    }

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let myPolyLineRendere: MKPolylineRenderer = MKPolylineRenderer(overlay: overlay)
        myPolyLineRendere.lineWidth = 5
        myPolyLineRendere.strokeColor = .red
        return myPolyLineRendere
    }

    func inject(_ activity: ActivityTable) {
        self.activity = activity
    }

    @IBAction func touchedPlayButton(_ sender: Any) {
    }
}

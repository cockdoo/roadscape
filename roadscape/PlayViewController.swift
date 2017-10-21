import UIKit
import MapKit

class PlayViewController: UIViewController, MKMapViewDelegate {

    var record: RecordTable!
    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()

        var coordinates = [CLLocationCoordinate2D]()

        for record in record.records {
            let coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(record.lat), longitude: CLLocationDegrees(record.lng))
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

    func inject(_ record: RecordTable) {
        self.record = record
    }

    @IBAction func touchedPlayButton(_ sender: Any) {
    }
}

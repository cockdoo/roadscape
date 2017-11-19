import UIKit
import MapKit
import GoogleMaps

class PlayViewController: UIViewController, MKMapViewDelegate {
    private var activity: ActivityTable!

    private let numberOfPanoramaViewLayer: Int = 3
    private var panoramaViews = [PanoramaView]()

    private var playTimer: Timer?
    private let intervalForPlayTimer: TimeInterval = 1.0

    private var numberOfCurrentLoadTrackPointNumber: Int = 0
    private var trackPointsCount: Int!

    private var latestHeading: CLLocationDirection = 0

    @IBOutlet weak var mapView: MKMapView!


    override func viewDidLoad() {
        super.viewDidLoad()

        setPanoramaViewLayer()
    }

    func inject(_ activity: ActivityTable) {
        self.activity = activity
        trackPointsCount = activity.trackPoints.count
    }

    func setPanoramaViewLayer() {
        for _ in 0..<numberOfPanoramaViewLayer {
            let panoramaView = PanoramaView.init(frame: CGRect(x: 0, y: 100, width: self.view.bounds.width, height: 300))
            panoramaView.moveNearCoordinate(CLLocationCoordinate2D(latitude: -33.732, longitude:150.312))
            panoramaViews.append(panoramaView)
            view.addSubview(panoramaView)
        }
    }

    @IBAction func touchedPlayButton(_ sender: Any) {
        playTimer = Timer.scheduledTimer(timeInterval: intervalForPlayTimer, target: self, selector: #selector(lotatePanoramaView), userInfo: nil, repeats: true)
    }

    @objc func lotatePanoramaView() {
        guard numberOfCurrentLoadTrackPointNumber < trackPointsCount else {
            playTimer?.invalidate()
            return
        }

        let trackPoint = activity.trackPoints[numberOfCurrentLoadTrackPointNumber]
        if numberOfCurrentLoadTrackPointNumber < trackPointsCount - 1 {
            let nextTrackPoint = activity.trackPoints[numberOfCurrentLoadTrackPointNumber + 1]
            latestHeading = getAngle(fromLat: trackPoint.lat, fromLng: trackPoint.lng, toLat: nextTrackPoint.lat, toLng: nextTrackPoint.lng)
        }
        panoramaViews[2].camera = GMSPanoramaCamera(heading: latestHeading, pitch: 0, zoom: 1)
        panoramaViews[2].moveNearCoordinate(CLLocationCoordinate2DMake(trackPoint.lat, trackPoint.lng))

        numberOfCurrentLoadTrackPointNumber += 1
    }

    func getAngle(fromLat: Double, fromLng: Double, toLat: Double, toLng: Double) -> CLLocationDirection {
        var r = atan2(toLat - fromLat, toLng - fromLng)
        if r < 0 {
            r = r + 2 * Double.pi
        }
        return floor(r * 360 / (2 * Double.pi))
    }

    /*
    func showPolyLineToMap() {
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
    */

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let myPolyLineRendere: MKPolylineRenderer = MKPolylineRenderer(overlay: overlay)
        myPolyLineRendere.lineWidth = 5
        myPolyLineRendere.strokeColor = .red
        return myPolyLineRendere
    }




}

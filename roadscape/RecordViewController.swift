import UIKit
import MapKit

class RecordViewController: UIViewController {
    private var locationController: LocationController!
    private var activityController: ActivityController!
    private var currentRecordButtonType: recordButtonType!
    @IBOutlet weak var mapView: MKMapView!

    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var finishButton: UIButton!

    enum recordButtonType {
        case start
        case pause
        case restart
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        locationController = LocationController()
        activityController = ActivityController()

        currentRecordButtonType = .start
        finishButton.isHidden = true

        mapView.setCenter(mapView.userLocation.coordinate, animated: false)
        mapView.userTrackingMode = .follow

        locationController.requestAuthorization()
        locationController.locationManager.startUpdatingLocation()
    }

    @IBAction func didTouchRecordButton(_ sender: Any) {
        switch currentRecordButtonType {
        case .start:
            activityController.startRecord()
            currentRecordButtonType = .pause
            recordButton.setTitle("pause", for: .normal)
            break
        case .pause:
            activityController.pauseRecord()
            currentRecordButtonType = .restart
            recordButton.setTitle("restart", for: .normal)
            finishButton.isHidden = false
            break
        case .restart:
            activityController.restartRecord()
            currentRecordButtonType = .pause
            recordButton.setTitle("pause", for: .normal)
            finishButton.isHidden = true
            break
        default:
            break
        }
    }

    @IBAction func touchedFinishButton(_ sender: Any) {
        let saveActivityViewController: SaveActivityViewController = UIStoryboard(name: "SaveActivityViewController", bundle: nil).instantiateInitialViewController() as! SaveActivityViewController
        saveActivityViewController.inject(activityController)
        navigationController?.pushViewController(saveActivityViewController, animated: true)
    }
}

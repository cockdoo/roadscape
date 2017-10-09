import UIKit
import MapKit

class RecordViewController: UIViewController {
    private var locationController: LocationController!
    private var recordController: RecordController!
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
        recordController = RecordController()
        currentRecordButtonType = .start
        mapView.setCenter(mapView.userLocation.coordinate, animated: true)
        mapView.userTrackingMode = .follow
        finishButton.isHidden = true

        locationController.requestAuthorization()
        locationController.locationManager.startUpdatingLocation()
    }

    @IBAction func didTouchRecordButton(_ sender: Any) {
        switch currentRecordButtonType {
        case .start:
            recordController.startRecord()
            currentRecordButtonType = .pause
            recordButton.setTitle("pause", for: .normal)
            break
        case .pause:
            recordController.pauseRecord()
            currentRecordButtonType = .restart
            recordButton.setTitle("restart", for: .normal)
            finishButton.isHidden = false
            break
        case .restart:
            recordController.restartRecord()
            currentRecordButtonType = .pause
            recordButton.setTitle("pause", for: .normal)
            finishButton.isHidden = true
            break
        default:
            break
        }
    }

    @IBAction func touchedFinishButton(_ sender: Any) {
        let savaRecordViewController: SaveRecordViewController = UIStoryboard(name: "SaveRecordViewController", bundle: nil).instantiateInitialViewController() as! SaveRecordViewController
        savaRecordViewController.inject(recordController)
        navigationController?.pushViewController(savaRecordViewController, animated: true)
    }
}

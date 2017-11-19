import Foundation
import RealmSwift
import CoreLocation

class ActivityTable: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var title: String = ""
//    start_latlng
//    finish_latlng
//    moving_time
//    dinstance
//    start_date
    var trackPoints = List<TrackPoint>()
}

class TrackPoint: Object {
    @objc dynamic var lat: Double = 0
    @objc dynamic var lng: Double = 0
    @objc dynamic var createdDate: Date = Date()
}

class ActivityController: NSObject {
    var tmpTrackPoints: List<TrackPoint>
    var previousLocation: CLLocation
    var timerForAppendTrackPoint: Timer!
    private let intervalForAppendTrackPoint: TimeInterval = 1

    override init() {
        tmpTrackPoints = List<TrackPoint>()
        previousLocation = CLLocation(latitude: MyLocation.lat, longitude: MyLocation.lng)
        super.init()
    }

    func startRecord() {
        appendTrackPoint(location: CLLocation(latitude: MyLocation.lat, longitude: MyLocation.lng))

        startTimerForAppendTrackPoint()
    }

    func startTimerForAppendTrackPoint() {
        timerForAppendTrackPoint = Timer.scheduledTimer(timeInterval: intervalForAppendTrackPoint, target: self, selector: #selector(checkAppendTrackPointWithCurrentLocation), userInfo: nil, repeats: true)
    }

    @objc func checkAppendTrackPointWithCurrentLocation() {
        let currentLocation = CLLocation(latitude: MyLocation.lat, longitude: MyLocation.lng)
        let distance = currentLocation.distance(from: previousLocation)

        if distance > 1 {
            appendTrackPoint(location: currentLocation)
        }
    }

    func appendTrackPoint(location: CLLocation) {
        previousLocation = location
        let trackPoint: TrackPoint = TrackPoint()
        trackPoint.lat = location.coordinate.latitude as Double
        trackPoint.lng = location.coordinate.longitude as Double
        trackPoint.createdDate = Date()
        tmpTrackPoints.append(trackPoint)
    }

    func pauseRecord() {
        timerForAppendTrackPoint.invalidate()
    }

    func restartRecord() {
        startTimerForAppendTrackPoint()
    }

    func saveActivity(title: String) {
        let myActivity = ActivityTable()
        myActivity.trackPoints = tmpTrackPoints
        myActivity.title = title
        myActivity.id = getIncrementId()

        let realm = try! Realm()
        try! realm.write {
            realm.add(myActivity)
        }
    }

    func getIncrementId() -> Int {
        let realm = try! Realm()
        return (realm.objects(ActivityTable.self).max(ofProperty: "id") ?? 0) + 1
    }

    func getActivities() -> [ActivityTable] {
        let realm = try! Realm()
        let activities: [ActivityTable] = realm.objects(ActivityTable.self).reversed()
        return activities
    }
}

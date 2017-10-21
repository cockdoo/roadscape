import Foundation
import RealmSwift
import CoreLocation

class RecordTable: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var title: String = ""
    var records = List<RSRecord>()
}

class RSRecord: Object {
    @objc dynamic var lat: Double = 0
    @objc dynamic var lng: Double = 0
    @objc dynamic var createdDate: Date = Date()
}

class RecordController: NSObject {
    var tmpRecords: List<RSRecord>
    var previousLocation: CLLocation
    var updateTimer: Timer!

    override init() {
        tmpRecords = List<RSRecord>()
        previousLocation = CLLocation(latitude: RSLocation.lat, longitude: RSLocation.lng)
        super.init()
    }

    func startRecord() {
        updateLocation(location: CLLocation(latitude: RSLocation.lat, longitude: RSLocation.lng))
        startCheckUpdateTimer()
    }

    @objc func checkUpdateLocation() {
        print("update")
        let currentLocation = CLLocation(latitude: RSLocation.lat, longitude: RSLocation.lng)
        let distance = currentLocation.distance(from: previousLocation)

        print(distance)
        if distance > 1 {
            updateLocation(location: currentLocation)
        }
    }

    func updateLocation(location: CLLocation) {
        previousLocation = location
        let record: RSRecord = RSRecord()
        record.lat = location.coordinate.latitude as Double
        record.lng = location.coordinate.longitude as Double
        record.createdDate = Date()
        tmpRecords.append(record)
    }

    func pauseRecord() {
        updateTimer.invalidate()
        print(tmpRecords)
    }

    func restartRecord() {
        startCheckUpdateTimer()
    }

    func startCheckUpdateTimer() {
        updateTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(checkUpdateLocation), userInfo: nil, repeats: true)
    }

    func saveRecord(title: String) {
        print("save")
        let myRecords = RecordTable()
        myRecords.records = tmpRecords
        myRecords.title = title
        myRecords.id = getIncrementId()

        let realm = try! Realm()
        try! realm.write {
            realm.add(myRecords)
        }
    }

    func getIncrementId() -> Int {
        let realm = try! Realm()
        return (realm.objects(RecordTable.self).max(ofProperty: "id") ?? 0) + 1
    }

    func getHomeItem() -> Results<RecordTable> {
        let realm = try! Realm()
        return realm.objects(RecordTable.self)
    }
}

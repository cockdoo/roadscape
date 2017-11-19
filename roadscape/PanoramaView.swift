import UIKit
import GoogleMaps

class PanoramaView: GMSPanoramaView {

    override func draw(_ rect: CGRect) {
//        print("A")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
//        print("B")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

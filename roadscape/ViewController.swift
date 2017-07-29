import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textField: UITextField!

    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        textField.rx_text
            .map {$0}
            .bindTo(label.rx_text)
            .addDisposableTo(disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


import UIKit

class SaveRecordViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    var recordController: RecordController!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func inject(_ recordConroller: RecordController) {
        self.recordController = recordConroller
    }

    @IBAction func touchedSaveButton(_ sender: Any) {
        guard titleTextField.text != "" else { return }
        recordController.saveRecord(title: titleTextField.text!)

        dismiss(animated: true, completion: nil)
    }
}

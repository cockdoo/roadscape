import UIKit

class SaveActivityViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    var activityController: ActivityController!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func inject(_ activityController: ActivityController) {
        self.activityController = activityController
    }

    @IBAction func touchedSaveButton(_ sender: Any) {
        guard titleTextField.text != "" else { return }
        activityController.saveActivity(title: titleTextField.text!)

        dismiss(animated: true, completion: nil)
    }
}

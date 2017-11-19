import UIKit

protocol SaveActivityEventHandler {
    func didSaveActivity()
}

class SaveActivityViewController: UIViewController {
    private var saveActivityEventHandler: SaveActivityEventHandler!
    @IBOutlet weak var titleTextField: UITextField!
    private var activityController: ActivityController!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func inject(handler: SaveActivityEventHandler, activityController: ActivityController) {
        saveActivityEventHandler = handler
        self.activityController = activityController
    }

    @IBAction func touchedSaveButton(_ sender: Any) {
        guard titleTextField.text != "" else { return }
        activityController.saveActivity(title: titleTextField.text!)

        saveActivityEventHandler.didSaveActivity()
        dismiss(animated: true, completion: nil)
    }
}

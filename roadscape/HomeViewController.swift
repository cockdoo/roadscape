import UIKit
import RealmSwift

class HomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillAppear(_ animated: Bool) {
        showTableContent()
    }

    func showTableContent() {
        let myRealm = try! Realm()
        let rows = myRealm.objects(RecordTable.self)

        for row in rows {
            let hoge = row.id
            print(hoge)
            print(row.title)
//            print(row.records)
        }

        print("----- ▼ テーブルの中身 -----")
        print(rows)
        print(rows.last?.id)
        print("----- ▲ テーブルの中身 -----")


    }

    @IBAction func didTouchButton(_ sender: Any) {
        let viewController = UIStoryboard(name: "RecordViewController", bundle: nil).instantiateInitialViewController()
        viewController?.modalPresentationStyle = .overCurrentContext
        present(viewController!, animated: true, completion: nil)
    }
}

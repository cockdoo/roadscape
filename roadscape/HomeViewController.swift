import UIKit
import RealmSwift

class HomeViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    let cellIdentifer = "RecordCollectionViewCell"

    var records: Results<RecordTable>?

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        let nib: UINib = UINib(nibName: cellIdentifer, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: cellIdentifer)

        getRecordsFromLocal()
    }

    func getRecordsFromLocal() {
        records = RecordController().getHomeItem()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.bounds.width, height: RecordCollectionViewCell.height)
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard records != nil else { return 1 }
        return records!.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: RecordCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifer, for: indexPath) as! RecordCollectionViewCell
        cell.update(records![indexPath.row].title)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let viewController: PlayViewController = UIStoryboard.init(name: "PlayViewController", bundle: nil).instantiateInitialViewController() as! PlayViewController
        viewController.inject(records![indexPath.row])
        navigationController?.pushViewController(viewController, animated: true)
    }

    @IBAction func didTouchButton(_ sender: Any) {
        let viewController = UIStoryboard(name: "RecordViewController", bundle: nil).instantiateInitialViewController()
        viewController?.modalPresentationStyle = .overCurrentContext
        present(viewController!, animated: true, completion: nil)
    }
}

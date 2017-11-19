import UIKit
import RealmSwift

class HomeViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, RecordEventHandler {
    
    @IBOutlet weak var collectionView: UICollectionView!
    let cellIdentifer = "ActivityCollectionViewCell"

    var activities: Results<ActivityTable>?

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        let nib: UINib = UINib(nibName: cellIdentifer, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: cellIdentifer)

        getActivitiesFromLocal()
    }

    func getActivitiesFromLocal() {
        activities = ActivityController().getActivities()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.bounds.width, height: ActivityCollectionViewCell.height)
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard activities != nil else { return 1 }
        return activities!.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ActivityCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifer, for: indexPath) as! ActivityCollectionViewCell
        cell.update(activities![indexPath.row].title)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let playViewController: PlayViewController = UIStoryboard.init(name: "PlayViewController", bundle: nil).instantiateInitialViewController() as! PlayViewController
        playViewController.inject(activities![indexPath.row])
        navigationController?.pushViewController(playViewController, animated: true)
    }

    @IBAction func didTouchButton(_ sender: Any) {
        let recordViewController: RecordViewController = UIStoryboard(name: "RecordViewController", bundle: nil).instantiateInitialViewController() as! RecordViewController
        recordViewController.inject(handler: self)
        recordViewController.modalPresentationStyle = .overCurrentContext

        let navigationController = UINavigationController(rootViewController: recordViewController)
        present(navigationController, animated: true, completion: nil)
    }

    // MARK: RecordEventHandler

    func didSaveActivity() {
        print("saved!")
        getActivitiesFromLocal()
        collectionView.reloadData()
    }
}

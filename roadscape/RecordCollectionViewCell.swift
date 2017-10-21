import UIKit

class RecordCollectionViewCell: UICollectionViewCell {
    static let height: CGFloat = 100
    @IBOutlet weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func update(_ title: String) {
        titleLabel.text = title
    }
}

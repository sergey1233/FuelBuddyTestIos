import UIKit

class PetroleCell: UITableViewCell {

    @IBOutlet weak var cost: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var adress: UILabel!
    @IBOutlet weak var bgDirection: UIView!
    @IBOutlet weak var direction: UIImageView!
    @IBOutlet weak var distance: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

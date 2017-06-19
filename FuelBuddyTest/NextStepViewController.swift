import UIKit

class NextStepViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = GlobalVariables.clickString
        self.navigationItem.hidesBackButton = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let backButton: UIBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(back))
        self.navigationItem.leftBarButtonItem = backButton;
        super.viewWillAppear(animated);
    }
    
    func back() {
        self.dismiss(animated: true, completion: nil)
    }
}

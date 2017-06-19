import UIKit

class CustomMarkerView: UIView {
    
    var logo = UIImage()
    var adress = UILabel()
    var price = UILabel()
    var icon_like = UIImage(named: "icon_like")
    var icon_direction = UIImage(named: "icon_direction")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addCustomView()
    }
    
    init(frame: CGRect, adress: String, price: String, logo: String) {
        super.init(frame: frame)
        self.adress.text = adress
        self.price.text = price
        self.logo = UIImage(named: logo)!
        self.addCustomView()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addCustomView() {
        let layerBG = CALayer()
        layerBG.frame.size.width = 201
        layerBG.frame.size.height = 36
        layerBG.backgroundColor = UIColor(patternImage: UIImage(named: "bgMarkerView")!).cgColor
        layerBG.position = CGPoint(x: 201, y: 18)
        self.layer.addSublayer(layerBG)
    }
}


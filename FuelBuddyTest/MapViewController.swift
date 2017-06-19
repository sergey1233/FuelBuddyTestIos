import UIKit
import GoogleMaps

class MapViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, GMSMapViewDelegate {
    
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var heightBottomSliderConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentView: UISegmentedControl!
    @IBOutlet weak var bottomListSlider: UIView!
    
    var topBarView = UIView()
    var widthConstraintTopBar = CGFloat()
    var titleTopBar = UILabel()
    let textTitleToBar = "Fuel Buddy"
    var btnProfileTopBar = UIButton()
    var btnSettingsTopBar = UIButton()
    var customSearchBar: SearchTextField!
    var iconPinView = UIButton()
    var iconAddView = UIButton()
    let searchBarTextColor = UIColor(red: (206/255.0), green: (206/255.0), blue: (206/255.0), alpha: 1)
    var xTriangle = NSLayoutConstraint() //constraint for triangle under the segmentview
    var marker = GMSMarker()
    
    var markerInfoWindow = UIView()
    
    var petroleArray: [Petrole] = []
    
    //test attributes for Petrole object
    let petroleTitle: String = "Автозаправка Shell"
    let petroleCost: String = "35,5 ₽"
    let petroleTime: String = "час назад"
    let petroleIcon: String = "logo_shell"
    let petroleAdress: String = "ул. Садовническая, 57"
    let petroleLatitude: Double = 55.736316
    let petroleLongitude: Double = 37.650791
    let petroleDistance: Double = 0.2
    
    let petroleTitle2: String = "Газпром"
    let petroleCost2: String = "35,5 ₽"
    let petroleTime2: String = "3 часа назад"
    let petroleIcon2: String = "logo_gasprom"
    let petroleAdress2: String = "ул. Карла-Маркса, 112"
    let petroleLatitude2: Double = 55.650056
    let petroleLongitude2: Double = 37.323780
    let petroleDistance2: Double = 1.3
    
    let petroleTitle3: String = "Газпром"
    let petroleCost3: String = "35,5 ₽"
    let petroleTime3: String = "3 часа назад"
    let petroleIcon3: String = "logo_gasprom"
    let petroleAdress3: String = "ул. Первомайская, 33"
    let petroleLatitude3: Double = 55.793201
    let petroleLongitude3: Double = 37.782071
    let petroleDistance3: Double = 5.3
    
    let petroleTitle4: String = "Газпром"
    let petroleCost4: String = "35,5 ₽"
    let petroleTime4: String = "3 часа назад"
    let petroleIcon4: String = "logo_gasprom"
    let petroleAdress4: String = "Шоссе энтузиастов, 51"
    let petroleLatitude4: Double = 55.773077
    let petroleLongitude4: Double = 37.823859
    let petroleDistance4: Double = 12
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //default Moscow
        let camera = GMSCameraPosition.camera(withLatitude: 55.75, longitude: 37.62, zoom: 13.0)
        mapView.camera = camera
        mapView.setMinZoom(10, maxZoom: 16)
        mapView.isUserInteractionEnabled = true
        mapView.delegate = self
        
        addTopBarView()
        
        //close keyboard
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tap(gesture:)))
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
        
        
        //segment controller
        let segAttributesSelected: NSDictionary = [
            NSForegroundColorAttributeName: UIColor.white,
            NSFontAttributeName: UIFont(name: "helveticaneuecyr-roman", size: 14)!
        ]
        let segAttributes: NSDictionary = [
            NSForegroundColorAttributeName: UIColor(red: (123/255.0), green: (123/255.0), blue: (123/255.0), alpha: 1),
            NSFontAttributeName: UIFont(name: "helveticaneuecyr-roman", size: 14)!
        ]
        segmentView.setTitleTextAttributes(segAttributesSelected as? [AnyHashable : Any], for: .selected)
        segmentView.setTitleTextAttributes(segAttributes as? [AnyHashable : Any], for: .normal)
        
        //add test petrole objects to array
        addPetroleToArray()
        
        //tableview
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        addDarkTriangle()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.navigationController?.isNavigationBarHidden =  true
    }
    
    func addTopBarView() {
        self.view.addSubview(self.topBarView)
        self.topBarView.backgroundColor = UIColor(patternImage: UIImage(named: "bgTopBar2.png")!)
        setTopBarConstraints()
        
        addTitleForTopBarView()
        addProfileIconForTopBarView()
        addSettingsIconForTopBarView()
        addSearchBar()
    }
    
    func addTitleForTopBarView() {
        titleTopBar.textAlignment = .center
        //        titleTopBar.text = Bundle.main.infoDictionary![kCFBundleNameKey as String] as! String
        titleTopBar.text = textTitleToBar
        titleTopBar.textColor = UIColor.white
        titleTopBar.font = UIFont(name: "HelveticaNeueCyr-Medium", size: 17) ?? UIFont.boldSystemFont(ofSize: 17)
        self.topBarView.addSubview(titleTopBar)
        setTitleConstraints()
    }
    
    func addProfileIconForTopBarView() {
        let icon_profile = UIImage(named: "icon_profile")
        btnProfileTopBar.setImage(icon_profile, for: .normal)
        btnProfileTopBar.setImage(icon_profile, for: .selected)
        btnProfileTopBar.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        btnProfileTopBar.tag = 1
        
        self.topBarView.addSubview(btnProfileTopBar)
        setProfileIconConstraints()
    }
    
    func addSettingsIconForTopBarView() {
        let icon_profile = UIImage(named: "icon_settings")
        btnSettingsTopBar.setImage(icon_profile, for: .normal)
        btnSettingsTopBar.setImage(icon_profile, for: .selected)
        btnSettingsTopBar.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        btnSettingsTopBar.tag = 2
        
        self.topBarView.addSubview(btnSettingsTopBar)
        setSettingsIconConstraints()
    }
    
    func addSearchBar() {
        let frameCustomSearchBar = CGRect()
        let fontCustomSearchBar = UIFont(name: "HelveticaNeueCyr-LightItalic", size: 14) ?? UIFont.italicSystemFont(ofSize: 14)
        
        
        customSearchBar = SearchTextField(frame: frameCustomSearchBar, tintText: NSLocalizedString("find_petrole", comment: ""), tintFont: fontCustomSearchBar, tintTextColor: searchBarTextColor)
        customSearchBar.isUserInteractionEnabled = true
        customSearchBar.isEnabled = true
        self.topBarView.addSubview(customSearchBar)
        setSearchBarConstraints()
        
        let iconPinImage = UIImage(named: "icon_pin")
        iconPinView.setImage(iconPinImage, for: .normal)
        iconPinView.setImage(iconPinImage, for: .selected)
        iconPinView.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        iconPinView.tag = 3
        iconPinView.frame = CGRect(x: 10, y: 10, width: 12, height: 20)
        customSearchBar.addSubview(iconPinView)
        
        let iconAddImage = UIImage(named: "icon_add")
        iconAddView.setImage(iconAddImage, for: .normal)
        iconAddView.setImage(iconAddImage, for: .selected)
        iconAddView.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        iconAddView.tag = 4
        customSearchBar.addSubview(iconAddView)
        setIconAddViewConstraints()
        
    }
    
    func buttonAction(sender: UIButton!) {
        let btnSendTag: UIButton = sender
        
        switch btnSendTag.tag {
        case 1:
            GlobalVariables.clickString = "profile icon clicked"
            break
        case 2:
            GlobalVariables.clickString = "settings icon clicked"
            break
        case 3:
            GlobalVariables.clickString = "pin search icon clicked"
            break
        case 4:
            GlobalVariables.clickString = "add search icon clicked"
            break
        case 5:
            GlobalVariables.clickString = "like marker icon clicked"
            break
        case 6:
            GlobalVariables.clickString = "direction marker icon clicked"
            break
        default:
            break
        }
        performSegue(withIdentifier: "click", sender: nil)
    }
    
    func setTopBarConstraints() {
        self.topBarView.translatesAutoresizingMaskIntoConstraints = false
        
        let leftConstraint = NSLayoutConstraint(item: self.topBarView, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1.0, constant: 0)
        let rightConstraint = NSLayoutConstraint(item: self.topBarView, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1.0, constant: 0)
        let topConstraint = NSLayoutConstraint(item: self.topBarView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1.0, constant: 0)
        let heightConstraint = NSLayoutConstraint(item: self.topBarView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 113)
        
        self.view.addConstraint(leftConstraint)
        self.view.addConstraint(rightConstraint)
        self.view.addConstraint(topConstraint)
        self.topBarView.addConstraint(heightConstraint)
        
    }
    
    func setTitleConstraints() {
        self.titleTopBar.translatesAutoresizingMaskIntoConstraints = false
        let x = NSLayoutConstraint(item: self.titleTopBar, attribute: .centerX, relatedBy: .equal, toItem: self.topBarView, attribute: .centerX, multiplier: 1.0, constant: 0)
        let y = NSLayoutConstraint(item: self.titleTopBar, attribute: .top, relatedBy: .equal, toItem: self.topBarView, attribute: .top, multiplier: 1.0, constant: 30)
        let w = NSLayoutConstraint(item: self.titleTopBar, attribute: .width, relatedBy: .equal, toItem: self.topBarView, attribute: .width, multiplier: 0.6, constant: 0)
        let h = NSLayoutConstraint(item: self.titleTopBar, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 24)
        self.topBarView.addConstraints([x, y, w])
        self.titleTopBar.addConstraints([h])
    }
    
    func setProfileIconConstraints() {
        self.btnProfileTopBar.translatesAutoresizingMaskIntoConstraints = false
        let x = NSLayoutConstraint(item: self.btnProfileTopBar, attribute: .leading, relatedBy: .equal, toItem: self.topBarView, attribute: .leading, multiplier: 1.0, constant: 10)
        let y = NSLayoutConstraint(item: self.btnProfileTopBar, attribute: .top, relatedBy: .equal, toItem: self.topBarView, attribute: .top, multiplier: 1.0, constant: 30)
        let w = NSLayoutConstraint(item: self.btnProfileTopBar, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 24)
        let h = NSLayoutConstraint(item: self.btnProfileTopBar, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 24)
        
        self.topBarView.addConstraints([x, y])
        self.btnProfileTopBar.addConstraints([h, w])
    }
    
    func setSettingsIconConstraints() {
        self.btnSettingsTopBar.translatesAutoresizingMaskIntoConstraints = false
        let x = NSLayoutConstraint(item: self.btnSettingsTopBar, attribute: .trailing, relatedBy: .equal, toItem: self.topBarView, attribute: .trailing, multiplier: 1.0, constant: -10)
        let y = NSLayoutConstraint(item: self.btnSettingsTopBar, attribute: .top, relatedBy: .equal, toItem: self.topBarView, attribute: .top, multiplier: 1.0, constant: 30)
        let w = NSLayoutConstraint(item: self.btnSettingsTopBar, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 24)
        let h = NSLayoutConstraint(item: self.btnSettingsTopBar, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 24)
        
        self.topBarView.addConstraints([x, y])
        self.btnSettingsTopBar.addConstraints([h, w])
    }
    
    func setSearchBarConstraints() {
        self.customSearchBar.translatesAutoresizingMaskIntoConstraints = false
        let xLeft = NSLayoutConstraint(item: self.customSearchBar, attribute: .leading, relatedBy: .equal, toItem: self.topBarView, attribute: .leading, multiplier: 1.0, constant: 10)
        let xRight = NSLayoutConstraint(item: self.customSearchBar, attribute: .trailing, relatedBy: .equal, toItem: self.topBarView, attribute: .trailing, multiplier: 1.0, constant: -10)
        let y = NSLayoutConstraint(item: self.customSearchBar, attribute: .bottom, relatedBy: .equal, toItem: self.topBarView, attribute: .bottom, multiplier: 1.0, constant: 0)
        let h = NSLayoutConstraint(item: self.customSearchBar, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 43)
        self.topBarView.addConstraints([xLeft, xRight, y])
        self.customSearchBar.addConstraint(h)
    }
    
    func setIconAddViewConstraints() {
        self.iconAddView.translatesAutoresizingMaskIntoConstraints = false
        let x = NSLayoutConstraint(item: self.iconAddView, attribute: .trailing, relatedBy: .equal, toItem: self.customSearchBar, attribute: .trailing, multiplier: 1.0, constant: -10)
        let y = NSLayoutConstraint(item: self.iconAddView, attribute: .top, relatedBy: .equal, toItem: self.customSearchBar, attribute: .top, multiplier: 1.0, constant: 10)
        let w = NSLayoutConstraint(item: self.iconAddView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 20)
        let h = NSLayoutConstraint(item: self.iconAddView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 20)
        
        self.customSearchBar.addConstraints([x, y])
        self.iconAddView.addConstraints([w, h])
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.becomeFirstResponder()
    }
    
    @IBAction func sliderBottomRecognize(_ sender: UIPanGestureRecognizer) {
        if sender.state == .began || sender.state == .changed {
            let translation = sender.translation(in: self.view)
            if translation.y < 0 {
                if (heightBottomSliderConstraint.constant - translation.y) > 260 {
                    heightBottomSliderConstraint.constant = 326
                }
                else {
                    heightBottomSliderConstraint.constant -= translation.y
                }
            }
            else {
                if (heightBottomSliderConstraint.constant - translation.y) < 160 {
                    heightBottomSliderConstraint.constant = 126
                }
                else {
                    heightBottomSliderConstraint.constant -= translation.y
                }
            }
            sender.setTranslation(CGPoint.zero, in: self.view)
        }
    }
    
    @IBAction func segmentBottomRecognize(_ sender: UIPanGestureRecognizer) {
        if sender.state == .began || sender.state == .changed {
            let translation = sender.translation(in: self.view)
            if translation.x < 0 {
                if self.segmentView.selectedSegmentIndex != 1 {
                    self.segmentView.selectedSegmentIndex = 1
                    changeTrianglePosition()
                }
            }
            else if translation.x > 0 {
                if self.segmentView.selectedSegmentIndex != 0 {
                    self.segmentView.selectedSegmentIndex = 0
                    changeTrianglePosition()
                }
            }
            sender.setTranslation(CGPoint.zero, in: self.view)
        }
    }
    
    @IBAction func indexChanged(_ sender: UISegmentedControl) {
        changeTrianglePosition()
    }
    
    func changeTrianglePosition() {
        switch self.segmentView.selectedSegmentIndex {
        case 0:
            xTriangle.constant = self.tableView.frame.width / 4
            break
        case 1:
            xTriangle.constant = self.tableView.frame.width / 4 * 3
            break
        default:
            break
        }
    }
    
    func addPetroleToArray() {
        let petrole1 = Petrole(title: petroleTitle, cost: petroleCost, time: petroleTime, icon: petroleIcon, adress: petroleAdress, distance: petroleDistance, lat: petroleLatitude, long: petroleLongitude)
        let petrole2 = Petrole(title: petroleTitle2, cost: petroleCost2, time: petroleTime2, icon: petroleIcon2, adress: petroleAdress2, distance: petroleDistance2, lat: petroleLatitude2, long: petroleLongitude2)
        let petrole3 = Petrole(title: petroleTitle3, cost: petroleCost3, time: petroleTime3, icon: petroleIcon3, adress: petroleAdress3, distance: petroleDistance3, lat: petroleLatitude3, long: petroleLongitude3)
        let petrole4 = Petrole(title: petroleTitle4, cost: petroleCost4, time: petroleTime4, icon: petroleIcon4, adress: petroleAdress4, distance: petroleDistance4, lat: petroleLatitude4, long: petroleLongitude4)
        petroleArray.append(contentsOf: [petrole1, petrole2, petrole3, petrole4])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 61
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petroleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "PetroleCell") as! PetroleCell!
        if cell == nil {
            cell = PetroleCell(style: UITableViewCellStyle.default, reuseIdentifier: "PetroleCell")
        }
        
        let rowElement = petroleArray[(indexPath as NSIndexPath).row]
        cell?.title.text = rowElement.title
        cell?.cost.text = rowElement.cost
        cell?.time.setTextWithLineSpacing(text: "\(rowElement.time)")
        cell?.icon.image = UIImage(named: rowElement.icon)
        cell?.adress.text = rowElement.adress
        cell?.distance.text = "\(rowElement.distance) км"
        cell?.bgDirection.addBackground(width: (cell?.bgDirection.bounds.width)!, height: (cell?.bgDirection.bounds.height)!)
        cell?.direction.image = UIImage(named: "icon_direction")
        
        let separatorView = UIView(frame: CGRect(x: 0, y: 60, width: self.tableView.bounds.size.width, height: 1))
        separatorView.backgroundColor = UIColor(red: (225/255.0), green: (218/255.0), blue: (197/255.0), alpha: 1)
        cell?.addSubview(separatorView)
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.mapView.clear()
        let rowElement = petroleArray[(indexPath as NSIndexPath).row]
        let selectedCell: PetroleCell = tableView.cellForRow(at: indexPath)! as! PetroleCell
        selectedCell.contentView.backgroundColor = UIColor(red: (208/255.0), green: (206/255.0), blue: (206/255.0), alpha: 1)
        setMarker(lat: rowElement.latitude, lon: rowElement.longitude, adress: rowElement.adress, price: rowElement.cost, logo: rowElement.icon)
    }
    
    func addDarkTriangle() {
        let triangleView = UIImageView(image: UIImage(named: "triangle"))
        self.tableView.addSubview(triangleView)
        
        triangleView.translatesAutoresizingMaskIntoConstraints = false
        xTriangle = NSLayoutConstraint(item: triangleView, attribute: .leading, relatedBy: .equal, toItem: self.tableView, attribute: .leading, multiplier: 1.0, constant: self.tableView.frame.width / 4)
        let y = NSLayoutConstraint(item: triangleView, attribute: .top, relatedBy: .equal, toItem: self.tableView, attribute: .top, multiplier: 1.0, constant: 0)
        let w = NSLayoutConstraint(item: triangleView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 8)
        let h = NSLayoutConstraint(item: triangleView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 4)
        
        self.tableView.addConstraints([xTriangle, y])
        triangleView.addConstraints([w, h])

    }
    
    func setMarker(lat: Double, lon: Double, adress: String, price: String, logo: String) {
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: lon, zoom: self.mapView.camera.zoom)
        self.mapView.camera = camera
        
        self.markerInfoWindow.removeFromSuperview()
        marker = GMSMarker()
        marker.iconView = UIView()
        marker.position = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        markerInfoWindow = CustomMarkerView(frame: CGRect(x: 0, y: 0, width: 301, height: 36))
        marker.map = self.mapView
        
        
        let location = CLLocationCoordinate2D(latitude: self.marker.position.latitude, longitude: self.marker.position.longitude)
        self.markerInfoWindow = CustomMarkerView(frame: CGRect(x: 0, y: 0, width: 301, height: 36))
        markerInfoWindow.center = mapView.projection.point(for: location)
        addInternalElements(adress: adress, price: price, logo: logo)
        
        self.view.addSubview(markerInfoWindow)
        self.view.bringSubview(toFront: bottomListSlider)
    }
    

    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        return UIView()
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        return false
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        let location = CLLocationCoordinate2D(latitude: self.marker.position.latitude, longitude: self.marker.position.longitude)
        markerInfoWindow.center = mapView.projection.point(for: location)
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        self.markerInfoWindow.removeFromSuperview()
    }
    
    
    func addInternalElements(adress: String, price: String, logo: String) {
        let logoView = UIView()
        
        let logoImg = UIImage(named: logo)
        let logoImage = UIImageView(image: logoImg)
        logoView.addSubview(logoImage)
        setMarkerLogoConstraint(logoView: logoView, logoImage: logoImage)
        
        let adressLabel = UILabel()
        adressLabel.font = UIFont(name: "helveticaneuecyr-roman", size: 9)!
        adressLabel.textColor = UIColor.white
        adressLabel.numberOfLines = 2
        adressLabel.text = adress
        
        let priceLabel = UILabel()
        priceLabel.font = UIFont(name: "helveticaneuecyr-roman", size: 11.2)!
        priceLabel.textColor = UIColor.white
        priceLabel.numberOfLines = 2
        priceLabel.text = price
        
        let icon_like = UIImage(named: "icon_like")
        let likeBtn = UIButton()
        likeBtn.setImage(icon_like, for: .normal)
        likeBtn.setImage(icon_like, for: .selected)
        likeBtn.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        likeBtn.tag = 5
        likeBtn.isMultipleTouchEnabled = true
        likeBtn.isUserInteractionEnabled = true
        
        let icon_direction = UIImage(named: "icon_direction_light")
        let directBtn = UIButton()
        directBtn.setImage(icon_direction, for: .normal)
        directBtn.setImage(icon_direction, for: .selected)
        directBtn.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        directBtn.tag = 6
        directBtn.isMultipleTouchEnabled = true
        directBtn.isUserInteractionEnabled = true

        self.markerInfoWindow.addSubview(logoView)
        self.markerInfoWindow.addSubview(adressLabel)
        self.markerInfoWindow.addSubview(priceLabel)
        self.markerInfoWindow.addSubview(likeBtn)
        self.markerInfoWindow.addSubview(directBtn)
        
        setLogoViewMarkerConstraints(logoView: logoView)
        setAdressMarkerConstraints(label: adressLabel, logoView: logoView)
        setPriceMarkerConstraints(label: priceLabel, logoView: logoView)
        setLikeBtnMarkerConstraints(btn: likeBtn)
        setDirectBtnMarkerConstraints(btn: directBtn)
    }
    
    
    @IBAction func handlePan(recognizer:UIPanGestureRecognizer) {
    }
    
    func setLogoViewMarkerConstraints(logoView: UIView) {
        logoView.translatesAutoresizingMaskIntoConstraints = false
        let x = NSLayoutConstraint(item: logoView, attribute: .trailing, relatedBy: .equal, toItem: self.markerInfoWindow, attribute: .trailing, multiplier: 1.0, constant: -168)
        let y = NSLayoutConstraint(item: logoView, attribute: .top, relatedBy: .equal, toItem: self.markerInfoWindow, attribute: .top, multiplier: 1.0, constant: 0)
        let w = NSLayoutConstraint(item: logoView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 31)
        let h = NSLayoutConstraint(item: logoView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 30)
        self.markerInfoWindow.addConstraints([x, y])
        logoView.addConstraints([w, h])
    }
    
    func setMarkerLogoConstraint(logoView: UIView, logoImage: UIView) {
        logoImage.translatesAutoresizingMaskIntoConstraints = false
        let x = NSLayoutConstraint(item: logoImage, attribute: .centerX, relatedBy: .equal, toItem: logoView, attribute: .centerX, multiplier: 1.0, constant: 0)
        let y = NSLayoutConstraint(item: logoImage, attribute: .centerY, relatedBy: .equal, toItem: logoView, attribute: .centerY, multiplier: 1.0, constant: 0)
        let w = NSLayoutConstraint(item: logoImage, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: logoImage.frame.size.width / 2 * 0.83)
        let h = NSLayoutConstraint(item: logoImage, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: logoImage.frame.size.width / 2 * 0.83)
        logoView.addConstraints([x, y])
        logoImage.addConstraints([w, h])
    }
    
    func setAdressMarkerConstraints(label: UILabel, logoView: UIView) {
        label.translatesAutoresizingMaskIntoConstraints = false
        let x = NSLayoutConstraint(item: label, attribute: .leading, relatedBy: .equal, toItem: logoView, attribute: .trailing, multiplier: 1.0, constant: 6)
        let y = NSLayoutConstraint(item: label, attribute: .top, relatedBy: .equal, toItem: self.markerInfoWindow, attribute: .top, multiplier: 1.0, constant: 5)
        let w = NSLayoutConstraint(item: label, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 110)
        let h = NSLayoutConstraint(item: label, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 12)
        self.markerInfoWindow.addConstraints([x, y])
        label.addConstraints([w, h])
    }
    
    func setPriceMarkerConstraints(label: UILabel, logoView: UIView) {
        label.translatesAutoresizingMaskIntoConstraints = false
        let x = NSLayoutConstraint(item: label, attribute: .leading, relatedBy: .equal, toItem: logoView, attribute: .trailing, multiplier: 1.0, constant: 6)
        let y = NSLayoutConstraint(item: label, attribute: .top, relatedBy: .equal, toItem: self.markerInfoWindow, attribute: .top, multiplier: 1.0, constant: 15)
        let w = NSLayoutConstraint(item: label, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 110)
        let h = NSLayoutConstraint(item: label, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 15)
        self.markerInfoWindow.addConstraints([x, y])
        label.addConstraints([w, h])
 
    }
    
    func setLikeBtnMarkerConstraints(btn: UIButton) {
        btn.translatesAutoresizingMaskIntoConstraints = false
        let x = NSLayoutConstraint(item: btn, attribute: .trailing, relatedBy: .equal, toItem: self.markerInfoWindow, attribute: .trailing, multiplier: 1.0, constant: -35)
        let y = NSLayoutConstraint(item: btn, attribute: .top, relatedBy: .equal, toItem: self.markerInfoWindow, attribute: .top, multiplier: 1.0, constant: 8)
        let w = NSLayoutConstraint(item: btn, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 15)
        let h = NSLayoutConstraint(item: btn, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 15)
        self.markerInfoWindow.addConstraints([x, y])
        btn.addConstraints([w, h])
    }
    
    func setDirectBtnMarkerConstraints(btn: UIButton) {
        btn.translatesAutoresizingMaskIntoConstraints = false
        let x = NSLayoutConstraint(item: btn, attribute: .trailing, relatedBy: .equal, toItem: self.markerInfoWindow, attribute: .trailing, multiplier: 1.0, constant: -10)
        let y = NSLayoutConstraint(item: btn, attribute: .top, relatedBy: .equal, toItem: self.markerInfoWindow, attribute: .top, multiplier: 1.0, constant: 8)
        let w = NSLayoutConstraint(item: btn, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 15)
        let h = NSLayoutConstraint(item: btn, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 15)
        self.markerInfoWindow.addConstraints([x, y])
        btn.addConstraints([w, h])
    }
    
    func tap(gesture: UITapGestureRecognizer) {
        self.customSearchBar.resignFirstResponder()
    }
}

extension UIView {
    func addBackground(width: CGFloat, height: CGFloat) {
        // screen width and height:
        
        let imageViewBackground = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        imageViewBackground.image = UIImage(named: "bg_distance")
        
        // you can change the content mode:
        imageViewBackground.contentMode = UIViewContentMode.scaleAspectFill
        
        self.addSubview(imageViewBackground)
        self.sendSubview(toBack: imageViewBackground)
    }
}

extension UILabel {
    func setTextWithLineSpacing(text: String, lineHeightMultiply: CGFloat = 0.95) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = lineHeightMultiply
        paragraphStyle.alignment = .center
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
        self.attributedText = attributedString
    }
}





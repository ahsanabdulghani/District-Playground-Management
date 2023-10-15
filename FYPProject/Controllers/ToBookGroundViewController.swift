//
//  ToBookGroundViewController.swift
//  FYPProject
//
//  Created by apple on 19/01/2023.
//

import UIKit

class ToBookGroundViewController: UIViewController {
    
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtGroundType: UITextField!
    @IBOutlet weak var txtArea: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
   

    @IBOutlet weak var logoutlbl: UIButton!
  //  var gid = 0
    var facilityList = [Facility]()
 //   var mymanageGrounds = [Manageground]()
 //   let manageGroundsMgr = managegroundManager()
 //   let oid = LoginViewController.loggedInUser.id
    
    var cityList = [String]()
    var groupTypeList = [String]()
    
    var picker = UIPickerView()
    var isForCity = false
    var fromDate = String()
    var toDate = String()
    var startTime = String()
    var endTime = String()
    var groundList = [Ground]()

 
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
//        txtCity.text = "Rawalpindi"
//        txtGroundType.text = "Cricket"
//        txtArea.text = "Shamsabad"
        
        cityList = ["Islamabad", "Rawalpindi", "Lahore", "Karachi", "Multan", "Quetta"]
        groupTypeList = ["FootBall", "Cricket", "Hockey"]
        
        txtCity.delegate = self
        txtGroundType.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        setUpPickerView()
        
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "yyyy-MM-dd"
        fromDate = dateFormatter1.string(from: Date())
        print(fromDate)
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "yyyy-MM-dd"
        toDate = dateFormatter2.string(from: Date())
        print(toDate)
        dateFormatter1.dateFormat = "HH:mm"
        startTime = dateFormatter1.string(from: Date())
        print(startTime)
        endTime = dateFormatter1.string(from: Date())
        print(endTime)
        
        
        collectionView.delegate = self
        collectionView.dataSource = self
        getFacilities()
//        if let manageGrounds = manageGroundsMgr.managegrounds(oid: oid) {
//                mymanageGrounds = manageGrounds
//            dump(mymanageGrounds)
//        }
        
    
    
    }
    
    
    func getFacilities() {
        let api = APIWrapper();
        let response =  api.getMethodCall(controllerName: "apiplayground", actionName: "flist")
        if response.ResponseCode == 200 {
            do {
                facilityList = try JSONDecoder().decode([Facility].self, from: response.ResponseData!)
                print(facilityList)
                collectionView.reloadData()
            }
            catch {
                print("error: \(error)")
            }
        }
        else{
            print(response.ResponseMessage)
        }
    }

    func setUpPickerView() {
        picker = UIPickerView(frame: CGRect(x: 0, y: 200, width: view.frame.width, height: 300))
        picker.backgroundColor = .white

        picker.delegate = self
        picker.dataSource = self

        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.sizeToFit()

        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)

        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true

        txtCity.inputView = picker
        txtCity.inputAccessoryView = toolBar
        txtGroundType.inputView = picker
        txtGroundType.inputAccessoryView = toolBar
    }
    
    @objc func donePicker() {
        view.endEditing(true)
    }
    
    @IBAction func onClickLogoutBtn(_ sender: Any) {
//        let controller = self.storyboard?.instantiateViewController(identifier: "displayhomeviewpage") as! HomeViewController
//        self.navigationController?.pushViewController(controller, animated: true)
        APIWrapper.userData = Login()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
               let controller = storyboard.instantiateViewController(withIdentifier: "displayhomeviewpage")
        let navigationController = UINavigationController(rootViewController: controller)
               UIApplication.shared.windows.first?.rootViewController = navigationController
    }
    
//    @IBAction func onClickBackBtn(_ sender: Any) {
//        self.navigationController?.popViewController(animated: true)
//    }
    
    @IBAction func onClickFromDatePickerBtn(_ sender: UIDatePicker) {
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "yyyy-MM-dd"
        
        fromDate = dateFormatter1.string(from: sender.date)
        print(fromDate)
    }
    
    @IBAction func onClickToDatePickerBtn(_ sender: UIDatePicker) {
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "yyyy-MM-dd"
        
        toDate = dateFormatter2.string(from: sender.date)
        print(toDate)
    }
    @IBAction func onClickStartTimePickerBtn(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        startTime = dateFormatter.string(from: sender.date)
        print(startTime)
    }
    
    @IBAction func onClickEndTimePickerBtn(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        endTime = dateFormatter.string(from: sender.date)
        print(endTime)
    }
    
    @IBAction func onClickMyBookingsBtn(_ sender: Any) {
        let id = APIWrapper.userData.id
        if id == 0 {
            let controller = self.storyboard?.instantiateViewController(identifier: "displayloginpage") as! LoginViewController
            controller.callBack = { [self] isSuccess in
                if isSuccess {
                    DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                        let controller = self.storyboard?.instantiateViewController(identifier: "MyBookingHistoryViewpage") as! MyBookingHistoryViewController
                        self.navigationController?.pushViewController(controller, animated: true)
                    })
                
                }
            }
            controller.isForLogin = true
            
            self.navigationController?.pushViewController(controller, animated: true)
        }
        else {
            let controller = self.storyboard?.instantiateViewController(identifier: "MyBookingHistoryViewpage") as! MyBookingHistoryViewController
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    @IBAction func onClickSearchBtn(_ sender: Any) {
        if txtCity.text != "" && txtGroundType.text != "" && txtArea.text != "" {
            var str = ""
            var tempList = [Facility]()
            for i in facilityList.indices {
                if facilityList[i].isSelected ?? false {
                    tempList.append(facilityList[i])
                }
            }
            for i in tempList.indices {
                if tempList.count == i+1 {
                    str = str + "\(tempList[i].id ?? 0)"
                }
                else {
                    str = str + "\(tempList[i].id ?? 0),"
                }
            }
            print(str)
            
            let ground = GroundRequest()
            ground.city = txtCity.text!
            ground.area = txtArea.text!
            ground.gtype = txtGroundType.text!
            ground.stime = startTime
            ground.etime = endTime
            ground.fromdate = fromDate
            ground.todate = toDate
            ground.facilities = str
            
            let manager = GroundManager()
            groundList = manager.AvailableGrounds(ground: ground)
            print(groundList)
            tableView.reloadData()
        }
        else {
            let alert = UIAlertController(title: "Alert", message: "Please fill all the fields", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
extension ToBookGroundViewController: UIPickerViewDataSource, UIPickerViewDelegate {

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if isForCity {
            return cityList.count
        }
        return groupTypeList.count
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if isForCity {
            return cityList[row]
        }
        return groupTypeList[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if isForCity {
            txtCity.text = cityList[row]
        }
        else {
            txtGroundType.text = groupTypeList[row]
        }
        picker.reloadAllComponents()
    }
}
extension ToBookGroundViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == txtCity {
            isForCity = true
        }
        else {
            isForCity = false
        }
        return true
    }
}
extension ToBookGroundViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groundList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroundTableViewCell", for: indexPath) as! GroundTableViewCell
        
        cell.imgView.image = Utilities.getImageFromURL(name: groundList[indexPath.row].image ?? "")
        cell.lblTitle.text = groundList[indexPath.row].gname
        
        cell.groundDetail = groundList[indexPath.row]
        cell.collectionView.reloadData()
        
        cell.vRating.setRatingValue(rateValue: groundList[indexPath.row].averagerating ?? 0.0)
        
        cell.btnBook.tag = indexPath.row
        cell.btnBook.addTarget(self, action: #selector(onClickBookBtn), for: .touchUpInside)
        
        cell.lblReviews.text = "Reviews : \(groundList[indexPath.row].totalreviews ?? 0)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchStadiumViewController") as! SearchStadiumViewController
        vc.groundData = groundList[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: false)
    }
   
    @objc func onClickBookBtn(_ sender: UIButton) {
        let controller = self.storyboard?.instantiateViewController(identifier: "BookingdetailsViewpage") as! BookingdetailsViewController
        controller.gid = groundList[sender.tag].gid ?? 0
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
extension ToBookGroundViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return facilityList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FacilityCollectionViewCell", for: indexPath) as! FacilityCollectionViewCell
        
        let data = facilityList[indexPath.row]
        cell.lblName.text = data.name
        
        if data.isSelected ?? false {
            cell.imgView.image = UIImage(systemName: "checkmark.square")
        }
        else {
            cell.imgView.image = UIImage(systemName: "square")
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 160, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if facilityList[indexPath.row].isSelected ?? false {
            facilityList[indexPath.row].isSelected = false
        }
        else {
            facilityList[indexPath.row].isSelected = true
        }
        collectionView.reloadData()
    }
    
}

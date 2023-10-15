//
//  AddGroundDetailViewController.swift
//  FYPProject
//
//  Created by apple on 18/01/2023.
//

import UIKit
import DropDown
class AddGroundDetailViewController: UIViewController ,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource {
  var checkId=[Int]()
//    var selectedFacilities: [fname] = []
    
    let gm = GroundManager()
  //  let ground : [Ground] = []
    
    @IBOutlet weak var tableview: UITableView!
    

    @IBOutlet weak var txtgroundname: UITextField!
    @IBOutlet weak var txtaddress: UITextField!
    @IBOutlet weak var txtarea: UITextField!
    @IBOutlet weak var txtcity: UITextField!
    @IBOutlet weak var txtcontact: UITextField!
    @IBOutlet weak var txtdescription: UITextField!
    @IBOutlet weak var addbtn: UIButton!
    @IBOutlet weak var txtcapacity: UITextField!
    
    
    
    @IBOutlet weak var sideMenuItem: UIBarButtonItem!
    @IBAction func dropDownClicked(_ sender: Any) {
        dropDown.show()
        
    }
   
    @IBOutlet weak var dropDownLabel: UILabel!
    @IBOutlet weak var dropDownView: UIView!
    @IBAction func dropDown2Clicked(_ sender: Any) {
        dropDown2.show()
        
    }
    @IBOutlet weak var dropDown2Label: UILabel!
    @IBOutlet weak var dropDown2View: UIView!
    //create variable of dropDown
    let dropDown = DropDown()
    let dropDown2 = DropDown()
    
    public var caller = ManageGroundViewController()
  //  var isForUpdate = false
  //  var id = Int()
    
    @IBAction func btnchkfacility(_ sender: Any) {
        
        let c = (sender as AnyObject).superview?.superview as? FacilitiesTableViewCell

        if c?.chkfacility.isSelected==true
        {
            c?.chkfacility.isSelected=false
            var senderbtn=sender as! UIButton
            var id=facilitynamelist[senderbtn.tag].id
            checkId=checkId.filter{$0 != facilitynamelist[senderbtn.tag].id}
        }
        else
        {
            c?.chkfacility.isSelected=true
            var senderbtn=sender as! UIButton
            checkId.append(senderbtn.tag)
        }
        
    }
    
        @IBOutlet weak var imgViewProfile: UIImageView!
        @IBAction func chooseimage(_ sender: Any) {
            let imageController = UIImagePickerController()
            imageController.delegate = self
            present(imageController, animated: true,completion: nil)
        }
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            print("Image selected")
            
            let selectedImage = info[.originalImage]
            self.imgViewProfile.image = selectedImage as! UIImage
            
            picker.dismiss(animated: true, completion: nil)
        }
    @IBAction func Addbtn(_ sender: Any) {
        
      guard let gname = txtgroundname.text,
            let city = txtcity.text,
            let area = txtarea.text,
            let capacity = txtcapacity.text,
            let gtype = dropDown2Label.text,
            let contact = txtcontact.text,
     //       let image = imgViewProfile.text,
            let address = txtaddress.text,
            let description = txtdescription.text,
            let size = dropDownLabel.text
            
      //      let ownerid = LoginViewController.loggedInUser.id
            
        else {
                return
             }
        
        if(txtgroundname.text! == "" || txtcity.text! == "" || txtarea.text! == "" || txtcontact.text! == "" || txtaddress.text! == "" || txtdescription.text! == "" || txtcapacity.text! == "" || dropDown2Label.text! == "Select Ground Type" || dropDownLabel.text! == "Select Ground Size")
               {
                  
            let titleString = NSAttributedString(string: "Alert!!!", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])

            let alert = UIAlertController(title: nil, message: "All Fields are Required", preferredStyle: .alert)
            alert.setValue(titleString, forKey: "attributedTitle")
                   alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                   self.present( alert, animated: true, completion: nil);
               }

//        let newGround = Ground(image: "", gname: gname, city: city, area: area,capacity: capacity,gtype: gtype,contact: contact,size: size,description: description,address: address, ownerid: LoginViewController.loggedInUser.id)

        else{
        var params = [String: String]()
        params["gname"] = gname
        params["city"] = city
        params["area"] = area
        params["capacity"] = capacity
        params["gtype"] = gtype
        params["contact"] = contact
        params["size"] = size
        params["description"] = description
        params["address"] = address
        params["ownerid"] = String(LoginViewController.loggedInUser.id)
            // Convert the selected facilities to a comma-separated string
//           let facilityIds = checkId.map { String($0) }
//            let facilitiesString = "[\(facilityIds.joined(separator: ","))]"
////            for i in checkId
////            {
////                params["facility"] = String(i)
////            }
//          //  params["facility"] = checkId.map { String($0) }.joined(separator: ",")
//            params["facility[]"] = facilitiesString
//
//            //params["facility"] = check
//            let facilityIds = selectedFacilities.map { String($0.id ?? 0) }
//                params["facility"] = facilityIds.joined(separator: ",")
            var str = ""
            var tempList = [Facility]()
            for i in facilitynamelist.indices {
                if facilitynamelist[i].isSelected ?? false {
                    tempList.append(facilitynamelist[i])
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
            params["facility"] = str
            print(params["facility"])
        
//        print("***", facilityIds)
//            print("***", facilityIds.joined(separator: ","))
        var images = [Media]()
        images.append(Media(withImage: self.imgViewProfile.image!, forKey: "image", imageName: "image.jpeg")!)
        
//            let api = APIWrapper()
//            if isForUpdate {
//                let response = api.uploadImageToServer(images: images, parameters: params, endPoint: "apiplayground/Edit")
//                if response.ResponseCode == 200{
//
//                    print("Ground Updated successfully")
//                    let myAlert = UIAlertController(title: "Alert", message: "Ground Updated Successfully", preferredStyle: UIAlertController.Style.alert);
//
//                    myAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
//                    self.present( myAlert, animated: true, completion: nil);
//
//                    self.caller.reloadData()
//                }
//
//                else{
//                    print("\(response.ResponseMessage)")
//                }
//            }
            let api = APIWrapper()
           let response = api.uploadImageToServer(images: images, parameters: params, endPoint: "apiplayground/Addground")
                if response.ResponseCode == 200{
                    print("Ground added successfully")
                    let myAlert = UIAlertController(title: "Alert", message: "Ground Added Successfully", preferredStyle: UIAlertController.Style.alert);
                    myAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                    self.present( myAlert, animated: true, completion: nil);
                }
                
                else{
                    print("\(response.ResponseMessage)")
                }
                
            
        
        //let response = gm.GroundPost(newGround: newGround)
//       { groupns in
//                        // Signup successful, do something
//
//        if response != nil
//        {
//           print("Grounds added successfully")
//
//        }
//        else
//        {
//            print(gm.message)
//        }
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        facilitiesfromdatabase()
      //  gm.GroundPost(gname: )
        navigationController?.navigationBar.tintColor = .white
        sideMenuItem.target = revealViewController()
        sideMenuItem.action = #selector(revealViewController()?.revealSideMenu)
        //assign viewOutlet to
        dropDown.anchorView = dropDownView
        dropDown2.anchorView = dropDown2View
        //set data source
        dropDown.dataSource = ["120*150", "150*150",
        "200*200"]
        dropDown2.dataSource = ["Cricket", "Football",
                                
        "Basketball"]

            // Top of drop down will be below the anchorView
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown2.bottomOffset = CGPoint(x: 0, y:(dropDown2.anchorView?.plainView.bounds.height)!)

            // Action triggered on selection
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
        self.dropDownLabel.text = item }
        dropDown2.selectionAction = { [unowned self] (index: Int, item: String) in
        self.dropDown2Label.text = item }

          dropDownView.layer.borderWidth = 2
            dropDownView.layer.borderColor = UIColor.black.cgColor
            dropDownView.layer.cornerRadius = 5
        dropDown2View.layer.borderWidth = 2
          dropDown2View.layer.borderColor = UIColor.black.cgColor
          dropDown2View.layer.cornerRadius = 5
//            dropDown.backgroundColor = UIColor.gray
//            dropDown.animationduration = 0.3
//        dropDown2.backgroundColor = UIColor.gray
//        dropDown2.animationduration = 0.3

        addbtn.layer.cornerRadius=15
        txtgroundname.layer.cornerRadius=15
        txtcontact.layer.cornerRadius=15
        txtaddress.layer.cornerRadius=15
        txtarea.layer.cornerRadius=15
        txtcapacity.layer.cornerRadius=15
        txtcity.layer.cornerRadius=15
        txtdescription.layer.cornerRadius=15
       // availablefacilitiesview.layer.cornerRadius=15
        
//        if isForUpdate {
//            addbtn.setTitle("Update", for: .normal)
//
//            var editedGround: Manageground? = nil
//            var api = APIWrapper()
//            let result = api.getMethodCall(controllerName: "apiplayground", actionName: "Edit/\(id)")
//            if result.ResponseCode == 200 {
//                var data = try! JSONDecoder().decode([Managegroun].self, from: result.ResponseData!)
//                txtarea.text=data[0].area
//                txtaddress.text=data[0].address
//                txtcontact.text=data[0].contact
//                txtcity.text=data[0].city
//                txtdescription.text=data[0].description
//                txtcapacity.text=String(data[0].capacity!)
//                txtgroundname.text=data[0].gname
//                dropDown2Label.text=data[0].gtype
//                dropDownLabel.text=data[0].size
//                imgViewProfile.image = Utilities.getImageFromURL(name: data[0].image ?? "")
//
//
////                let flist = data[0]
//            }
//            else {
//                print(result.ResponseMessage)
//            }
//        }

    }
    var facilitynamelist=[Facility]()
    
    func facilitiesfromdatabase(){
        let api = APIWrapper();
        let response =  api.getMethodCall(controllerName: "apiplayground", actionName: "flist")
        if response.ResponseCode == 200 {
            
            do {
                facilitynamelist = try JSONDecoder().decode([Facility].self, from: response.ResponseData!)
                print(facilitynamelist)
                
            }catch {
                print("error: \(error)")
            }
            
            
        }
        else{
            print(response.ResponseMessage)
        }
        
        
    }

    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        facilitynamelist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FacilitiesTableViewCell
        
        let f = facilitynamelist[indexPath.row]
        cell.lbfacility_name.text=f.name
        cell.chkfacility.tag=indexPath.row
        
        if f.isSelected ?? false {
            cell.chkfacility.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
        }
        else {
            cell.chkfacility.setImage(UIImage(systemName: "square"), for: .normal)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if facilitynamelist[indexPath.row].isSelected ?? false {
            facilitynamelist[indexPath.row].isSelected = false
        }
        else {
            facilitynamelist[indexPath.row].isSelected = true
        }
        tableview.reloadData()
    }
}


//
//  UpdateGroundDetailViewController.swift
//  FYPProject
//
//  Created by apple on 06/04/2023.
//

import UIKit
import DropDown

class UpdateGroundDetailViewController: UIViewController ,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    var id=0
    public var caller = ManageGroundViewController()
    let gm = GroundManager()


    @IBOutlet weak var txtgroundname: UITextField!
    @IBOutlet weak var txtaddress: UITextField!
    @IBOutlet weak var txtarea: UITextField!
    @IBOutlet weak var txtcity: UITextField!
    @IBOutlet weak var txtcontact: UITextField!
    @IBOutlet weak var txtdescription: UITextField!
    @IBOutlet weak var addbtn: UIButton!
    @IBOutlet weak var txtcapacity: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
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
         //   let image = imgViewProfile.image,
            let address = txtaddress.text,
            let description = txtdescription.text,
            let size = dropDownLabel.text
      //      let ownerid = LoginViewController.loggedInUser.id

        else {
                return
             }
        
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
        params["gid"] = String(id)
        
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
        
        var images = [Media]()
        images.append(Media(withImage: self.imgViewProfile.image!, forKey: "image", imageName: "image.jpeg")!)
        
        let api = APIWrapper()
        let response = api.uploadImageToServer(images: images, parameters: params, endPoint: "apiplayground/Edit")
        if response.ResponseCode == 200{
            
            print("Ground Updated successfully")
            let myAlert = UIAlertController(title: "Alert", message: "Ground Updated Successfully", preferredStyle: UIAlertController.Style.alert);
            
            myAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self.present( myAlert, animated: true, completion: nil);
           
        
          
            self.caller.reloadData()
        }
    
        else{
            print("\(response.ResponseMessage)")
        }
        
    }
    
    var facilitynamelist=[Facility]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        facilitiesfromdatabase()
     
        navigationController?.navigationBar.tintColor = .white
        var newid=id
        var editedGround: Manageground? = nil
        var api=APIWrapper()
        let result = api.getMethodCall(controllerName: "apiplayground", actionName: "Edit/\(id)")
        if result.ResponseCode == 200 {
            var data = try! JSONDecoder().decode(Managegroun.self, from: result.ResponseData!)
            txtarea.text=data.area
            txtaddress.text=data.address
            txtcontact.text=data.contact
            txtcity.text=data.city
            txtdescription.text=data.description
            txtcapacity.text=String(data.capacity!)
            txtgroundname.text=data.gname
            dropDown2Label.text=data.gtype
            dropDownLabel.text=data.size
            imgViewProfile.image = Utilities.getImageFromURL(name: data.image ?? "")
            let facility = data.facility ?? []
            for i in facility.indices {
                for j in facilitynamelist.indices {
                    if facilitynamelist[j].id == facility[i] {
                        facilitynamelist[j].isSelected = true
                    }
                }
            }
            tableView.reloadData()
            
        } else {
            print(result.ResponseMessage)
        }
        
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

        addbtn.layer.cornerRadius=15
        txtgroundname.layer.cornerRadius=15
        txtcontact.layer.cornerRadius=15
        txtaddress.layer.cornerRadius=15
        txtarea.layer.cornerRadius=15
        txtcapacity.layer.cornerRadius=15
        txtcity.layer.cornerRadius=15
        txtdescription.layer.cornerRadius=15

    }


    func facilitiesfromdatabase() {
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
   
}
extension UpdateGroundDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return facilitynamelist.count
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
        tableView.reloadData()
    }
}

////
////  UserProfileViewController.swift
////  CalculateBMI
////
////  Created by apple on 24/11/2022.
////  Copyright © 2022 biit. All rights reserved.
////
//
//import UIKit
//extension UserProfileViewController :UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDataSource{
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return profileData.count
//    }
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
//        cell?.textLabel?.text = profileData[indexPath.row].name
//        cell?.detailTextLabel?.text = profileData[indexPath.row].address
//        
//        cell?.imageView?.image = UIImage(data: profileData[indexPath.row].pic)
//        return cell!
//
//    }
//    
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        picker.dismiss(animated: true, completion: nil)
//    }
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        if let img = info[.originalImage] {
//            imageViewPic.image = img as! UIImage
//        }
//        picker.dismiss(animated: true, completion: nil)
//    }
//
//}
//
//class UserProfileViewController: UIViewController {
//    @IBOutlet weak var txtID: UITextField!
//
//    
//    @IBOutlet weak var txtname: UITextField!
//    
//    @IBOutlet weak var txtcontact: UITextField!
//    
//    @IBOutlet weak var txtaddress: UITextField!
//    @IBOutlet weak var imageViewPic: UIImageView!
// 
//    
//    
//    
//    @IBAction func UploadImage(_ sender: Any) {
//        
//        let mobj=Media(withImage: imageViewPic.image!, forKey: "file", imageName: "image.png")
//             var imgarr=[Media]()
//             imgarr.append(mobj!)
//             var params=[String:String]()
//             params ["id"]=txtID.text!
//             params ["name"]=txtname.text!
//             params ["contact"]=txtcontact.text!
//             params["address"]=txtaddress.text!
//         
//             let api=APIWrapper()
//             api.uploadImageToServer(images: imgarr, parameters: params, endPoint: "Customer/UploadImage")
//        
//        
//        
//        
//    }
//    
//    
//    
//    
//   var profileData = [Profile]()
//        let mgr = DBManager()
//        override func viewDidLoad() {
//            super.viewDidLoad()
//            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(pickImage))
//            imageViewPic.isUserInteractionEnabled = true
//            imageViewPic.addGestureRecognizer(tapGesture)
//            mgr.createInsertUpdateDelete(query: "CREATE Table if not exists userProfile  (id integer, name text, contact text, address text, img blob)")
//            
//           
//           // profileData = mgr.getAllImages()
//            
//            //imageViewPic.image = UIImage(data: imgData!)
//            
//
//        }
//        @objc func pickImage(){
//            let imgPicker = UIImagePickerController()
//            imgPicker.delegate = self
//            self.present(imgPicker, animated: true, completion: nil)
//        }
//
//        
//        @IBAction func btnSaveClick(_ sender: Any) {
//            
//            let query = "Insert into userprofile values ('\(txtID.text!)', '\(txtname.text!)', '\(txtcontact.text!)', '\(txtaddress.text!)', ?)"
//            let imgData = imageViewPic.image?.pngData() as! NSData
//            var msg = "Unable to save data"
//            if mgr.insertUpdateDeleteWithImage(query: query, img: imgData) {
//                msg = "Data saved"
//            }
//            let alert = UIAlertController(title: "Alert!!", message: msg, preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
//            present(alert, animated: true, completion: nil)
//        }
//       
//     
//
//    }

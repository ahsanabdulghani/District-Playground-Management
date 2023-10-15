//
//  ImageViewController.swift
//  CalculateBMI
//
//  Created by apple on 18/11/2022.
//  Copyright © 2022 biit. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
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
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

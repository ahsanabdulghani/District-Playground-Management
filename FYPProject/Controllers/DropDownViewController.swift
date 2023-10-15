//
//  DropDownViewController.swift
//  MyPracticeForm
//
//  Created by apple on 27/12/2022.
//  Copyright © 2022 biit. All rights reserved.
//

import UIKit
import DropDown
class DropDownViewController: UIViewController {

    @IBAction func dropDownClicked(_ sender: Any) {
        dropDown.show()
    }
    @IBOutlet weak var dropDownLabel: UILabel!
    @IBOutlet weak var dropDownView: UIView!
    //create variable of dropDown
    let dropDown = DropDown()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //assign viewOutlet to
        dropDown.anchorView = dropDownView
        //set data source
        dropDown.dataSource = ["Rawalpindi", "Islamabad",
        "Lahore"]

            // Top of drop down will be below the anchorView
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)

            // Action triggered on selection
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
        self.dropDownLabel.text = item }

            dropDownView.layer.borderWidth = 2
            dropDownView.layer.borderColor = UIColor.black.cgColor
            dropDownView.layer.cornerRadius = 5
            dropDown.backgroundColor = UIColor.gray
            dropDown.animationduration = 0.3

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


//
//  BMIViewController.swift
//  CalculateBMI
//
//  Created by apple on 21/10/2022.
//  Copyright © 2022 biit. All rights reserved.
//

import UIKit

class BMIViewController: UIViewController {
    @IBOutlet weak var txtweightkg: UITextField!
    @IBOutlet weak var txtheightmeter: UITextField!
    @IBAction func btncalculatebmi(_ sender: Any) {
        let txt1=Float(txtweightkg.text!)
        let txt2=Float(txtheightmeter.text!)
        let div=Float(txt1!/(txt2!*txt2!))
       
        if div<16
        {
        txtresult.text="Result:Severe Thinness"
        }
        else if div>=16&&div<17
        {
            txtresult.text="Result:Moderate Thinness"
        }
        else if div>=17&&div<18.5
        {
            txtresult.text="Result:Mild Thinness"
        }
        else if div>=18.5&&div<25
        {
            txtresult.text="Result:Normal"
        }
        else if div>=25&&div<30
        {
            txtresult.text="Result:Over weight"
        }
        else if div>=30&&div<35
        {
            txtresult.text="Result:Obese Class I"
        }
        else if div>=35&&div<40
        {
            txtresult.text="Result:Obese Class II"
        }
        else
        {
            txtresult.text="Result:Obese Class III"
        }
    }
    @IBOutlet weak var txtresult: UITextField!
    
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

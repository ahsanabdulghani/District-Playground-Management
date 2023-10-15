//
//  SearchStadiumViewController.swift
//  FYPProject
//
//  Created by apple on 28/05/2023.
//

import UIKit

class SearchStadiumViewController: UIViewController {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var lblMembershipDuration: UILabel!
    @IBOutlet weak var lblMembershipFees: UILabel!
    
    var groundData = Ground()
    var groundDetail = Ground()
    var memberData : Membership? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        print(groundData)
        
        let manager = GroundManager()
        groundDetail = manager.groundDetails(gid: groundData.gid ?? 0)
        print(groundDetail)
        collectionView.reloadData()
        
        let membership = MembershipManager()
        memberData = membership.getMembershipDetails(gid: groundData.gid ?? 0)
        print(memberData)
        
        lblMembershipDuration.text = "Membership Duration : " + (memberData?.m_duration ?? "") + " month"
        lblMembershipFees.text = "Membership Fees : " +  String(memberData?.mfee ?? 0)
        
        imgView.image = Utilities.getImageFromURL(name: groundDetail.image ?? "")
        lblTitle.text = groundDetail.gname
        lblDescription.text = groundDetail.description
    }

    @IBAction func onClickBackBtn(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClickGetMembershipBtn(_ sender: Any) {
        let id = APIWrapper.userData.id
        if id == 0 {
            let controller = self.storyboard?.instantiateViewController(identifier: "displayloginpage") as! LoginViewController
            controller.callBack = { [self] isSuccess in
                if isSuccess {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                        self.getMembership()
                    })
                }
            }
            controller.isForLogin = true
            self.navigationController?.pushViewController(controller, animated: true)
        }
        else {
            getMembership()
        }
    }
    
    @IBAction func onClickFeedbackBtn(_ sender: Any) {
        let id = APIWrapper.userData.id
        if id == 0 {
            let controller = self.storyboard?.instantiateViewController(identifier: "displayloginpage") as! LoginViewController
            controller.callBack = { [self] isSuccess in
                if isSuccess {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                        let controller = self.storyboard?.instantiateViewController(identifier: "RateAndReviewViewController") as! RateAndReviewViewController
                        controller.gid = groundData.gid ?? 0
                        self.navigationController?.pushViewController(controller, animated: true)
                    })
                }
            }
            controller.isForLogin = true
            self.navigationController?.pushViewController(controller, animated: true)
        }
        else {
            let controller = self.storyboard?.instantiateViewController(identifier: "RateAndReviewViewController") as! RateAndReviewViewController
            controller.gid = groundData.gid ?? 0
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func getMembership() {
        let manager = MembershipManager()
        let id = APIWrapper.userData.id
        let res = manager.addMembershipRequest(gid: memberData?.gid ?? 0, cid: id, duration: memberData?.m_duration ?? "", amount: memberData?.mfee ?? 0)
        print(res)
        if res == "Added" {
            let alert = UIAlertController(title: "Alert", message: "You got membership successfully!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            let alert = UIAlertController(title: "Alert", message: res, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            self.present(alert, animated: true, completion: nil)
        }

       }
}
extension SearchStadiumViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return groundDetail.flist!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FacilityCollectionViewCell", for: indexPath) as! FacilityCollectionViewCell
        
        cell.lblName.text = groundDetail.flist![indexPath.row].name
        cell.imgView.image = UIImage(named: groundDetail.flist![indexPath.row].name ?? "")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 160, height: 30)
    }
}

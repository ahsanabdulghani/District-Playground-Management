//
//  ManageGroundCell.swift
//  FYPProject
//
//  Created by apple on 01/04/2023.
//

import UIKit

class ManageGroundCell: UITableViewCell {

    @IBOutlet weak var CoverPicture: UIImageView!
    @IBOutlet weak var labelGname: UILabel!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnsetschedule: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var facilityList = [Facility]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        btnEdit.layer.cornerRadius=10
        btnDelete.layer.cornerRadius=10
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
extension ManageGroundCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return facilityList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FacilityImageCollectionViewCell", for: indexPath) as! FacilityImageCollectionViewCell
        
        cell.imgView.image = UIImage(named: facilityList[indexPath.row].name ?? "")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 25, height: 25)
    }
}

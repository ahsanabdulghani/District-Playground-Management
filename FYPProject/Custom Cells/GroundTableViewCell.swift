//
//  GroundTableViewCell.swift
//  FYPProject
//
//  Created by apple on 29/05/2023.
//

import UIKit
import RateBar

class GroundTableViewCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnBook: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var vRating: RatingBar!
    @IBOutlet weak var lblReviews: UILabel!
    
    var groundDetail = Ground()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
extension GroundTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return groundDetail.flist!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FacilityImageCollectionViewCell", for: indexPath) as! FacilityImageCollectionViewCell
    
        cell.imgView.image = UIImage(named: groundDetail.flist![indexPath.row].name ?? "")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 25, height: 25)
    }
}

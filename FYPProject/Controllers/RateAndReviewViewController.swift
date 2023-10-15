//
//  RateAndReviewViewController.swift
//  FYPProject
//
//  Created by apple on 04/06/2023.
//

import UIKit
import RateBar

class RateAndReviewViewController: UIViewController {

    @IBOutlet weak var vRating: RatingBar!
    @IBOutlet weak var txtComment: UITextView!
    
    var gid = Int()
    var rating = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        vRating
        vRating.delegate = self
    }

    @IBAction func onClickBackBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClickSubmitBtn(_ sender: Any) {
        // Check if a valid rating has been selected (not equal to the default value)
            guard rating != -1 else {
                // Display an error message to the user
                let alert = UIAlertController(title: "Alert", message: "Please select a rating.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
        
        let id = APIWrapper.userData.id
        let manager = GroundManager()
        // this below code use for space in comment accept
            guard let encodedComment = txtComment.text?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
                // Error encoding the comment text
                print("Error encoding the comment text")
                return
            }
        let message = manager.addRating(gid: gid, cid: id, comment: encodedComment, rating: rating)
        print(message)
 
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
extension RateAndReviewViewController: RatingBarDelegate {
    
    func RatingBar(_ ratingBar: RatingBar, didChangeValue value: Int) {
        rating = value
        print(rating)
    }
}

//
//  SplashViewController.swift
//  FYPProject
//
//  Created by apple on 28/08/2023.
//

import UIKit

class SplashViewController: UIViewController {

    var imageView: UIImageView = {
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 400, height: 300))
            imageView.image = UIImage(named: "Logo")
            return imageView
        }()

        override func viewDidLoad() {
            super.viewDidLoad()
            view.addSubview(imageView)
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.performSegue(withIdentifier: "segue", sender: self)
            }
        }

        override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
            imageView.center = view.center
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            self.animation()
            }
        }

        func animation() {
            UIView.animate(withDuration: 1) {
                let size = self.view.frame.size.width * 2
                let xPosition = size - self.view.frame.width
                let yPosition = self.view.frame.height - size
                self.imageView.frame = CGRect(x: -(xPosition / 2), y: yPosition / 2, width: size, height: size)
                self.imageView.alpha = 0
            }
        }
}

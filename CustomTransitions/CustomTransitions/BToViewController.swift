//
//  BToViewController.swift
//  CustomTransitions
//
//  Created by MinG._. on 21/01/2020.
//  Copyright © 2020 MinG._. All rights reserved.
//

import UIKit

class BToViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var contentViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var confirmButton: UIButton!
    
    var data: (UIImage, IndexPath)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = data?.0
        
        //calculatingContentViewHeight
        for v in contentView.subviews {
            contentViewHeightConstraint.constant += v.frame.height
        }
        
        // Do any additional setup after loading the view.
    }

    @IBAction func buttonClicked(_ sender: Any) {
        dismiss(animated: true)
    }
    
    func animation() {
        
        let vibration: CGFloat = 22
        let iphoneRadius: CGFloat = 40
        let spacing: CGFloat = 20
        let originYDifference = confirmButton.frame.height + iphoneRadius + spacing
        
        confirmButton.layer.cornerRadius = 10
        
        view.bringSubviewToFront(confirmButton)
        UIView.animateKeyframes(
            withDuration: 0.5,
            delay: 0,
            options: .overrideInheritedOptions,
            animations: {
                
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 3/4) {
                    self.confirmButton.transform = CGAffineTransform(translationX: 0, y:
                        -(originYDifference + vibration))
                }
                
                UIView.addKeyframe(withRelativeStartTime: 3/4, relativeDuration: 1/4) {
                    self.confirmButton.transform = CGAffineTransform(translationX: 0, y:
                        -originYDifference)
                }
        })
        
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

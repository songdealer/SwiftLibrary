//
//  AToViewController.swift
//  CustomTransitions
//
//  Created by MinG._. on 21/01/2020.
//  Copyright © 2020 MinG._. All rights reserved.
//

import UIKit

class AToViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var contentViewHeightConstraint: NSLayoutConstraint!
    var data: (UIImage, IndexPath)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = data?.0
        
        for v in contentView.subviews {
            contentViewHeightConstraint.constant += v.frame.height
        }
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func buttonClicked(_ sender: Any) {
        dismiss(animated: true)
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

//
//  ViewController.swift
//  SlideHeader
//
//  Created by MinG._. on 21/01/2020.
//  Copyright © 2020 MinG._. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var slideHeaderHeightConstraint: NSLayoutConstraint!
    
    var oldOffset: CGFloat = 0
    
    let contentViewMaxHeight: CGFloat = 1600
    let slideHeaderMaxHeight: CGFloat = 80
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //scrollView.delegate = self
        contentViewHeightConstraint.constant = contentViewMaxHeight
        slideHeaderHeightConstraint.constant = slideHeaderMaxHeight
        
        // Do any additional setup after loading the view.
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let differ = scrollView.contentOffset.y - oldOffset
        oldOffset = scrollView.contentOffset.y
        let div: CGFloat = 5
        let speed = differ / div
        
        if(scrollView.contentOffset.y > 0 && scrollView.contentOffset.y < scrollView.contentSize.height - scrollView.frame.height) {
            if slideHeaderHeightConstraint.constant - speed < 0 { slideHeaderHeightConstraint.constant = 0; print("up \(speed)") }
            else if slideHeaderHeightConstraint.constant - speed > slideHeaderMaxHeight { slideHeaderHeightConstraint.constant = slideHeaderMaxHeight; print("down \(speed)") }
            else { slideHeaderHeightConstraint.constant -= speed; print("test \(speed)")}
        }
    }
}

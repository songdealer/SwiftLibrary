//
//  ViewController.swift
//  ViewMoveAnimation
//
//  Created by MinG._. on 2020/05/27.
//  Copyright © 2020 MinG._. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var viewMoved: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    
    func move(view: UIView, to location: CGRect) { // , duration
        let duration = 0.3
        UIView.animate(withDuration: duration) {
            view.frame = location
            view.superview?.layoutIfNeeded()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let position = touch.location(in: view)
            var frame = viewMoved.frame
            
            frame.origin.x = position.x
            frame.origin.y = position.y
            
            self.move(view: viewMoved, to: frame)
        }
    }
}


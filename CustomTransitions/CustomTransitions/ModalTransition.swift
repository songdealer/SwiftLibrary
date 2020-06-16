//
//  ModalTransition.swift
//  CustomTransitions
//
//  Created by MinG._. on 21/01/2020.
//  Copyright © 2020 MinG._. All rights reserved.
//

import UIKit

class ModalTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let indexPath: IndexPath
    
    required init(_ indexPath: IndexPath) {
        self.indexPath = indexPath
        super.init()
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        let duration = 0.3
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from) as? BFromCollectionViewController, let toVC = transitionContext.viewController(forKey: .to) as? BToViewController, let fromSnapshot = fromVC.view.snapshotView(afterScreenUpdates: true), let toSnapshot = toVC.view.snapshotView(afterScreenUpdates: true) else { return }
        
        let duration = transitionDuration(using: transitionContext)
        let containerView = transitionContext.containerView
        let iphoneRadius: CGFloat = 40
        
        toSnapshot.layer.cornerRadius = iphoneRadius
        toVC.view.layer.cornerRadius = iphoneRadius
        
        toSnapshot.clipsToBounds = true
        toVC.view.clipsToBounds = true
        
        let begin = CGAffineTransform(translationX: 0, y: containerView.frame.height)
        let center = CGAffineTransform(translationX: 0, y: 0)
        let end = CGAffineTransform(translationX: 0, y: iphoneRadius)
        
        toSnapshot.transform = begin
        let hidden = UIView(frame: fromSnapshot.frame)
        hidden.backgroundColor = .black
        hidden.alpha = 0.4
        
        fromSnapshot.addSubview(hidden)
        
        containerView.addSubview(toVC.view)
        containerView.addSubview(fromSnapshot)
        containerView.addSubview(toSnapshot)
        
        UIView.animateKeyframes(
            withDuration: duration,
            delay: 0,
            options: .overrideInheritedOptions,
            animations: {
                
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 3/4) {
                    toSnapshot.transform = center
                }
                UIView.addKeyframe(withRelativeStartTime: 3/4, relativeDuration: 1/4) {
                    toSnapshot.transform = end
                }
                
                toVC.view.transform = end
                
        },
            completion: { bool in
                toSnapshot.removeFromSuperview()
                containerView.sendSubviewToBack(fromSnapshot)
                toVC.animation()
                transitionContext.completeTransition(bool)
        })
    }
    
    
}

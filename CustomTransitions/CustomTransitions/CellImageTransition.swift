//
//  CellImageTransition.swift
//  CustomTransitions
//
//  Created by MinG._. on 21/01/2020.
//  Copyright © 2020 MinG._. All rights reserved.
//

import UIKit

class CellImageTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
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
        guard let fromVC = transitionContext.viewController(forKey: .from) as? AFromCollectionViewController, let toVC = transitionContext.viewController(forKey: .to) as? AToViewController, let fromSnapshot = fromVC.view.snapshotView(afterScreenUpdates: true) else { return }
        
        let containerView = transitionContext.containerView
        let duration = transitionDuration(using: transitionContext)
        let cell = fromVC.collectionView.cellForItem(at: indexPath) as! AFromCollectionViewCell
        
        let tempFrame = cell.convert(cell.imageView.frame, to: fromVC.collectionView)
        let newFrame = fromVC.collectionView.convert(tempFrame, to: fromVC.view)
        
        let finalFrame = toVC.imageView.superview!.convert(toVC.imageView.frame, to: toVC.view)
        // AView.convert(BView.frame, CView) -> C > A > B, C안의 A뷰의 B frame을 C에서의 절대적 Frame
        
        let hiddenView = UIView(frame: newFrame)
        let imageView = UIImageView(frame: newFrame)
        imageView.backgroundColor = .white
        imageView.image = cell.imageView.image
        
        containerView.addSubview(toVC.view)
        containerView.addSubview(fromSnapshot)
        containerView.addSubview(hiddenView)
        containerView.addSubview(imageView)
        
        UIView.animateKeyframes(
            withDuration: duration,
            delay: 0,
            options: .overrideInheritedOptions,
            animations: {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1) {
                    imageView.frame = finalFrame
                }
                
        }) { (completed) in
            //delay가 있다면 delay 후에 밑의 코드 작성.
            fromSnapshot.removeFromSuperview()
            hiddenView.removeFromSuperview()
            imageView.removeFromSuperview()
            transitionContext.completeTransition(completed)
        }
        
        // containerView = [fromVC.view], ViewController = fromVC -> toVC
        
    }
}

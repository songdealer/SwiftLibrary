//
//  ViewController.swift
//  ButtonAlphaAnimation
//
//  Created by MinG._. on 2020/06/23.
//  Copyright © 2020 MinG._. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var contentWidthConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        addButton.rx.tap
            .subscribe(onNext: { _ in self.addImageView() })
        .disposed(by: disposeBag)
        // Do any additional setup after loading the view.
    }
    
    func addImageView() {
        let imageView = UIImageView()
        let colors: [UIColor] = [.blue, .brown, .cyan, .gray, .magenta, .orange, .purple, .green]
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.backgroundColor = colors.randomElement()
        imageView.isUserInteractionEnabled = true
        
        let topAnchor = imageView.topAnchor.constraint(equalTo: contentView.topAnchor)
        let bottomAnchor = imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        let widthAnchor = imageView.widthAnchor.constraint(equalTo: contentView.heightAnchor)
        
        if let lastView = contentView.subviews.last {
            let leadingAnchor = imageView.leadingAnchor.constraint(equalTo: lastView.trailingAnchor)
            contentView.addSubview(imageView)
            contentView.addConstraints([topAnchor, bottomAnchor, widthAnchor, leadingAnchor])
        }
        else {
            let leadingAnchor = imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
            contentView.addSubview(imageView)
            contentView.addConstraints([topAnchor, bottomAnchor, widthAnchor, leadingAnchor])
        }
        
        contentWidthConstraint.constant += contentView.frame.height
        
        addDeleteButton(parentView: imageView)
    }
    
    func addDeleteButton(parentView: UIView) {
        let DeleteButton = UIButton()
        DeleteButton.backgroundColor = .red
        
        DeleteButton.translatesAutoresizingMaskIntoConstraints = false
        
        let space = CGFloat(10)
        
        let topAnchor = DeleteButton.topAnchor.constraint(equalTo: parentView.topAnchor)
        topAnchor.constant = space
        let trailingAnchor = DeleteButton.trailingAnchor.constraint(equalTo: parentView.trailingAnchor)
        trailingAnchor.constant = -space
        
        let widthAnchor = DeleteButton.widthAnchor.constraint(equalTo: parentView.widthAnchor, multiplier: 0.1)
        let heightAnchor = DeleteButton.heightAnchor.constraint(equalTo: parentView.heightAnchor, multiplier: 0.1)
        
        parentView.addSubview(DeleteButton)
        parentView.addConstraints([topAnchor, trailingAnchor, widthAnchor, heightAnchor])
        
        let timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { _ in
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.5) {
                    DeleteButton.alpha = 0
                }
            }
        }
        
        let interval = BehaviorSubject<Timer>(value: timer)
        
        // touches begin -> alpha = 1
        // touches end -> refresh, delay 3.0
        // deallocated -> subscribtion dispose
        
        // dragging 하면 touches end가 안됌.
        
        let subscription1 = parentView.rx.touchesBegan
        .withLatestFrom(interval)
            .subscribe(onNext: { t in
                print("touches Began")
                
                if t.isValid {
                    t.invalidate()
                }
                DeleteButton.alpha = 1.0
        })
        
        let subscription2 = scrollView.rx.willBeginDragging
        .withLatestFrom(interval)
            .subscribe(onNext: { t in
                print("dragging Bagin")
                
                if t.isValid {
                    t.invalidate()
                }
                DeleteButton.alpha = 1.0
            })
        
        let subscription3 = parentView.rx.touchesEnded
            .subscribe(onNext: { _ in
                print("touches Ended")
                let newTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { _ in
                    DispatchQueue.main.async {
                        UIView.animate(withDuration: 0.5) {
                            DeleteButton.alpha = 0
                        }
                    }
                }
                interval.onNext(newTimer)
            })
        
        let subscription4 = scrollView.rx.willEndDragging
            .subscribe(onNext: { _ in
                print("dragging End")
                let newTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { _ in
                    DispatchQueue.main.async {
                        UIView.animate(withDuration: 0.5) {
                            DeleteButton.alpha = 0
                        }
                    }
                }
                interval.onNext(newTimer)
            })
        
        let subscription5 = DeleteButton.rx.tap
            .take(1)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                print("button tapped")
                let viewArray = self.contentView.subviews
                
                if parentView == viewArray.last! {
                    let index = viewArray.count - 1
                    
                    let current = viewArray[index]
                    self.contentWidthConstraint.constant -= self.contentView.frame.height
                    current.removeFromSuperview()
                }
                
                else {
                    let index = viewArray.firstIndex(of: parentView)!
                    if index == 0 {
                        let nextView = viewArray[index+1]
                        
                        for c in self.contentView.constraints {
                            if nextView.leadingAnchor == c.firstAnchor {
                                c.isActive = false
                                nextView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
                            }
                        }
                        
                    }
                    else {
                        let previousView = viewArray[index-1]
                        let nextView = viewArray[index+1]
                        
                        for c in self.contentView.constraints {
                            if nextView.leadingAnchor == c.firstAnchor {
                                c.isActive = false
                                
                                nextView.leadingAnchor.constraint(equalTo: previousView.trailingAnchor).isActive = true
                            }
                        }
                        
                    }
                    let current = viewArray[index]
                    self.contentWidthConstraint.constant -= self.contentView.frame.height
                    current.removeFromSuperview()
                }
            })
        
        parentView.rx.deallocated
            .subscribe(onNext: { _ in
                print("disposed")
                subscription1.dispose()
                subscription2.dispose()
                subscription3.dispose()
                subscription4.dispose()
                subscription5.dispose()
            })
        .disposed(by: disposeBag)
        
        
    }
}

extension Reactive where Base: UIView {
    
    var touchesBegan: ControlEvent<Void> {
        let source = self.methodInvoked(#selector(Base.touchesBegan(_:with:)))
            .map{ _ in () }
        return ControlEvent(events: source)
    }
    
    var touchesEnded: ControlEvent<Void> {
        let source = self.methodInvoked(#selector(Base.touchesEnded(_:with:)))
            .map{ _ in () }
        return ControlEvent(events: source)
    }
    
}

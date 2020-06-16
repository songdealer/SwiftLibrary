//
//  ViewController.swift
//  KeyboardHeightLogic
//
//  Created by MinG._. on 2020/06/16.
//  Copyright © 2020 MinG._. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol KeyboardType {
    var keyboardState$: BehaviorSubject<Bool> { get }
}

class ViewController: UIViewController, KeyboardType {

    let disposeBag = DisposeBag()
    let keyboardState$: BehaviorSubject<Bool> = BehaviorSubject<Bool>(value: false)
    let currentTextField: PublishSubject<UITextField> = PublishSubject<UITextField>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
            .withLatestFrom(keyboardState$) { ($0, $1) }
            .filter{!($0.1)}
            .map{$0.0}
            .bind(to: rx.keyboardWillShow)
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
            .withLatestFrom(keyboardState$) { ($0, $1) }
            .filter{$0.1}
            .map{$0.0}
            .bind(to: rx.keyboardWillHide)
            .disposed(by: disposeBag)
        
        // Do any additional setup after loading the view.
    }


}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension Reactive where Base: UIViewController, Base: KeyboardType {
    var keyboardWillShow: Binder<Notification> {
        return Binder(self.base) { target, notification in
            if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardRectangle = keyboardFrame.cgRectValue
                let keyboardHeight = keyboardRectangle.height
                
                target.view.center.y -= keyboardHeight
                target.keyboardState$.onNext(true)
            }
        }
    }
    
    var keyboardWillHide: Binder<Notification> {
        return Binder(self.base) { target, notification in
            if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardRectangle = keyboardFrame.cgRectValue
                let keyboardHeight = keyboardRectangle.height
                
                target.view.center.y += keyboardHeight
                target.keyboardState$.onNext(false)
            }
        }
    }
}

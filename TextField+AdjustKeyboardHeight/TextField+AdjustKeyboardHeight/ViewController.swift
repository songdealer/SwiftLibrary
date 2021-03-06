//
//  ViewController.swift
//  TextField+AdjustKeyboardHeight
//
//  Created by MinG._. on 2020/06/17.
//  Copyright © 2020 MinG._. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Simulator - textfield 누를 때마다, return 처음 누를 때 WillShow
        // iPhone - keyboard가 나올 때마다 WillShow
        
        let keyboardWillShow = NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
        
        let textFieldBeginObservable = rx.shouldBeginEditing
        
        
        // iPhone
        keyboardWillShow
            .withLatestFrom(textFieldBeginObservable) { ($1, $0) }
            .bind(to: rx.keyboardWillShow)
            .disposed(by: disposeBag)
        
        // Simulator
        /*Observable.zip(textFieldBeginObservable, keyboardWillShow)
            .bind(to: rx.keyboardWillShow)
            .disposed(by: disposeBag)*/
        
        
        let keyboardWillHide = NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
        
        keyboardWillHide
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
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
    }
}

extension Reactive where Base: ViewController {

    var keyboardWillShow: Binder<(UITextField, Notification)> {
        return Binder(self.base) { target, data in
            
            let tf = data.0
            let notification = data.1
            
            if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardRectangle = keyboardFrame.cgRectValue
                let keyboardHeight = keyboardRectangle.height
                
                if !(target.view.center.y < target.view.frame.height / 2), let coordinate = tf.superview?.convert(tf.frame.origin, to: target.view) {
                    if coordinate.y + tf.frame.height > target.view.frame.height - keyboardHeight {
                        target.view.center.y -= keyboardHeight
                    }
                }
            }
        }
    }
    
    var keyboardWillHide: Binder<Notification> {
        return Binder(self.base) { target, notification in
            if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardRectangle = keyboardFrame.cgRectValue
                let keyboardHeight = keyboardRectangle.height
                
                if target.view.center.y < target.view.frame.height / 2 {
                    target.view.center.y += keyboardHeight
                }
            }
        }
    }
    
    var shouldBeginEditing: ControlEvent<UITextField> {
        let source = self.methodInvoked(#selector(Base.textFieldShouldBeginEditing))
            .map{ $0.first as! UITextField }
        return ControlEvent(events: source)
    }
    
    var shouldReturn: ControlEvent<UITextField> {
        let source = self.methodInvoked(#selector(Base.textFieldShouldReturn))
            .map{ $0.first as! UITextField }
        return ControlEvent(events: source)
    }

}

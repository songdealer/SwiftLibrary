//
//  RxTextFieldDelegateProxy.swift
//  TextFieldDelegateProxy
//
//  Created by MinG._. on 2020/06/16.
//  Copyright © 2020 MinG._. All rights reserved.
//

import RxSwift
import RxCocoa

open class RxTextFieldDelegateProxy
    : DelegateProxy<UITextField, UITextFieldDelegate>
    , DelegateProxyType
    , UITextFieldDelegate {

    public static func currentDelegate(for object: UITextField) -> UITextFieldDelegate? {
        return object.delegate
    }

    public static func setCurrentDelegate(_ delegate: UITextFieldDelegate?, to object: UITextField) {
        object.delegate = delegate
    }

    /// Typed parent object.
    public weak private(set) var textField: UITextField?

    /// - parameter textfield: Parent object for delegate proxy.
    public init(textField: ParentObject) {
        self.textField = textField
        super.init(parentObject: textField, delegateProxy: RxTextFieldDelegateProxy.self)
    }

    // Register known implementations
    public static func registerKnownImplementations() {
        register(make: RxTextFieldDelegateProxy.init)
    }

    // MARK: delegate methods
    /// For more information take a look at `DelegateProxyType`.
    @objc open func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return forwardToDelegate()?.textFieldShouldReturn?(textField) ?? true
    }

    @objc open func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return forwardToDelegate()?.textFieldShouldClear?(textField) ?? true
    }
    
    @objc open func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return forwardToDelegate()?.textFieldShouldBeginEditing?(textField) ?? true
    }
}

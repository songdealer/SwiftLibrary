//
//  ViewController.swift
//  TextFieldDelegateProxy
//
//  Created by MinG._. on 2020/06/16.
//  Copyright © 2020 MinG._. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.rx.shouldBeginEditing
            .subscribe(onNext: { _ in
                print("begin")
            })
        .disposed(by: disposeBag)
        // Do any additional setup after loading the view.
    }

}

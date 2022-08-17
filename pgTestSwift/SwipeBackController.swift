//
//  SwipeBackController.swift
//  pgTestSwift
//
//  Created by Taesup Yoon on 2022/06/03.
//

import UIKit


class SwipeBackController: UIViewController {
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        //swipe back gesture 활성화 관련코드
//        navigationController?.interactivePopGestureRecognizer?.delegate = nil
//    }
    
    //swipe back gesture 활성화 관련코드
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//        navigationController?.interactivePopGestureRecognizer?.delegate = nil
//        navigationController?.interactivePopGestureRecognizer?.isEnabled = navigationController?.viewControllers.count ?? 0 > 1
//    }
//
//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//        navigationController?.interactivePopGestureRecognizer?.isEnabled = navigationController?.viewControllers.count ?? 0 > 1
//    }
}

extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
 

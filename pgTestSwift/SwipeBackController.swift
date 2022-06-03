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
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        navigationController?.interactivePopGestureRecognizer?.isEnabled = navigationController?.viewControllers.count ?? 0 > 1
    }
}

//swipe back gesture 활성화 관련코드
extension SwipeBackController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        navigationController.interactivePopGestureRecognizer?.isEnabled = navigationController.viewControllers.count > 1
    }
}

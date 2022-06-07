//
//  ViewController.swift
//  pgTestSwift
//
//  Created by Taesup Yoon on 2022/06/02.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        self.navigationController?.isNavigationBarHidden = true
        setUI()
    }

    
    func setUI() {
        for i in 0...8 {
            self.view.backgroundColor = .white
            let btn = UIButton()
            btn.tag = i + 1
            btn.addTarget(self, action: #selector(clickButton), for: .touchUpInside)
            
            if(i == 0) {
                btn.setTitle("1. PG일반 테스트", for: .normal)
            } else if(i == 1) {
                btn.setTitle("2. 통합결제 테스트", for: .normal)
            } else if(i == 2) {
                btn.setTitle("3. 카드자동 결제 테스트 (인증)", for: .normal)
            } else if(i == 3) {
                btn.setTitle("4. 카드자동 결제 테스트 (비인증)", for: .normal)
            } else if(i == 4) {
                btn.setTitle("5. 본인인증 테스트", for: .normal)
            } else if(i == 5) {
                btn.setTitle("6. 생체인증 결제 테스트", for: .normal)
            } else if(i == 6) {
                btn.setTitle("7. 비밀번호 결제 테스트 - Bootpay", for: .normal)
            } else if(i == 7) {
                btn.setTitle("8. 비밀번호 결제 테스트 - BootpayUI", for: .normal)
            } else if(i == 8) {
                btn.setTitle("9. 웹앱으로 연동하기", for: .normal)
            }
            
            
            btn.frame = CGRect(
                x: self.view.frame.width/2 - 150,
                y: 150.0 + 60 * CGFloat(i) ,
                width: 300,
                height: 40
            )
            btn.setTitleColor(.darkGray, for: .normal)
            self.view.addSubview(btn)
        }
    }
    
    @objc func clickButton(_ sender: UIButton) {
        switch(sender.tag) {
        case 1: //pg일반 테스트
            let vc = DefaultPaymentController()
            self.navigationController?.pushViewController(vc, animated: true)
            break;
        case 2: //통합결제 테스트
            let vc = TotalPaymentController()
            self.navigationController?.pushViewController(vc, animated: true)
            break;
        case 3: //정기결제 테스트
            let vc = SubscriptionController()
            self.navigationController?.pushViewController(vc, animated: true)
            break;
        case 4: //정기결제 테스트
            let vc = SubscriptionBootpayController()
            self.navigationController?.pushViewController(vc, animated: true)
            break;
        case 5: //본인인증 테스트
            let vc = AuthenticationController()
            self.navigationController?.pushViewController(vc, animated: true)
            break;
        case 6: //생체인증 테스트
//            BioController
            let vc = BioController()
            self.navigationController?.pushViewController(vc, animated: true)
            break;
        case 7: //비밀번호 결제 테스트 - Bootpay
//            PasswordController
            let vc = PasswordController()
            self.navigationController?.pushViewController(vc, animated: true)
            break;
        case 8: //비밀번호 결제 테스트 - BootpayUI
            let vc = PasswordUIController()
            self.navigationController?.pushViewController(vc, animated: true)
            break;
        case 9: //웹앱
            let vc = WebAppController()
            self.navigationController?.pushViewController(vc, animated: true)
            break;
        default:
            print(sender.tag)
            break;
        }
        
    }
}


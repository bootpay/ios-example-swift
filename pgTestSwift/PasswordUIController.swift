//
//  PasswordUIController.swift
//  pgTestSwift
//
//  Created by Taesup Yoon on 2022/06/02.
//

import UIKit
import Bootpay
import BootpayUI

class PasswordUIController: SwipeBackController {
    let _unique_user_id = "123456abcdffffe2345678901234561324516789122"
    var _applicationId = "5b8f6a4d396fa665fdc2b5e9"
    
    @available(*, deprecated, message: "이 로직은 서버사이드에서 수행되어야 합니다. rest_application_id와 prviate_key는 보안상 절대로 노출되어서 안되는 값입니다. 개발자의 부주의로 고객의 결제가 무단으로 사용될 경우, 부트페이는 책임이 없음을 밝힙니다.")
    let restApplicationId = "5b8f6a4d396fa665fdc2b5ea"
    @available(*, deprecated, message: "이 로직은 서버사이드에서 수행되어야 합니다. rest_application_id와 prviate_key는 보안상 절대로 노출되어서 안되는 값입니다. 개발자의 부주의로 고객의 결제가 무단으로 사용될 경우, 부트페이는 책임이 없음을 밝힙니다.")
    let privateKey = "rm6EYECr6aroQVG2ntW0A6LpWnkTgP4uQ3H18sDDUYw="
    
    override func viewDidLoad() {
        self.view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
        
//        bootpayStart()
        setUI()
    }
    
    
    func setUI() {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(getUserToken), for: .touchUpInside)
        
        btn.setTitle("비밀번호UI 결제 테스트", for: .normal)
        
        btn.frame = CGRect(
            x: self.view.frame.width/2 - 150,
            y: 200.0,
            width: 300,
            height: 40
        )
        btn.setTitleColor(.darkGray, for: .normal)
        self.view.addSubview(btn)
    }
    
    @objc func getUserToken() {
        BootpayRest.getRestToken(
            sendable: self,
            restApplicationId: restApplicationId,
            privateKey: privateKey
        )
    }
        
    func bootpayStart(userToken: String) {
            let payload = generatePayload()
            payload.userToken = userToken

        
//        print(userToken)
        
        BootpayBio.requestUIPasswordPayment(viewController: self, payload: payload, modalPresentationStyle: .formSheet)
                .onCancel { data in
                    print("-- cancel: \(data)")
                }
//                .onIssued { data in
//                    print("-- issued: \(data)")
//                }
                .onConfirm { data in
                    print("-- confirm: \(data)")
                    return true //재고가 있어서 결제를 최종 승인하려 할 경우
    //                Bootpay.transactionConfirm()
    //                return false //재고가 없어서 결제를 승인하지 않을때
                }
                .onDone { data in
                    print("-- done: \(data)")
                }
                .onError { data in
                    print("-- error: \(data)")
                }
                .onClose {
                    print("-- close") 
//                    self.navigationController?.popViewController(animated: true)
                }
    }
    
    
    func generatePayload() -> BootBioPayload {
        let payload = BootBioPayload()
        payload.applicationId = _applicationId //ios application id
         
        payload.price = 1000
        payload.orderId = String(NSTimeIntervalSince1970)
        payload.pg = "나이스페이"
//        payload.method = "카드자동"
        payload.orderName = "테스트 아이템"
        payload.extra = BootExtra()
        
         
        payload.extra?.cardQuota = "3"
        
        
        //통계를 위한 상품데이터
        let item1 = BootItem()
        item1.name = "나는 아이템1"
        item1.qty = 1
        item1.id = "item_01"
        item1.price = 500
        item1.cat1 = "TOP"
        item1.cat2 = "티셔츠"
        item1.cat3 = "반팔티"
        
        let item2 = BootItem()
        item2.name = "나는 아이템1"
        item2.qty = 2
        item2.id = "item_02"
        item2.price = 250
        item2.cat1 = "TOP"
        item2.cat2 = "데님"
        item2.cat3 = "청자켓"
        payload.items = [item1, item2]
        
        
//        let customParams: [String: String] = [
//            "callbackParam1": "value12",
//            "callbackParam2": "value34",
//            "callbackParam3": "value56",
//            "callbackParam4": "value78",
//        ]
//
//        payload.metadata = customParams
        

        payload.user = generateUser()
        return payload
    }
    
    func generateUser() -> BootUser {
        let user = BootUser()
        user.id = _unique_user_id
        user.area = "서울"
        user.gender = 1
        user.email = "test1234@gmail.com"
        user.phone = "01012344567"
        user.birth = "1988-06-10"
        user.username = "홍길동"
        return user
    }
}



extension PasswordUIController: BootpayRestProtocol {
   func callbackRestToken(resData: [String : Any]) {
       if let token = resData["access_token"] {
           BootpayRest.getEasyPayUserToken(
               sendable: self,
               restToken: token as! String,
               user: generateUser()
           )
       }
   }
   
   func callbackEasyCardUserToken(resData: [String : Any]) {
       if let userToken = resData["user_token"] as? String {
           self.bootpayStart(userToken: userToken)
       }
   }
}

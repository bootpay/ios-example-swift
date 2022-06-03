//
//  DefaultPaymentController.swift
//  pgTestSwift
//
//  Created by Taesup Yoon on 2022/06/02.
//
   
import UIKit
import Bootpay

class DefaultPaymentController: SwipeBackController {
    var _applicationId = "5b8f6a4d396fa665fdc2b5e9"
    
    override func viewDidLoad() {
        self.view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
        
        
        setUI()
    }
    
    func setUI() {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(bootpayStart), for: .touchUpInside)
        
        btn.setTitle("일반결제 테스트", for: .normal)
        
        btn.frame = CGRect(
            x: self.view.frame.width/2 - 150,
            y: 200.0,
            width: 300,
            height: 40
        )
        btn.setTitleColor(.darkGray, for: .normal)
        self.view.addSubview(btn)
    }
    
    @objc func bootpayStart() {
            let payload = generatePayload()
                    
            Bootpay.requestPayment(viewController: self,
                                   payload: payload
            )
                .onCancel { data in
                    print("-- cancel: \(data)")
                }
                .onIssued { data in
                    print("-- issued: \(data)")
                }
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
    
    
    func generatePayload() -> Payload {
        let payload = Payload()
        payload.applicationId = _applicationId //ios application id
         
        payload.price = 1000
        payload.orderId = String(NSTimeIntervalSince1970)
        payload.pg = "나이스페이"
        payload.method = "카드"
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
        
        
        let customParams: [String: String] = [
            "callbackParam1": "value12",
            "callbackParam2": "value34",
            "callbackParam3": "value56",
            "callbackParam4": "value78",
        ]
         
        payload.metadata = customParams
        

        let user = BootUser()
        user.username = "테스트 유저"
        user.phone = "01012345678"
        payload.user = user
        return payload
    }
}
 

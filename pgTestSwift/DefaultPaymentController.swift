//
//  DefaultPaymentController.swift
//  pgTestSwift
//
//  Created by Taesup Yoon on 2022/06/02.
//
   
import UIKit
import Bootpay

class DefaultPaymentController: SwipeBackController {
    enum PaymentAuthMode {
        case clientKey
        case legacyApplicationId
        case missingKey
    }

    var _applicationId = BootpayConfig.applicationId
    
    override func viewDidLoad() {
        self.view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
        
        
        setUI()
    }
    
    func setUI() {
        addButton(title: "일반결제 테스트 (client_key)", y: 200.0, action: #selector(bootpayStart))
        addButton(title: "레거시 결제 테스트 (application_id)", y: 252.0, action: #selector(bootpayStartLegacy))
        addButton(title: "키 없음 테스트 (NEED_CLIENT_KEY)", y: 304.0, action: #selector(bootpayStartMissingKey))
    }
    
    @objc func bootpayStart() {
        requestPayment(authMode: .clientKey)
    }

    @objc func bootpayStartLegacy() {
        requestPayment(authMode: .legacyApplicationId)
    }

    @objc func bootpayStartMissingKey() {
        requestPayment(authMode: .missingKey)
    }

    func requestPayment(authMode: PaymentAuthMode) {
            let payload = generatePayload(authMode: authMode)
                    
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
    
    func addButton(title: String, y: CGFloat, action: Selector) {
        let btn = UIButton()
        btn.addTarget(self, action: action, for: .touchUpInside)
        btn.setTitle(title, for: .normal)
        btn.frame = CGRect(
            x: self.view.frame.width/2 - 150,
            y: y,
            width: 300,
            height: 40
        )
        btn.setTitleColor(.darkGray, for: .normal)
        self.view.addSubview(btn)
    }
    
    func generatePayload(authMode: PaymentAuthMode) -> Payload {
        let payload = Payload()
        applyAuth(to: payload, mode: authMode)
         
        payload.price = 1000
        payload.orderId = String(NSTimeIntervalSince1970)
        payload.pg = "다날"
        payload.method = "카드"
        payload.orderName = "테스트 아이템"
        payload.extra = BootExtra()
        
         
        payload.extra?.cardQuota = "3"
        payload.extra?.displaySuccessResult = true
        
        
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

    func applyAuth(to payload: Payload, mode: PaymentAuthMode) {
        switch mode {
        case .clientKey:
            payload.clientKey = BootpayConfig.clientKey
        case .legacyApplicationId:
            payload.applicationId = BootpayConfig.applicationId
        case .missingKey:
            break // NEED_CLIENT_KEY 검증용
        }
    }
}
 

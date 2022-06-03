# Bootpay iOS Swift 예제  

이 문서는 [부트페이 개발연동 문서](https://docs.bootpay.co.kr/next/)를 참조하시는 분 중에서 iOS 개발자를 위한 예제 프로젝트 입니다. 

실제로 프로젝트에 Bootpay iOS를 적용함에 있어서 iOS와 관련된 내용만 모아보고, iOS 옵션을 집중적으로 다루고자 예제 프로젝트를 제공하게 되었습니다.

이 문서를 참조하여 Bootpay를 통해 쉽게 PG를 연동하세요! 



### Cocoapod을 통한 설치

```java
pod 'Bootpay' # iOS 9 이상 사용 가능 
pod 'BootpayUI' # iOS 14 이상 사용 가능, 생체인증 결제 및 SwiftUI 적용시 
```

### info.plist

```markup
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    ...

    <key>NSAppTransportSecurity</key>
    <dict>
        <key>NSAllowsArbitraryLoads</key>
        <true/>
    </dict>
    <key>CFBundleURLTypes</key>
    <array>
        <dict>
            <key>CFBundleTypeRole</key>
            <string>Editor</string> 
            <key>CFBundleURLSchemes</key>
            <array>
                <string>bootpaySample</string> // 사용하고자 하시는 앱의 bundle url scheme
            </array>
        </dict>
    </array>

    ...
    <key>NSFaceIDUsageDescription</key>
    <string>생체인증 결제 진행시 권한이 필요합니다</string>
</dict>
</plist>
```

**카드사 앱 실행 후 개발중인 원래 앱으로 돌아오지 않는 경우**

상단의 프로젝트 설정의 info.plist에서 CFBundleURLSchemes를 설정해주시면 부트페이 SDK가 해당 값을 읽어 extra.appScheme 에 값을 채워 결제데이터를 전송합니다.


## 일반PG 결제창 띄우기 

![bootpay_default_400](https://raw.githubusercontent.com/bootpay/git-open-resources/main/default_success.gif)

[일반결제 예제](https://github.com/bootpay/ios-example-swift/blob/main/pgTestSwift/DefaultPaymentController.swift) 전체코드를 참조하세요. 

PG사에서 제공하는 결제창을 띄우는 코드입니다. 지정된 pg, method의 값에 해당하는  PG사의 결제수단 모듈을 불러와 로딩합니다.

```swift

import UIKit
import Bootpay

class DefaultPaymentController: SwipeBackController {

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
```
![success](https://raw.githubusercontent.com/bootpay/git-open-resources/main/success.png)
![failed](https://raw.githubusercontent.com/bootpay/git-open-resources/main/failed.png)

기본적으로 PG사에서 결제실패 에러를 리턴할 경우, 부트페이가 해당 사유를 고객에게 보여주는 옵션은 활성화 되어있습니다. (payload.extra?.displayErrorResult = true)
만약 결제 성공했을때, 성공 페이지를 보여주고 싶다면 이 옵션을 개발자가 직접 활성화 해주셔야 합니다. (payload.extra?.displaySuccessResult = true)



 


```swift
//MARK: Bootpay Callback Protocol
extension ViewController: BootpayRequestProtocol {
    // 에러가 났을때 호출되는 부분
    func onError(data: [String: Any]) {
        print(data)
    }

    // 가상계좌 입금 계좌번호가 발급되면 호출되는 함수입니다.
    func onReady(data: [String: Any]) {
        print("ready")
        print(data)
    }

    // 결제가 진행되기 바로 직전 호출되는 함수로, 주로 재고처리 등의 로직이 수행
    func onConfirm(data: [String: Any]) {
        print(data)

        var iWantPay = true
        if iWantPay == true {  // 재고가 있을 경우.
            Bootpay.transactionConfirm(data: data) // 결제 승인
        } else { // 재고가 없어 중간에 결제창을 닫고 싶을 경우
            Bootpay.dismiss() // 결제창 종료
        }
    }

    // 결제 취소시 호출
    func onCancel(data: [String: Any]) {
        print(data)
    }

    // 결제완료시 호출
    // 아이템 지급 등 데이터 동기화 로직을 수행합니다
    func onDone(data: [String: Any]) {
        print(data)
    }

    //결제창이 닫힐때 실행되는 부분
    func onClose() {
        print("close")
        Bootpay.dismiss() // 결제창 종료
    }
}
```

### onError 함수

결제 진행 중 오류가 발생된 경우 호출되는 함수입니다. 진행중 에러가 발생되는 경우는 다음과 같습니다.

1. **부트페이 관리자에서 활성화 하지 않은 PG, 결제수단을 사용하고자 할 때**
2. **PG에서 보내온 결제 정보를 부트페이 관리자에 잘못 입력하거나 입력하지 않은 경우**
3. **결제 진행 도중 한도초과, 카드정지, 휴대폰소액결제 막힘, 계좌이체 불가 등의 사유로 결제가 안되는 경우**
4. **PG에서 리턴된 값이 다른 Client에 의해 변조된 경우**

에러가 난 경우 해당 함수를 통해 관련 에러 메세지를 사용자에게 보여줄 수 있습니다.

 data 포맷은 아래와 같습니다.

```text
{
  action: "BootpayError",
  message: "카드사 거절",
  receipt_id: "5fffab350c20b903e88a2cff"
}
```

### onCancel 함수
결제 진행 중 사용자가 PG 결제창에서 취소 혹은 닫기 버튼을 눌러 나온 경우 입니다. ****

 data 포맷은 아래와 같습니다.

```text
{
  action: "BootpayCancel",
  message: "사용자가 결제를 취소하였습니다.",
  receipt_id: "5fffab350c20b903e88a2cff"
}
```

### onReady 함수

가상계좌 발급이 완료되면 호출되는 함수입니다. 가상계좌는 다른 결제와 다르게 입금할 계좌 번호 발급 이후 입금 후에 Feedback URL을 통해 통지가 됩니다. 발급된 가상계좌 정보를 ready 함수를 통해 확인하실 수 있습니다.

  data 포맷은 아래와 같습니다.

```text
{
  account: "T0309260001169"
  accounthodler: "한국사이버결제"
  action: "BootpayBankReady"
  bankcode: "BK03"
  bankname: "기업은행"
  expiredate: "2021-01-17 00:00:00"
  item_name: "테스트 아이템"
  method: "vbank"
  method_name: "가상계좌"
  order_id: "1610591554856"
  params: null
  payment_group: "vbank"
  payment_group_name: "가상계좌"
  payment_name: "가상계좌"
  pg: "kcp"
  pg_name: "KCP"
  price: 3000
  purchased_at: null
  ready_url: "https://dev-app.bootpay.co.kr/bank/7o044QyX7p"
  receipt_id: "5fffad430c20b903e88a2d17"
  requested_at: "2021-01-14 11:32:35"
  status: 2
  tax_free: 0
  url: "https://d-cdn.bootapi.com"
  username: "홍길동"
}
```

### onConfirm 함수

결제 승인이 되기 전 호출되는 함수입니다. 승인 이전 관련 로직을 서버 혹은 클라이언트에서 수행 후 결제를 승인해도 될 경우

`BootPay.transactionConfirm(data); 또는 return true;`

코드를 실행해주시면 PG에서 결제 승인이 진행이 됩니다.

**\* 페이앱, 페이레터 PG는 이 함수가 실행되지 않고 바로 결제가 승인되는 PG 입니다. 참고해주시기 바랍니다.**

 data 포맷은 아래와 같습니다.

```text
{
  receipt_id: "5fffc0460c20b903e88a2d2c",
  action: "BootpayConfirm"
}
```
{% endtab %}

{% tab title="onDone 함수" %}
PG에서 거래 승인 이후에 호출 되는 함수입니다. 결제 완료 후 다음 결제 결과를 호출 할 수 있는 함수 입니다.

이 함수가 호출 된 후 반드시 REST API를 통해 [결제검증](https://docs.bootpay.co.kr/rest/verify)을 수행해야합니다. data 포맷은 아래와 같습니다.

```text
{
  action: "BootpayDone"
  card_code: "CCKM",
  card_name: "KB국민카드",
  card_no: "0000120000000014",
  card_quota: "00",
  item_name: "테스트 아이템",
  method: "card",
  method_name: "카드결제",
  order_id: "1610596422328",
  payment_group: "card",
  payment_group_name: "신용카드",
  payment_name: "카드결제",
  pg: "kcp",
  pg_name: "KCP",
  price: 100,
  purchased_at: "2021-01-14 12:54:53",
  receipt_id: "5fffc0460c20b903e88a2d2c",
  receipt_url: "https://app.bootpay.co.kr/bill/UFMvZzJqSWNDNU9ERWh1YmUycU9hdnBkV29DVlJqdzUxRzZyNXRXbkNVZW81%0AQT09LS1XYlNJN1VoMDI4Q1hRdDh1LS10MEtZVmE4c1dyWHNHTXpZTVVLUk1R%0APT0%3D%0A",
  requested_at: "2021-01-14 12:53:42",
  status: 1,
  tax_free: 0,
  url: "https://d-cdn.bootapi.com"
}
```



# 기타 문의사항이 있으시다면

1. [부트페이 개발연동 문서](https://app.gitbook.com/@bootpay/s/docs/client/pg/android) 참고
2. [부트페이 홈페이지](https://www.bootpay.co.kr) 참고 - 사이트 우측 하단에 채팅으로 기술문의 주시면 됩니다.

# ExCoreMotion

>가속도계, 자이로스코프, 보수계, 자력계 및 기압계를 포함하여 iOS 장치의 온보드 하드웨어에서 모션 및 환경 관련 데이터를 관리할 수 있게 해주는 프레임워크

- **Core Motion** 에서 걸음 관련 데이터를 제공 받을 수 있는 클래스는 총 3개
  - **CMPedometer**: 실시간 걸음 데이터 정보 제공
  - **CMPedometerData**: 사용자가 도보로 이동한 거리 정보 제공
  - **CMPedometerEvent**: 사용자의 보행자 활동 변화 정보 제공
  

- **Determining Pedometer Availability**
```
// 현재 디바이스에서 걸음 수 카운팅 사용 가능 여부
class func isStepCountingAvailable() -> Bool

// 현재 디바이스에서 거리 측정 사용 가능 여부
class func isDistanceAvailable() -> Bool

// 현재 디바이스에서 층 수 측정 사용 가능 여부
class func isFloorCountingAvailable() -> Bool

// 현재 디바이스에서 사용자의 페이스 정보 사용 가능 여부
class func isPaceAvailable() -> Bool

// 현재 디바이스에서 만보계 이벤트 사용 가능 여부
class func isPedometerEventTrackingAvailable() -> Bool

// 앱이 만보계 데이터를 수집할 권한이 있는 지 여부
class func authorizationStatus() -> CMAuthorizationStatus

// 모션 관련 기능에 대한 인증 상태
enum CMAuthorizationStatus
```

- **Gathering Live Pedometer Data**
```
// 보행자 관련 데이터를 전달 시작
func startUpdates(from: Date, withHandler: CMPedometerHandler)

// 보행자 관련 데이터 전달 중지
func stopUpdates()

// 만보계 이벤트 전달 시작
func startEventUpdates(handler: CMPedometerEventHandler)

// 만보계 이벤트 전달 중지
func stopEventUpdates()

// 만보계 관련 데이터 처리 블록
typealias CMPedometerHandler

// 만보계 이벤트 관련 데이터 처리 블록
typealias CMPedometerEventHandler
```

- **Fetching Historical Pedometer Data**
```
// 지정된 Date 사이의 만보계 데이터 수집(최대 7일 가능)
// from의 날짜가 현재 기준 7일 이내 설정
func queryPedometerData(from: Date, to: Date, withHandler: CMPedometerHandler)
```


# Busition Mate

Busition Mate는 통학 버스의 실시간 위치를 추적하고 공유하는 Flutter 기반 모바일 애플리케이션입니다. 사용자는 이 앱을 통해 자신이 탑승할 차량의 현재 위치를 파악하고, 도착 예정 시간을 쉽게 예측할 수 있습니다.


## 기능
- 실시간 위치 추적: 통학 버스의 실시간 위치를 지도상에서 확인할 수 있습니다.
- 도착 예정 시간 알림: 사용자의 탑승 위치까지 남은 시간을 알림으로 제공합니다.
- 다양한 차량 지원: 여러 대의 통학 차량을 등록하고 관리할 수 있습니다.
스크린샷


## 기술 스택
- Flutter
- Firebase Messaging
- Google Maps Flutter
- Geolocator

## 설치 방법
==빌드를 하기 위해서는 key가 필요합니다.==
이 프로젝트를 로컬 환경에서 실행하기 위해서는 Flutter 환경이 세팅되어 있어야 합니다.

```bash
Copy code
git clone https://your-repository-url.git
cd busitionmate
flutter pub get
flutter run
```

## 사용된 라이브러리
```

  # 자동 로그인
  flutter_secure_storage: ^8.0.0

  # 로그인
  firebase_messaging: ^14.6.4
  flutter_local_notifications: ^9.2.0
  firebase_core: ^2.13.0
  json_annotation: ^4.8.1

  # 지도 관련
  google_maps_flutter: ^2.4.0
  geolocator: ^9.0.2
  flutter_svg: ^2.0.9

  # 권한
  permission_handler: ^10.2.0

  # 상태관리
  provider: ^6.1.1

  # 통신
  socket_io_client: ^2.0.3+1

  # BLE
  flutter_ble_peripheral: ^1.2.3

  # DateFormat
  intl: ^0.19.0


```

개발자 정보
개발자 이름: kim990321@gmail.com / moldmen@kookmin.ac.kr

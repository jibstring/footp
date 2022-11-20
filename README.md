<img src="https://lab.ssafy.com/s07-final/S07P31A108/-/raw/master/doc_media/%EB%A1%9C%EA%B3%A0_%EA%B8%B0%EB%B3%B8.png" width="30%" height="30%"/>


# 푸프 Foop

---

## I. “공간에 메시지를 더하다”

### 서비스 소개
같은 장소에 머무르는 사람들과 커뮤니티를 형성하여 추억을 남기고 정보를 공유하는 SNS

### 기획 배경
게임 <다크소울>에서 바닥에 메시지를 남기는 시스템에 모티브를 얻어, 나의 추억을 남기고 또한 동네 커뮤니티 역할을 할 수 있는 서비스를 기획하게 되었습니다.

### 이용 타겟
- 장소에 접목된 새로운 형태의 SNS 서비스를 이용해보고 싶은 사람
- 동네 단위의 교류를 원하는 사람

---

## II. 기능 요약

<img src="https://lab.ssafy.com/s07-final/S07P31A108/-/raw/master/doc_media/%ED%95%98%EB%8B%A8%EB%B0%94-%EB%A9%94%EC%84%B8%EC%A7%80_b.png" width="20%" height="20%"/>

### 발자국 찍기
- 특정 위치에 메세지를 기록
- 사진, 짧은 영상, 음성 첨부 가능
- 물음표 발자국 - 메세지 일부분이 블러 처리


<img src="https://lab.ssafy.com/s07-final/S07P31A108/-/raw/master/doc_media/%ED%95%98%EB%8B%A8%EB%B0%94-%ED%99%95%EC%84%B1%EA%B8%B0_p.png" width="20%" height="20%"/>

### 이벤트 확성기
- 사람을 특정 장소로 불러 모으기 위한 특별한 마커
- 푸프 이용자에게 동시에 알림 발송
- 함께 즐기고 싶은 이벤트가 있다면 간편하게 즉석 공지 가능


<img src="https://lab.ssafy.com/s07-final/S07P31A108/-/raw/master/doc_media/%ED%95%98%EB%8B%A8%EB%B0%94-%EC%8A%A4%ED%83%AC%ED%91%B8_r.png" width="20%" height="20%"/>

### 스탬푸
- 스탬프 투어를 직접 디자인/참가
- 스탬프 목적지에 가까이 다가가 스탬프 시트에 도장 찍기


---

## III. 앱 미리보기


### 서비스 화면
![서비스 화면](./doc_media/서비스 화면.png)

### 서비스 영상
![영상 미리보기](./doc_media/영상미리보기.gif)

![🔗 서비스 소개 영상 보기](/exec/자율PJT_서울_1반_A108_UCC경진대회.mp4)

---

## IV. 프로젝트 개발환경 및 기술 스택

### 백엔드  
▶ Spring 2.7.5  
▶ Java 11  
▶ gradle  
▶ JPA  
▶ SockJS  
▶ MySql  
▶ IntelliJ  

### 프론트엔드  
▶ Dart 2.18.2     
▶ Flutter 3.3.8  
▶ Visual Studio Code  
▶ Android Studio  

### 서버  
▶ AWS  
▶ Docker  
▶ Nginx   

---


## V. 빌드 & 실행

- Spring 빌드
```
$ ./gradlew build
```
- Flutter 빌드
```
$ Flutter build
```
- Flutter appbundle빌드
```
$ Flutter build appbunlde
```
- Flutter 실행
```
$ Flutter run 
```

---

## Ⅵ. 개발자 소개

[FE] 류경하 | UI/UX 담당, 스탬프 기능 구현

[FE] 안예림 | 와이어프레임 설계, 알람 기능 구현

[FE] 김도연 | 발자국 & 확성기 찍기, 결제, 로그인

[FE] 김기태 | 아이디어 기획, GPS 위치기반 담당

[BE] 이지현 | DB 모델링 및 설계, A108 전문 디자이너

[BE] 김태웅 | UI/UX 담당, 편의기능 구현

[BE] 하미르 | 서버 및 배포 담당, 실시간 채팅 담당


---

# swift-starbucks
iOS 클래스 프로젝트 - 스타벅스 앱

<br>

### 프로젝트 진행 상황

[Notion]: https://www.notion.so/Starbucks-App-7440eefcd13c4856bfcad20f60d9be85

#### 팀원

[푸코]: https://github.com/wnsxor1993
[체즈]: https://github.com/asqw887

<br>

---



### 💻 작업내역

#### EventModal 

 - 앱을 시작하면 하루에 한 번 이벤트 화면을 Modal 형식으로 보여줌 

 - 다시 보지않기를 누르면 하루동안 보여주지 않음 

   >  앱 시작시 데이터를 요청하도록 AppDelegate 에서 데이터 요청 
   > Combine을 사용하여 비동기적으로 데이터가 정상적으로 들어오면 EventModal present 호출
   > 마지막 접속시간과, 사용자가 이전에 다시보지 않기 버튼을 눌렀는지 여부를 UserDefault 에 저장하여 처리

<br>		

#### HomeView

- `UICompositionalLayout` 을 사용하여 뷰 구현

  

---



### 👏시도한 것들 

####  기존에 URLSession 을 통한 데이터 요청 작업을 Combine 을 사용하여 구현해보고자 시도.

> 범용적인 사용이 용이하도록 각각의 로직을 분리하고 제네릭을 활용. 
>
> 1. 디코딩된 데이터를 저장할 DataManager 구조체 구현 
>
>    - AppDelegate 내 호출로 인한 데이터 저장 문제로 인해 static 상수로 PassthroughSubject 타입 선언
>
>      
>
> 2.  API 통신 / Decoding 로직 분리
>
>    - URLConnector, JSONConverter로 타입 분리 
>
>    -  AnyPublisher<Data, Error> 타입을 리턴하는 getRequest 함수 구현 
>
>    -  URL 타입을 매개변수로 받아 관련 API 통신 후, Data를 디코딩하는 getEventData 함수 구현
>
>      
>
> 3.  제네릭을 사용하여 원하는 타입 별로 데이터 통신이 용이하도록 구현



​    <br>

#### CollectionView Header 가 좌측에 위치하는 문제점

> CollectionView Layout 이 Horizontal 로 설정되어있어 Header의 레이아웃도 동일하게 처리되는 문제가 발생
>
> 기존에는 TableView 에 CollectionView를 넣는 구조로 방향성을 잡았고, 이를 해결하기 위해서 
>
> 1. TableView Section Header 를 설정 
> 2. 기존의 구조가 아닌 CollectionView 에 UICompositionalLayout 을 적용하여 구현 
>
> 2번의 방식이 뷰 구조가 더 간단해지고 새로 학습하기에 좋은 부분이라고 생각되어 2번방식을 적용



---



### 결과물 

---




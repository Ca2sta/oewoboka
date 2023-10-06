# Template
기본 템플릿을 제공하는 레파지토리 입니다.
# 외워 보카!

# 프로젝트 소개

- VoCat 이라는 단어장 앱을 참고하여 UI 구성
- 목표 : 코드베이스 UI, 애니메이션 활용해보기, SnapKit을 사용해서 오토레이아웃 잡기
- 파일 구조
    
    ![스크린샷 2023-10-06 오후 12.39.39.png](https://prod-files-secure.s3.us-west-2.amazonaws.com/83c75a39-3aba-4ba4-a792-7aefe4b07895/edf73f2e-1ea2-4984-86c0-6332bbb185fe/%EC%8A%A4%ED%81%AC%EB%A6%B0%EC%83%B7_2023-10-06_%EC%98%A4%ED%9B%84_12.39.39.png)
    
    - Enum : 공용으로 사용되는 Enum을 모아두는 폴더
    - Extenstions: 기존에 Apple에서 제공해주는 UIkit이나 기본 타입들을 확장할때 모아두는 폴더
    - View: 공통으로 사용되는 뷰를 모아두는 폴더
    - Helper: 기본 폰트, 기본 마진, 스크린사이즈 같이 자주 사용되고 편리한 기능하는 파일들을 모아두는 폴더
    - Resource: 이미지 Assets, AppDelegate, SceneDelegate
    - Model: CoreData 파일과 연결시켜주는 Repository 파일, 파파고 Api 데이터 모델
    - Scenes: 최상위에는 첫 시작인 TabbarController와 자주 사용하는 BottomSheetViewController, 화면 전환시 사용되는 PresentationController가 있고, 각자 화면들이 폴더에 나눠져 있는 형태
    - Client: 파파고 APIKEY
    

# 💡 아이디어 회의

https://www.figma.com/embed?embed_host=notion&url=https://www.figma.com/file/53fjcyxRqK6GJUOeE1lMXM/외워보카!-아이디어-회의?type=whiteboard&node-id=0-1&t=P60ofhq6JBX5yqQl-0

# 🛠️ 와이어 프레임

https://www.figma.com/embed?embed_host=notion&url=https%3A%2F%2Fwww.figma.com%2Ffile%2FhmAz7esua9C59agXRzS7TQ%2F%EC%99%B8%EC%9B%8C-%EB%B3%B4%EC%B9%B4!%3Ftype%3Ddesign%26node-id%3D0-1%26mode%3Ddesign%26t%3DH6nPaTfxfeYGezer-0

# ❗️ Git Conventions

- `develop` : 깃허브의 이슈로 브렌치를 만들어서 작업합니다.
- Commit Message는 아래와 같은 규칙을 따릅니다.
    - [FEAT]: 새로운 기능을 추가
    - [FIX]: 잔잔바리 수정
    - [DESIGN]: UI 디자인 변경
    - [STYLE]: 코드 포맷 변경, 세미 콜론 누락, 코드 수정이 없는 경우
    - [DOCS]: 문서 수정, 필요한 주석 추가 및 변경
    - [RENAME]: 파일 혹은 폴더명을 수정하거나 옮기는 작업만인 경우
    - [REMOVE]: 파일을 삭제하는 작업만 수행한 경우
    - [MERGE] : 병합
    - [CONFLICT]: 병합 시 충돌 해결
- Pull Requests는 `Commit Message`와 동일하게 써서 올립니다.

# 🤪 Task List

https://github.com/orgs/Ca2sta/projects/1/views/1

[](https://github.com/orgs/Ca2sta/projects/1)

# 🙆‍♂️ 역할 분담

- 이동건 : AddVocabularyPage(영단어 추가화면) 구현
- 이선규:  VocaListPage(영단어 리스트화면) 구현
- 김도현: QuizPage(영단어 시험 화면) 구현
- 서준영: FeaturePage(학습선택 화면) 구현

# 📢발표 자료

https://www.figma.com/embed?embed_host=notion&url=https%3A%2F%2Fwww.figma.com%2Ffile%2FhmAz7esua9C59agXRzS7TQ%2F%EC%99%B8%EC%9B%8C-%EB%B3%B4%EC%B9%B4!%3Ftype%3Ddesign%26node-id%3D344-144%26mode%3Ddesign%26t%3DXQqG0nmN2auHsIAG-0

# 🎥 시연 영상

[Simulator Screen Recording   iPhone 14 Pro   2023 10 06 at 09 58 47](https://www.youtube.com/watch?v=gID6Y-fl12s&t=10s)

# 🔧 SA 피드백!

[프로젝트 관리]

깃 컨벤션은 촘촘하게, 기능은 페이지 단위로 구성을 잘 해주셨으나, 전체 일정 관리는 어떻게 할 것인지 확인이 되지 않습니다. 일정을 짜주세요!

사용하고 있는 기술들을 정리하고 정하여 사용하면 좋을 것 같습니다.

[와이어프레임]

탭바 기반이고 아래에서 위로 올라오는 Present 기반의 인터렉션이 많을 것 같습니다. 각 인터렉션 바다 UI가 꼬이지 않도록 설게를 잘하면 좋을 것 같습니다. view controller가 보였다가 안보였다 함에 따라서 데이터 업데이트도 신경쓰면 좋을것 같습니다.

[기능 분담]

아이디어를 나누기 부터 시작하여, 좋은 기능과 구체적인 구현 요소들이 나온 것 같습니다. UI 컴포넌트들 중 공통으로 사용될 수 있는 것도 고민해보시면서 분담하여 만드시면 좋을 것 같습니다.

# 👍 회고록

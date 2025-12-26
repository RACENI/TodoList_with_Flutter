# ✅ TodoList_with_Flutter

Flutter 학습용 To-do 리스트 앱입니다.  
할 일 추가/삭제/완료 처리, 상세 화면에서 수정, 검색/필터/마감일 기능을 포함합니다.  
로컬 저장소는 **Hive**를 사용합니다.

---

## ✨ 주요 기능

- 할 일 추가 / 삭제 / 완료(체크) 처리 기능을 제공합니다.
- 상세 페이지에서 할 일 제목 수정 기능을 제공합니다.
- 상태 관리는 Provider(ChangeNotifier) 기반으로 구성되어 있습니다.
- 로컬 저장은 Hive(Box) 기반으로 동작합니다.
- 검색(키워드) 및 필터(전체/완료/미완료) 기능을 제공합니다.
- 마감일(dueDate) 선택 및 마감일 기준 정렬 기능을 제공합니다.

---

## 🧰 기술 스택

- Flutter
- Dart
- provider
- hive / hive_flutter
- path_provider (모바일/데스크톱에서 Hive 경로 설정에 사용합니다.)

---

## ▶ 실행 방법

1) 의존성 설치를 수행합니다.

```bash
flutter pub get
```

2) (선택) Hive TypeAdapter를 재생성해야 하는 경우 아래를 수행합니다.

```bash
dart run build_runner build --delete-conflicting-outputs
```

3) 앱을 실행합니다.

```bash
flutter run
```

---

## 💾 로컬 저장(Hive)

- 앱은 Hive Box `"todos"`에 Todo 데이터를 저장합니다.
- `Todo` 모델은 `HiveObject`를 상속하며, 수정 후 `save()` 호출로 반영됩니다.
- 웹(Web)에서는 hive_flutter가 IndexedDB 기반 저장을 사용합니다.

---

## 📂 프로젝트 구조

```text
lib/
  main.dart            # Hive 초기화 + Provider 주입
  Todo.dart            # Hive 모델(Todo) + enum(TodoFilter)
  Todo.g.dart          # Hive TypeAdapter(자동 생성 파일)
  todo_provider.dart   # 상태관리(ChangeNotifier) + CRUD/필터/검색/정렬
  TodoHome.dart        # 목록/추가/검색/필터/마감일 UI
  DetailPage.dart      # 상세(수정) UI
```

---

## ⚠️ 주의사항

- Hive 모델을 수정하는 경우 `Todo.g.dart` 재생성이 필요할 수 있습니다.
- 필터/검색/정렬이 들어간 리스트에서 index 기반으로 삭제/수정/토글을 수행하면,
  저장소(Box)와 화면 index가 달라져 의도치 않은 항목이 변경될 수 있습니다.
  안정성을 위해 Todo 객체(또는 key) 기반으로 CRUD를 수행하는 방식이 권장됩니다.

---

## 🚀 향후 개선 계획

- Todo 항목을 key 기반으로 수정/삭제/토글하도록 리팩토링을 진행합니다.
- 마감일/완료 여부 기반 정렬 옵션을 추가합니다.
- UI를 컴포넌트 단위로 분리하여 가독성과 테스트 용이성을 개선합니다.
- 불필요한 의존성(shared_preferences 등) 정리를 진행합니다.

---

## 🗓 제작 정보

- 목적: Flutter 학습 및 상태관리/로컬 저장 실습을 위한 프로젝트입니다.

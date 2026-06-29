# 습관 트래커 1단계 구현 계획

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** SwiftUI로 습관을 목록으로 보고, 추가·수정·삭제할 수 있는 iOS 앱(1단계, 메모리 상태만)을 만든다.

**Architecture:** `HabitStore`(@Observable 클래스)가 습관 배열의 단일 출처가 되어 add/update/delete를 제공하고, SwiftUI 뷰들이 이 스토어를 환경(`environment`)으로 주입받아 읽고 변경한다. 추가/수정은 같은 폼 화면(`HabitFormView`)을 시트로 재사용한다.

**Tech Stack:** Swift, SwiftUI, Observation(`@Observable`), Xcode, iOS 17+, XCTest

> **초보자 안내:** 이 앱은 1단계에서 **저장 기능이 없어** 앱을 완전히 종료하면 데이터가 사라집니다. 의도된 동작입니다(새로고침하면 state가 초기화되는 React 앱과 동일). 저장은 2단계에서 추가합니다.

---

## 파일 구조

Xcode 프로젝트를 `swift-demo-habit-tracker/` 안에 **Product Name: `HabitTracker`** 로 생성하므로, 경로는 다음과 같다 (모든 경로는 저장소 루트 `swift-demo-habit-tracker/` 기준).

```
HabitTracker/
 ├─ HabitTracker.xcodeproj          Xcode 프로젝트 파일 (Task 0에서 자동 생성)
 ├─ HabitTracker/
 │   ├─ HabitTrackerApp.swift       앱 진입점 (스토어 생성·주입)  ← Task 0 생성, Task 3 수정
 │   ├─ Models/
 │   │   └─ Habit.swift             Habit 모델 + HabitColor 팔레트   ← Task 1
 │   ├─ Store/
 │   │   └─ HabitStore.swift        습관 배열 + add/update/delete    ← Task 2
 │   └─ Views/
 │       ├─ HabitListView.swift     메인 목록 화면                   ← Task 3,4,5,6
 │       ├─ HabitRowView.swift      목록의 한 행                     ← Task 3
 │       └─ HabitFormView.swift     추가/수정 공용 폼 화면           ← Task 4,5
 └─ HabitTrackerTests/
     └─ HabitStoreTests.swift       HabitStore 단위 테스트           ← Task 2
```

> Xcode가 자동 생성하는 `ContentView.swift`는 Task 3에서 삭제한다.

각 파일은 한 가지 책임만 진다. 뷰는 화면별로 분리해 한눈에 파악하기 쉽게 한다.

---

## Task 0: Xcode 프로젝트 생성

**Files:**
- Create: `HabitTracker/HabitTracker.xcodeproj` (Xcode가 자동 생성)

- [ ] **Step 1: Xcode에서 새 프로젝트 생성**

Xcode 실행 → 메뉴 `File > New > Project…` → 상단 **iOS** 탭 → **App** 선택 → `Next`.
다음 화면에서 입력:
- **Product Name:** `HabitTracker`
- **Interface:** `SwiftUI`
- **Language:** `Swift`
- **Storage:** `None` (또는 비어 있으면 그대로)
- **Include Tests:** ✅ **체크** (테스트 타깃이 같이 만들어져야 함)

`Next` → 저장 위치로 **`/Users/imheejung/Study/swift-demo-habit-tracker`** 폴더 선택.
("Create Git repository on my Mac" 체크박스는 **해제** — 이미 git 저장소가 있음) → `Create`.

생성 후 폴더 구조가 `swift-demo-habit-tracker/HabitTracker/HabitTracker.xcodeproj` 형태인지 확인.

- [ ] **Step 2: 시뮬레이터에서 기본 실행 확인**

Xcode 좌상단에서 실행 대상(시뮬레이터, 예: iPhone 16)을 고르고 `▶` (Run, `Cmd+R`) 클릭.
Expected: 시뮬레이터가 켜지고 "Hello, world!" 화면이 뜬다.

- [ ] **Step 3: 커밋**

```bash
cd /Users/imheejung/Study/swift-demo-habit-tracker
git add -A
git commit -m "chore: Xcode 프로젝트 생성 (HabitTracker)"
```

---

## Task 1: Habit 모델 + 색상 팔레트

**Files:**
- Create: `HabitTracker/HabitTracker/Models/Habit.swift`

- [ ] **Step 1: Models 그룹과 Habit.swift 생성**

Xcode 좌측 파일 목록에서 `HabitTracker`(파란 아이콘 아님, 노란 폴더) 안의 `HabitTracker` 그룹을 우클릭 → `New Group` → 이름 `Models`.
`Models` 우클릭 → `New File from Template…` → **Swift File** → 이름 `Habit` → `HabitTracker` 타깃 체크 확인 → 생성.

- [ ] **Step 2: Habit.swift 작성**

```swift
import SwiftUI

/// 습관 하나를 나타내는 데이터 모델.
struct Habit: Identifiable, Equatable {
    let id: UUID
    var name: String
    var icon: String          // 이모지 (예: "🏃")
    var colorName: HabitColor

    init(id: UUID = UUID(), name: String, icon: String, colorName: HabitColor) {
        self.id = id
        self.name = name
        self.icon = icon
        self.colorName = colorName
    }
}

/// 습관에 쓸 수 있는 미리 정해진 색 팔레트.
enum HabitColor: String, CaseIterable, Identifiable {
    case red, orange, green, blue, purple

    var id: String { rawValue }

    /// 화면에서 실제로 쓰는 SwiftUI 색으로 변환.
    var color: Color {
        switch self {
        case .red: return .red
        case .orange: return .orange
        case .green: return .green
        case .blue: return .blue
        case .purple: return .purple
        }
    }
}
```

- [ ] **Step 3: 빌드 확인**

Xcode에서 `Cmd+B` (Build).
Expected: "Build Succeeded" (에러 없음).

- [ ] **Step 4: 커밋**

```bash
git add -A
git commit -m "feat: Habit 모델과 HabitColor 팔레트 추가"
```

---

## Task 2: HabitStore (TDD)

습관 배열을 보관하고 add/update/delete를 제공하는 스토어. **테스트를 먼저 작성**한다.

**Files:**
- Create: `HabitTracker/HabitTracker/Store/HabitStore.swift`
- Test: `HabitTracker/HabitTrackerTests/HabitStoreTests.swift`

- [ ] **Step 1: 실패하는 테스트 작성**

Xcode에서 `Store` 그룹 생성(Task 1의 Models와 동일 방식). 아직 `HabitStore.swift`는 만들지 않는다.
`HabitTrackerTests` 그룹 안에 Xcode가 만들어 둔 기본 테스트 파일이 있으면 그 내용을 아래로 교체하거나, 새 Swift File `HabitStoreTests`를 만든다 (타깃은 **HabitTrackerTests** 체크).

```swift
import XCTest
@testable import HabitTracker

final class HabitStoreTests: XCTestCase {

    func test_add_습관을_배열에_추가한다() {
        let store = HabitStore()
        let habit = Habit(name: "운동", icon: "🏃", colorName: .green)

        store.add(habit)

        XCTAssertEqual(store.habits.count, 1)
        XCTAssertEqual(store.habits.first?.name, "운동")
    }

    func test_update_같은_id의_습관을_교체한다() {
        let store = HabitStore()
        var habit = Habit(name: "운동", icon: "🏃", colorName: .green)
        store.add(habit)

        habit.name = "달리기"
        store.update(habit)

        XCTAssertEqual(store.habits.count, 1)
        XCTAssertEqual(store.habits.first?.name, "달리기")
    }

    func test_delete_지정한_위치의_습관을_제거한다() {
        let store = HabitStore()
        store.add(Habit(name: "운동", icon: "🏃", colorName: .green))
        store.add(Habit(name: "독서", icon: "📖", colorName: .blue))

        store.delete(at: IndexSet(integer: 0))

        XCTAssertEqual(store.habits.count, 1)
        XCTAssertEqual(store.habits.first?.name, "독서")
    }
}
```

- [ ] **Step 2: 테스트 실행해서 실패 확인**

Xcode에서 `Cmd+U` (Test).
또는 터미널:
```bash
cd /Users/imheejung/Study/swift-demo-habit-tracker
xcodebuild test \
  -project HabitTracker/HabitTracker.xcodeproj \
  -scheme HabitTracker \
  -destination 'platform=iOS Simulator,name=iPhone 16'
```
(설치된 시뮬레이터 이름은 `xcrun simctl list devices available` 로 확인 후 맞게 조정)
Expected: **컴파일 실패** — "Cannot find 'HabitStore' in scope" (아직 HabitStore가 없음).

- [ ] **Step 3: HabitStore 최소 구현**

`Store` 그룹에 `HabitStore.swift` 생성 (타깃 **HabitTracker** 체크) 후 작성:

```swift
import Foundation

/// 습관 목록의 단일 출처(single source of truth).
/// @Observable: 이 객체의 속성이 바뀌면 이를 보는 SwiftUI 뷰가 자동으로 다시 그려진다.
@Observable
final class HabitStore {
    var habits: [Habit] = []

    /// 새 습관을 목록 끝에 추가.
    func add(_ habit: Habit) {
        habits.append(habit)
    }

    /// 같은 id를 가진 습관을 찾아 통째로 교체. 없으면 아무것도 하지 않음.
    func update(_ habit: Habit) {
        guard let index = habits.firstIndex(where: { $0.id == habit.id }) else { return }
        habits[index] = habit
    }

    /// 목록에서 지정한 위치(들)의 습관을 제거. List의 onDelete가 주는 IndexSet과 호환.
    func delete(at offsets: IndexSet) {
        habits.remove(atOffsets: offsets)
    }
}
```

- [ ] **Step 4: 테스트 실행해서 통과 확인**

Xcode `Cmd+U` (또는 Step 2의 xcodebuild 명령).
Expected: 3개 테스트 모두 **PASS** (초록 체크).

- [ ] **Step 5: 커밋**

```bash
git add -A
git commit -m "feat: HabitStore의 add/update/delete 구현 (TDD)"
```

---

## Task 3: 메인 목록 화면 + 빈 상태

앱 진입점을 스토어 주입으로 바꾸고, 빈 상태 안내가 보이는 목록 화면을 만든다. (이 단계에서는 + 버튼이 아직 동작하지 않는다.)

**Files:**
- Modify: `HabitTracker/HabitTracker/HabitTrackerApp.swift`
- Create: `HabitTracker/HabitTracker/Views/HabitListView.swift`
- Create: `HabitTracker/HabitTracker/Views/HabitRowView.swift`
- Delete: `HabitTracker/HabitTracker/ContentView.swift`

- [ ] **Step 1: ContentView.swift 삭제**

Xcode 파일 목록에서 `ContentView.swift` 우클릭 → `Delete` → **`Move to Trash`** 선택.

- [ ] **Step 2: HabitTrackerApp.swift 수정**

파일 전체를 아래로 교체:

```swift
import SwiftUI

@main
struct HabitTrackerApp: App {
    // 앱 전체에서 공유할 스토어를 한 번만 생성.
    @State private var store = HabitStore()

    var body: some Scene {
        WindowGroup {
            HabitListView()
                .environment(store)   // 하위 뷰(시트 포함)에 스토어 주입
        }
    }
}
```

- [ ] **Step 3: HabitRowView.swift 작성**

`Views` 그룹 생성 후 `HabitRowView.swift` (타깃 HabitTracker):

```swift
import SwiftUI

/// 목록의 한 줄: 아이콘 + 이름 + 색 점.
struct HabitRowView: View {
    let habit: Habit

    var body: some View {
        HStack(spacing: 12) {
            Text(habit.icon)
                .font(.title2)
            Text(habit.name)
                .font(.body)
            Spacer()
            Circle()
                .fill(habit.colorName.color)
                .frame(width: 12, height: 12)
        }
    }
}
```

- [ ] **Step 4: HabitListView.swift 작성**

`Views` 그룹에 `HabitListView.swift` (타깃 HabitTracker):

```swift
import SwiftUI

struct HabitListView: View {
    @Environment(HabitStore.self) private var store
    @State private var isPresentingAddForm = false

    var body: some View {
        NavigationStack {
            Group {
                if store.habits.isEmpty {
                    ContentUnavailableView(
                        "습관을 추가해보세요",
                        systemImage: "plus.circle",
                        description: Text("오른쪽 위 + 버튼을 눌러 첫 습관을 만들어요.")
                    )
                } else {
                    List {
                        ForEach(store.habits) { habit in
                            HabitRowView(habit: habit)
                        }
                    }
                }
            }
            .navigationTitle("내 습관")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isPresentingAddForm = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
}
```

- [ ] **Step 5: 시뮬레이터에서 확인**

`Cmd+R` 실행.
Expected: 상단 제목 "내 습관", 가운데 "습관을 추가해보세요" 안내와 안내 문구, 우상단 `+` 버튼이 보인다. (+ 버튼을 눌러도 아직 아무 일도 일어나지 않는 것이 정상)

- [ ] **Step 6: 커밋**

```bash
git add -A
git commit -m "feat: 메인 목록 화면과 빈 상태 UI, 스토어 주입"
```

---

## Task 4: 습관 추가 폼 (추가 기능 완성)

폼 화면을 만들고 + 버튼이 시트로 폼을 띄워 습관을 추가하도록 연결한다.

**Files:**
- Create: `HabitTracker/HabitTracker/Views/HabitFormView.swift`
- Modify: `HabitTracker/HabitTracker/Views/HabitListView.swift`

- [ ] **Step 1: HabitFormView.swift 작성**

`Views` 그룹에 `HabitFormView.swift` (타깃 HabitTracker):

```swift
import SwiftUI

/// 추가와 수정에 공용으로 쓰는 폼.
/// habitToEdit 이 nil 이면 "추가" 모드, 값이 있으면 "수정" 모드.
struct HabitFormView: View {
    @Environment(HabitStore.self) private var store
    @Environment(\.dismiss) private var dismiss

    let habitToEdit: Habit?

    @State private var name: String
    @State private var icon: String
    @State private var colorName: HabitColor

    private let iconOptions = ["💧", "🏃", "📖", "🍎", "💊"]

    init(habitToEdit: Habit?) {
        self.habitToEdit = habitToEdit
        // 수정 모드면 기존 값으로, 추가 모드면 기본값으로 폼을 채운다.
        _name = State(initialValue: habitToEdit?.name ?? "")
        _icon = State(initialValue: habitToEdit?.icon ?? "💧")
        _colorName = State(initialValue: habitToEdit?.colorName ?? .blue)
    }

    private var isEditing: Bool { habitToEdit != nil }

    private var trimmedName: String {
        name.trimmingCharacters(in: .whitespaces)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("이름") {
                    TextField("예: 운동하기", text: $name)
                }
                Section("아이콘") {
                    HStack {
                        ForEach(iconOptions, id: \.self) { option in
                            Text(option)
                                .font(.title2)
                                .padding(8)
                                .background(icon == option ? Color.gray.opacity(0.3) : Color.clear)
                                .clipShape(Circle())
                                .onTapGesture { icon = option }
                        }
                    }
                }
                Section("색상") {
                    HStack(spacing: 12) {
                        ForEach(HabitColor.allCases) { option in
                            Circle()
                                .fill(option.color)
                                .frame(width: 30, height: 30)
                                .overlay(
                                    Circle().stroke(Color.primary,
                                                    lineWidth: colorName == option ? 3 : 0)
                                )
                                .onTapGesture { colorName = option }
                        }
                    }
                }
            }
            .navigationTitle(isEditing ? "습관 수정" : "새 습관")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("취소") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("저장") { save() }
                        .disabled(trimmedName.isEmpty)   // 이름 비면 저장 불가
                }
            }
        }
    }

    private func save() {
        if let editing = habitToEdit {
            store.update(Habit(id: editing.id, name: trimmedName, icon: icon, colorName: colorName))
        } else {
            store.add(Habit(name: trimmedName, icon: icon, colorName: colorName))
        }
        dismiss()
    }
}
```

- [ ] **Step 2: HabitListView에 추가 시트 연결**

`HabitListView.swift` 의 `.toolbar { ... }` 바로 **아래**(`.navigationTitle` 과 같은 레벨)에 시트를 추가한다. 즉 `.toolbar { ... }` 닫는 중괄호 다음 줄에 아래를 삽입:

```swift
            .sheet(isPresented: $isPresentingAddForm) {
                HabitFormView(habitToEdit: nil)
            }
```

수정 후 `HabitListView` 의 `NavigationStack { ... }` 내부 끝부분이 다음 순서가 되어야 한다: `.navigationTitle("내 습관")` → `.toolbar { ... }` → `.sheet(isPresented:) { ... }`.

- [ ] **Step 3: 시뮬레이터에서 확인**

`Cmd+R` 실행.
Expected:
1. `+` 버튼 → 아래에서 "새 습관" 폼이 올라온다.
2. 이름이 비어 있으면 "저장"이 흐리게(비활성) 표시된다.
3. 이름 입력 + 아이콘/색 선택 후 "저장" → 시트가 닫히고 목록에 새 습관이 보인다.
4. "취소"를 누르면 추가 없이 닫힌다.

- [ ] **Step 4: 커밋**

```bash
git add -A
git commit -m "feat: 습관 추가 폼과 시트 연결"
```

---

## Task 5: 습관 수정 (행 탭 → 폼)

목록의 행을 탭하면 그 습관 값이 채워진 폼이 열리고, 저장하면 갱신되게 한다.

**Files:**
- Modify: `HabitTracker/HabitTracker/Views/HabitListView.swift`

- [ ] **Step 1: HabitListView에 편집 상태와 탭/시트 추가**

`HabitListView` 를 아래 전체로 교체:

```swift
import SwiftUI

struct HabitListView: View {
    @Environment(HabitStore.self) private var store
    @State private var isPresentingAddForm = false
    @State private var editingHabit: Habit? = nil

    var body: some View {
        NavigationStack {
            Group {
                if store.habits.isEmpty {
                    ContentUnavailableView(
                        "습관을 추가해보세요",
                        systemImage: "plus.circle",
                        description: Text("오른쪽 위 + 버튼을 눌러 첫 습관을 만들어요.")
                    )
                } else {
                    List {
                        ForEach(store.habits) { habit in
                            HabitRowView(habit: habit)
                                .contentShape(Rectangle())   // 행 전체를 탭 영역으로
                                .onTapGesture {
                                    editingHabit = habit
                                }
                        }
                    }
                }
            }
            .navigationTitle("내 습관")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isPresentingAddForm = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $isPresentingAddForm) {
                HabitFormView(habitToEdit: nil)
            }
            .sheet(item: $editingHabit) { habit in
                HabitFormView(habitToEdit: habit)
            }
        }
    }
}
```

- [ ] **Step 2: 시뮬레이터에서 확인**

`Cmd+R` 실행.
Expected: 습관을 하나 추가한 뒤 그 행을 탭하면 "습관 수정" 폼이 기존 값(이름·아이콘·색)으로 채워진 채 열린다. 값을 바꿔 "저장" → 목록의 해당 행이 바뀐다.

- [ ] **Step 3: 커밋**

```bash
git add -A
git commit -m "feat: 행 탭으로 습관 수정"
```

---

## Task 6: 습관 삭제 (스와이프)

목록 행을 옆으로 밀어 삭제한다.

**Files:**
- Modify: `HabitTracker/HabitTracker/Views/HabitListView.swift`

- [ ] **Step 1: ForEach에 onDelete 추가**

`HabitListView` 의 `List { ForEach(...) { ... } }` 부분에서, `ForEach` 블록 **닫는 중괄호 바로 다음**에 `.onDelete` 를 붙인다. 해당 부분이 다음과 같이 되도록 수정:

```swift
                    List {
                        ForEach(store.habits) { habit in
                            HabitRowView(habit: habit)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    editingHabit = habit
                                }
                        }
                        .onDelete { offsets in
                            store.delete(at: offsets)
                        }
                    }
```

- [ ] **Step 2: 시뮬레이터에서 확인**

`Cmd+R` 실행.
Expected: 목록에서 행을 왼쪽으로 밀면 빨간 "Delete" 버튼이 나타나고, 누르면 그 습관이 목록에서 사라진다.

- [ ] **Step 3: 커밋**

```bash
git add -A
git commit -m "feat: 스와이프로 습관 삭제"
```

---

## Task 7: 마무리 — README 진행 상태 갱신

**Files:**
- Modify: `README.md:42-44`

- [ ] **Step 1: 진행 상태 체크 갱신**

`README.md` 의 "진행 상태" 항목을 아래로 교체:

```markdown
## 진행 상태

- [x] 1단계 설계 문서 작성
- [x] 1단계 구현 (목록 + 추가/수정/삭제)
- [ ] 2단계 구현 (기기에 저장)
```

- [ ] **Step 2: 전체 동작 최종 확인 (성공 기준)**

`Cmd+R` 후 아래를 모두 확인:
- [ ] 실행 시 빈 상태 안내가 보인다.
- [ ] + 로 습관을 추가하면 목록에 나타난다.
- [ ] 행을 탭해 수정하면 반영된다.
- [ ] 행을 밀어 삭제하면 사라진다.
- [ ] 이름이 비면 저장 버튼이 비활성화된다.

그리고 `Cmd+U` 로 HabitStore 테스트 3개가 모두 통과하는지 확인.

- [ ] **Step 3: 커밋 + 푸시**

```bash
git add -A
git commit -m "docs: README 진행 상태 갱신 (1단계 완료)"
git push
```

---

## 완료 정의 (Definition of Done)

- 위 Task 0~7의 모든 체크박스 완료
- `Cmd+U`: HabitStore 단위 테스트 3개 PASS
- 시뮬레이터에서 추가/수정/삭제/빈 상태/저장 비활성화 모두 정상
- 모든 변경 사항 GitHub `main`에 푸시 완료

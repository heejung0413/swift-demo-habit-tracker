# CLAUDE.md — swift-demo-habit-tracker

Swift/SwiftUI 학습용 습관 트래커 데모 앱. 설계는 `docs/superpowers/specs/`, 구현 계획은 `docs/superpowers/plans/` 참고.

## Learned Rules

- **GitHub push 계정:** 이 저장소(`heejung0413/swift-demo-habit-tracker`)에 push하려면 활성 `gh` 계정이 **`heejung0413`** 이어야 한다. 기본 활성 계정이 `jiran-heejung0413`로 잡혀 있으면 403(권한 거부)이 난다. push 전 `gh auth status`로 Active account 확인, 다르면 `gh auth switch --user heejung0413`.
- **단계별 학습 프로젝트:** 1단계=목록+추가/수정/삭제(메모리만), 2단계=저장, 3단계=체크/streak, 4단계=상세/달력/통계, 5단계=알림. 한 번에 한 단계씩만 구현한다.
- **TDD 적용 범위:** 로직(`HabitStore` 등)은 XCTest로 TDD, SwiftUI 뷰는 시뮬레이터에서 수동 확인.
- **Xcode 프로젝트 위치:** `.xcodeproj`는 `HabitTracker/HabitTracker.xcodeproj` (저장소 루트 기준). 모듈명은 `HabitTracker`.

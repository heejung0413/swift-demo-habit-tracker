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

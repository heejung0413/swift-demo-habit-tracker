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

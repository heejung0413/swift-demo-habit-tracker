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

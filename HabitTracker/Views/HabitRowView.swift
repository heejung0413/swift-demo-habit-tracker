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

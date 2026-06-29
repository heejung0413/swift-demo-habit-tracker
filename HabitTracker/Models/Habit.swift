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

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

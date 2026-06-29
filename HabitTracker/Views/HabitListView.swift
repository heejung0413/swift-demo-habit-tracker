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
                        .onDelete { offsets in
                            store.delete(at: offsets)
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

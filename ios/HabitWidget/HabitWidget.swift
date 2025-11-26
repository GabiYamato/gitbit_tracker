import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> HabitEntry {
        HabitEntry(date: Date(), habits: [])
    }

    func getSnapshot(in context: Context, completion: @escaping (HabitEntry) -> ()) {
        let entry = HabitEntry(date: Date(), habits: loadHabits())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let currentDate = Date()
        let habits = loadHabits()
        let entry = HabitEntry(date: currentDate, habits: habits)
        
        // Update every 15 minutes
        let nextUpdate = Calendar.current.date(byAdding: .minute, value: 15, to: currentDate)!
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        completion(timeline)
    }
    
    func loadHabits() -> [HabitData] {
        var habits: [HabitData] = []
        
        guard let userDefaults = UserDefaults(suiteName: "group.com.example.gitbittracker") else {
            return habits
        }
        
        let habitCount = userDefaults.integer(forKey: "habit_count")
        
        for i in 0..<min(habitCount, 10) {
            let prefix = "habit_\(i)"
            
            guard let id = userDefaults.string(forKey: "\(prefix)_id"),
                  let name = userDefaults.string(forKey: "\(prefix)_name") else {
                continue
            }
            
            let iconCode = userDefaults.integer(forKey: "\(prefix)_icon")
            let streak = userDefaults.integer(forKey: "\(prefix)_streak")
            let completedToday = userDefaults.bool(forKey: "\(prefix)_completed_today")
            
            var progress: [Bool] = []
            for day in 0..<7 {
                let completed = userDefaults.bool(forKey: "\(prefix)_day_\(day)")
                progress.append(completed)
            }
            
            habits.append(HabitData(
                id: id,
                name: name,
                iconCode: iconCode,
                streak: streak,
                completedToday: completedToday,
                progress: progress
            ))
        }
        
        return habits
    }
}

struct HabitEntry: TimelineEntry {
    let date: Date
    let habits: [HabitData]
}

struct HabitData {
    let id: String
    let name: String
    let iconCode: Int
    let streak: Int
    let completedToday: Bool
    let progress: [Bool]
}

struct HabitWidgetEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family

    var body: some View {
        switch family {
        case .systemSmall:
            SmallWidgetView(habits: entry.habits)
        case .systemMedium:
            MediumWidgetView(habits: entry.habits)
        case .systemLarge:
            LargeWidgetView(habits: entry.habits)
        @unknown default:
            Text("Unknown widget size")
        }
    }
}

struct SmallWidgetView: View {
    let habits: [HabitData]
    
    var body: some View {
        if let habit = habits.first {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(habit.name)
                        .font(.system(size: 16, weight: .semibold))
                        .lineLimit(1)
                    Spacer()
                    Image(systemName: habit.completedToday ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(habit.completedToday ? .green : .gray)
                }
                
                HStack(spacing: 4) {
                    ForEach(0..<7, id: \.self) { index in
                        RoundedRectangle(cornerRadius: 2)
                            .fill(habit.progress[index] ? Color.green : Color.gray.opacity(0.3))
                            .frame(height: 20)
                    }
                }
                
                Spacer()
                
                HStack {
                    Image(systemName: "flame.fill")
                        .foregroundColor(.orange)
                    Text("\(habit.streak) day streak")
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                }
            }
            .padding()
            .widgetURL(URL(string: "habittracker://toggle?habitId=\(habit.id)"))
        } else {
            VStack {
                Text("No habits")
                    .font(.headline)
                Text("Add a habit in the app")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
        }
    }
}

struct MediumWidgetView: View {
    let habits: [HabitData]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Habits")
                .font(.system(size: 18, weight: .bold))
                .padding(.bottom, 4)
            
            if habits.isEmpty {
                Spacer()
                Text("No habits yet")
                    .foregroundColor(.secondary)
                Spacer()
            } else {
                ForEach(habits.prefix(3), id: \.id) { habit in
                    HabitRowView(habit: habit)
                }
            }
        }
        .padding()
    }
}

struct LargeWidgetView: View {
    let habits: [HabitData]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Habits")
                .font(.system(size: 20, weight: .bold))
                .padding(.bottom, 4)
            
            if habits.isEmpty {
                Spacer()
                VStack(spacing: 8) {
                    Image(systemName: "chart.bar.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.secondary)
                    Text("No habits yet")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    Text("Add habits in the app")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Spacer()
            } else {
                ForEach(habits.prefix(6), id: \.id) { habit in
                    HabitRowView(habit: habit)
                        .padding(.bottom, 4)
                }
            }
        }
        .padding()
    }
}

struct HabitRowView: View {
    let habit: HabitData
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: habit.completedToday ? "checkmark.circle.fill" : "circle")
                .foregroundColor(habit.completedToday ? .green : .gray)
                .font(.system(size: 16))
            
            Text(habit.name)
                .font(.system(size: 14, weight: .medium))
                .lineLimit(1)
            
            Spacer()
            
            HStack(spacing: 2) {
                ForEach(0..<7, id: \.self) { index in
                    RoundedRectangle(cornerRadius: 2)
                        .fill(habit.progress[index] ? Color.green : Color.gray.opacity(0.3))
                        .frame(width: 12, height: 12)
                }
            }
        }
        .widgetURL(URL(string: "habittracker://toggle?habitId=\(habit.id)"))
    }
}

@main
struct HabitWidget: Widget {
    let kind: String = "HabitWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            HabitWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Habit Tracker")
        .description("Track your daily habits")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

struct HabitWidget_Previews: PreviewProvider {
    static var previews: some View {
        HabitWidgetEntryView(entry: HabitEntry(date: Date(), habits: [
            HabitData(id: "1", name: "Morning Run", iconCode: 0xe566, streak: 5, completedToday: true, progress: [true, true, false, true, true, true, false]),
            HabitData(id: "2", name: "Read Book", iconCode: 0xe0bb, streak: 3, completedToday: false, progress: [true, true, false, true, false, true, false])
        ]))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}

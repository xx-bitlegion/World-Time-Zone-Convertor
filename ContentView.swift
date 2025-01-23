//
//  ContentView.swift
//  TimeZoneConverterApp
//
//  Created by srijan vikram on 1/23/25.
//


import SwiftUI

struct ContentView: View {
    @State private var selectedTimeZone = TimeZone.current
    @State private var selectedDate = Date()
    @State private var targetTimeZone = TimeZone.current
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Select Date and Time")) {
                    DatePicker("Date and Time", selection: $selectedDate)
                        .labelsHidden()
                        .datePickerStyle(GraphicalDatePickerStyle())
                }
                
                Section(header: Text("Select Time Zones")) {
                    Picker("From", selection: $selectedTimeZone) {
                        ForEach(TimeZone.knownTimeZoneIdentifiers, id: \.self) { id in
                            Text(TimeZone(identifier: id)?.identifier ?? id).tag(TimeZone(identifier: id)!)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    
                    Picker("To", selection: $targetTimeZone) {
                        ForEach(TimeZone.knownTimeZoneIdentifiers, id: \.self) { id in
                            Text(TimeZone(identifier: id)?.identifier ?? id).tag(TimeZone(identifier: id)!)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
                
                Section(header: Text("Converted Date and Time")) {
                    Text(convertedDateString)
                        .font(.headline)
                        .padding()
                }
            }
            .navigationBarTitle("Time Zone Converter")
        }
    }
    
    var convertedDateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = targetTimeZone
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .full
        return dateFormatter.string(from: convertDateToTarget())
    }
    
    func convertDateToTarget() -> Date {
        let sourceOffset = selectedTimeZone.secondsFromGMT(for: selectedDate)
        let targetOffset = targetTimeZone.secondsFromGMT(for: selectedDate)
        let timeInterval = TimeInterval(targetOffset - sourceOffset)
        return selectedDate.addingTimeInterval(timeInterval)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

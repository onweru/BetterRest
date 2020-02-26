//
//  ContentView.swift
//  BetterRest
//
//  Created by dan on 2/25/20.
//  Copyright © 2020 dan. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
  @State private var wakeUp = defaultWakeTime
  @State private var sleepAmount = 8.0
  @State private var coffeeAmount = 1
    
  static var defaultWakeTime: Date {
     var components = DateComponents()
     components.hour = 7
     components.minute = 0
     return Calendar.current.date(from: components) ?? Date()
  }
    
    
  var body: some View {
      NavigationView {
        Form {
            DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                .labelsHidden()
                .datePickerStyle(WheelDatePickerStyle())
          
            
            Section (header: Text("Desired amount of sleep")) {
                Stepper(value: $sleepAmount, in: 4...12, step: 0.25) {
                    Text("\(sleepAmount, specifier: "%g")")
                }

            }

            Section (header:                      Text("Daily coffee intake")) {
            Stepper(value: $coffeeAmount, in: 1...20) {
                Text("\(coffeeAmount) cup\( coffeeAmount == 1 ? "": "s")")
            }
            }
            
            Section (header: Text("Bedtime")) {
                Text("\(calculateBedtime())")
            }
        }
        .navigationBarTitle("BetterRest")
        }
      }
    
    func calculateBedtime() -> String {
        
        var message = ""
        
        let model = SleepCalculator()
        
      
        let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
        
        let hour = (components.hour ?? 0) * 60 * 60
        let minute = (components.minute ?? 0) * 60
        
        do {
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            
            let sleepTime = wakeUp - prediction.actualSleep
            
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            
            message = formatter.string(from: sleepTime)
        } catch {
            message = "Sorry, there was a problem calculating your bedtime."
        }
        
        return message
    }

  }


struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}

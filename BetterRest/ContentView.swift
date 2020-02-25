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
  
  @State private var alertTitle = ""
  @State private var alertMessage = ""
  @State private var showingAlert = false
    
    static var defaultWakeTime: Date {
     var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
  }
    
  func calculateBedtime() {
      let model = SleepCalculator()
    
      let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
      
      let hour = (components.hour ?? 0) * 60 * 60
      let minute = (components.minute ?? 0) * 60
      
      do {
          let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
          
          let sleepTime = wakeUp - prediction.actualSleep
          
          let formatter = DateFormatter()
          formatter.timeStyle = .short
          
          alertTitle = "Your ideal bedtime is ..."
          alertMessage = formatter.string(from: sleepTime)
      } catch {
          alertTitle = "Error"
          alertMessage = "Sorry, there was a problem calculating your bedtime."
      }
      
      showingAlert = true
  }
    
  var body: some View {
      NavigationView {
        Form {
            DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                .labelsHidden()
                .datePickerStyle(WheelDatePickerStyle())
          
            Text("Desired amount of sleep")
              .font(.headline)
          
          Stepper(value: $sleepAmount, in: 4...12, step: 0.25) {
              Text("\(sleepAmount, specifier: "%g")")
          }
           Text("Daily coffee intake")
                  .font(.headline)
              
            Stepper(value: $coffeeAmount, in: 1...20) {
                Text("\(coffeeAmount) cup\( coffeeAmount == 1 ? "": "s")")
            }
        }
        .navigationBarTitle("BetterRest")
          .navigationBarItems(trailing: Button(action: calculateBedtime) {
              Text("Calculate")
          })
              .alert(isPresented: $showingAlert) {
                  Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("Ok")))
          }
        }
      }
  }


struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}

//
//  ContentView.swift
//  asdf
//
//  Created by David Adler on 16/11/2021.
//

import SwiftUI


func convertFahrenheitToCelsius(_ temp: Double) -> Double {
    (temp - 32) * 5/9
}

func convertCelsiusToFahrenheit(_ temp: Double) -> Double {
    temp * 9/5 + 32;
}

enum Mode: String, CaseIterable {
    case Celcius = "Celcius"
    case Fahrenheit = "Fahrenheit"
}

func convert(temp: Double, mode: Mode) -> Double {
    switch (mode) {
    case .Celcius:
        return convertCelsiusToFahrenheit(temp)
    case .Fahrenheit:
        return convertFahrenheitToCelsius(temp)
    }
}



struct ContentView: View {
    @State private var input = 32.0
    @State private var mode: Mode = .Celcius
    @State private var output = convert(temp: 32, mode: .Celcius)
    @State private var outputMode: Mode = .Fahrenheit
    
    @FocusState private var isFocused: Bool
    
    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    
    
    var body: some View {
        let inputBinding = Binding<Double>(get: {
            self.input
        }, set: {
            self.input = $0
            self.output = convert(temp: $0, mode: self.mode)
        })
        
        let outputBinding = Binding<Double>(get: {
            self.output
        }, set: {
            self.output = $0
            self.input = convert(temp: $0, mode: self.outputMode)
        })
        
        let inputModeBinding = Binding<Mode>(get: {
            self.mode
        }, set: {
            self.mode = $0
            self.outputMode = $0 == .Celcius ? .Fahrenheit : .Celcius
            self.output = convert(temp: self.input, mode: self.mode)
        })
        
        let outputModeBinding = Binding<Mode>(get: {
            self.outputMode
        }, set: {
            self.outputMode = $0
            self.mode = $0 == .Celcius ? .Fahrenheit : .Celcius
            self.input = convert(temp: self.output, mode: self.outputMode)
        })
        
        NavigationView {
            Form {
                Picker("Input mode", selection: inputModeBinding) {
                    ForEach(Mode.allCases, id: \.self) {
                        Text("\($0.rawValue)")
                    }
                }.pickerStyle(.segmented)
                if #available(iOS 15.0, *) {
                    TextField(mode.rawValue, value: inputBinding, formatter: formatter).keyboardType(.decimalPad)
                } else {
                    Text("asdf")
                }
                
                Picker("Output mode", selection: outputModeBinding) {
                    ForEach(Mode.allCases, id: \.self) {
                        Text("\($0.rawValue)")
                    }
                }.pickerStyle(.segmented)
                if #available(iOS 15.0, *) {
                    TextField(outputMode.rawValue, value: outputBinding, formatter: formatter).keyboardType(.decimalPad)
                } else {
                    Text("asdf")
                }
            }.navigationTitle("Temperature converter").toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        isFocused = false
                    }
                }
            }
            
        }
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

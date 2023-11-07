//
//  DayStepsHystogram.swift
//  StepControl
//
//  Created by Мурат Кудухов on 13.10.2023.
//

import SwiftUI
import Charts

struct DayData: Identifiable, Equatable {
    let type: String
    let count: Int
    
    var id: String {return type}
}

struct DayStepsHystogram: View {
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    @State var array: [DayData]
    
    @State private var tapLocation: CGPoint? = nil
    
    @State private var selectedBar: DayData? = nil
    
    @State private var stepsCount = 0
    @State private var hour = ""
    
    @State var annotationOn = false
    
    var maxChartData: DayData? {
        array.max { $0.count < $1.count }
    }
    
    @available(iOS 16.0, *)
    var body: some View {
        Text("\(stepsCount) steps at \(hour)")
            .offset(x:16, y:8)
            .foregroundStyle(Color.white)
            .frame(maxWidth: .infinity, alignment: .leading)
        ZStack {
            Chart {
                ForEach(array) { dataPoint in
                    BarMark(x: .value("Date", dataPoint.type), y: .value("StepCount", dataPoint.count))
                    
                    //.foregroundStyle(maxChartData == dataPoint ? Color.orange : Color.orange)
                    //.foregroundStyle(Color(R.Colors.gray))
                        .foregroundStyle(selectedBar == dataPoint
                                         ? Color(R.Colors.orangeTwo)
                                         : (selectedBar != nil ? Color.gray : Color(R.Colors.orangeTwo)))
                    
                    
                    
                    
                        .annotation(position: .top) {
                            if selectedBar == dataPoint {
                                Text(String(dataPoint.count))
                                    .font(Font(R.Fonts.avenirBook(with: 14)))
                                
                            } else {
                                Text("")
                            }
                        }
                        .cornerRadius(3)
                    
                    
                }
            }
            
        }
        
        //.contentShape(Rectangle())
        .onTapGesture { gestureLocation in
            tapLocation = gestureLocation
        }
        .onChange(of: tapLocation) { location in
            if let tapLocation = location {
                handleTap(location: tapLocation)
                self.tapLocation = nil
            }
        }
        
        .chartXAxis(.hidden)
        .aspectRatio(2, contentMode: .fit)
        .padding()
        .frame(maxWidth: .infinity, maxHeight: 250) // Растягивает представление по всей ширинe
        .colorScheme(.dark)
        
    }
    
    func handleTap(location: CGPoint) {
        // Вычисляет индекс бара по координации X нажатия и ширине бара.
        // Учитывайте, что это простое вычисление и может потребовать тонкой настройки в зависимости от расстановки и размеров ваших баров.
        let barIndex = Int(Int(location.x) / (250 / array.count)) - 1
        if barIndex >= 0 && barIndex < array.count {
            selectedBar = array[barIndex]
            print("Вы выбрали бар: \(selectedBar?.type ?? "?")")
            self.stepsCount = selectedBar?.count ?? 0
            self.hour = selectedBar?.type ?? ""
            
        } else {
            selectedBar = nil
        }
    }
    
}

//#Preview {
//    SwiftUIArray()
//}




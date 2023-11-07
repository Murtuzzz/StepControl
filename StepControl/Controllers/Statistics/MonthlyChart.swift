//
//  MonthlyChart.swift
//  StepControl
//
//  Created by Мурат Кудухов on 09.10.2023.
//

import SwiftUI
import Charts

struct LineData: Identifiable, Equatable {
    let type: String
    let count: Int
    
    var id: String {return type}
}

struct MonthlyChart: View {
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @State var array: [LineData]
    
    @State private var tapLocation: CGPoint? = nil
    @State private var selectedBar: LineData? = nil

    var maxChartData: LineData? {
        array.max { $0.count < $1.count }
    }
    
    @available(iOS 16.0, *)
    var body: some View {
        Text("Last 9 month")
            .offset(x: 24)
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(Font(R.Fonts.avenirBook(with: 12)))
            .foregroundStyle(Color(R.Colors.gray))
        Chart {
            ForEach(array) { dataPoint in
               BarMark(x: .value("Date", dataPoint.type), y: .value("StepCount", dataPoint.count))
                    
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
                    
                    .cornerRadius(5)
            }
            
        }
        
        
        .onTapGesture { gestureLocation in
            tapLocation = gestureLocation
            
                
        }
        .onChange(of: tapLocation) { location in
            if let tapLocation = location {
                handleTap(location: tapLocation)
                self.tapLocation = nil
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .frame(maxWidth: .infinity, maxHeight: 300)
        .colorScheme(.dark)
    }
    
    func handleTap(location: CGPoint) {
        // Вычисляет индекс бара по координации X нажатия и ширине бара.
        // Учитывайте, что это простое вычисление и может потребовать тонкой настройки в зависимости от расстановки и размеров ваших баров.
        var barIndex = 0
        if location.x < 79 {
            barIndex = Int(Int(location.x) / (300 / array.count))
        } else {
            barIndex = Int(Int(location.x) / (300 / array.count)) + 1
        }
        if barIndex >= 0 && barIndex < array.count {
            selectedBar = array[barIndex]
            print("Вы выбрали бар: \(selectedBar?.type) bar index = \(barIndex)")
            
        } else {
            selectedBar = nil
        }
    }
}

//#Preview {
//    SwiftUIArray()
//}



//
//  DailyHystogram.swift
//  StepControl
//
//  Created by Мурат Кудухов on 09.10.2023.
//

import SwiftUI
import Charts

struct ChartData: Identifiable, Equatable {
    let type: String
    let count: Int
    
    var id: String {return type}
}

struct DailyHystogram: View {
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    @State var array: [ChartData]

    
    var maxChartData: ChartData? {
        array.max { $0.count < $1.count }
    }
    
    @available(iOS 16.0, *)
    var body: some View {

        Chart {
            
            ForEach(array) { dataPoint in
               BarMark(x: .value("Date", dataPoint.type), y: .value("StepCount", dataPoint.count))
                    
                    //.foregroundStyle(maxChartData == dataPoint ? Color.orange : Color.orange)
                    .foregroundStyle(Color(R.Colors.orangeTwo))
                    .annotation(position: .top) {
                        Text(String(dataPoint.count))
                            .font(Font(R.Fonts.avenirBook(with: 14)))
                    }
                    .cornerRadius(3)

            }
        }
        
        .aspectRatio(1, contentMode: .fit)
        //.padding()
        .frame(maxWidth: .infinity, maxHeight: 300) // Растягивает представление по всей ширине
        .colorScheme(.dark)

        
        
    }
}

//#Preview {
//    SwiftUIArray()
//}


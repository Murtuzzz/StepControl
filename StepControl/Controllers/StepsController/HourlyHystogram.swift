//
//  HourlyHystogram.swift
//  StepControl
//
//  Created by Мурат Кудухов on 10.10.2023.
//


import SwiftUI
import Charts

struct HourData: Identifiable, Equatable {
    let type: String
    let count: Int
    
    var id: String {return type}
}

struct HourlyHystogram: View {
    
    @State var getArray: [HourData]
    
    var array: [HourData] {
        if getArray.count == 0 {
            return  [.init(type: "", count: 0),
                     .init(type: "", count: 0),
                     .init(type: "", count: 0),
                     .init(type: "", count: 0),
                     .init(type: "", count: 0),
                     .init(type: "", count: 0),
                     .init(type: "", count: 0),
                     .init(type: "", count: 0)]
        } else {
            return getArray
        }
        
    }
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme

    var maxChartData: HourData? {
        array.max { $0.count < $1.count }
    }
    
    @available(iOS 16.0, *)
    var body: some View {
        Text("Last 8 hours")
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(Font(R.Fonts.avenirBook(with: 12)))
            .foregroundStyle(Color(R.Colors.gray))
        Chart {
            
            ForEach(array) { dataPoint in
                BarMark(x: .value("Date", dataPoint.type), y: .value("StepCount", dataPoint.count))
                
                    .foregroundStyle(Color(R.Colors.orangeTwo))
                    .annotation(position: .top) {
                        Text(String(dataPoint.count))
                            .font(Font(R.Fonts.avenirBook(with: 14)))
                    }
                    .cornerRadius(3)
                
            }
        }
        
        .aspectRatio(2, contentMode: .fit)
        .offset(y: -10)
        .frame(maxWidth: .infinity, maxHeight: 300)
        .colorScheme(.dark)
        
    }
}

//#Preview {
//    SwiftUIArray()
//}




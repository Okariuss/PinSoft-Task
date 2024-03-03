//
//  String+Ext.swift
//  PinSoft-Task
//
//  Created by Okan Orkun on 3.03.2024.
//

import Foundation

extension String {
    func formattedDate() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        guard let date = dateFormatter.date(from: self) else {
            return nil
        }
        
        dateFormatter.dateFormat = "dd MMMM yyyy"
        return dateFormatter.string(from: date)
    }
}

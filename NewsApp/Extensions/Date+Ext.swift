//
//  Date+Ext.swift
//  NewsApp
//
//  Created by Karolina Sulik on 26.03.22.
//

import Foundation


extension Date {
    func getStringRepresentation() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd. MMM yyyy - HH:mm"
        
        return dateFormatter.string(from: self)
    }
}

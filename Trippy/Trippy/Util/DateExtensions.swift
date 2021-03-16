import Foundation

extension Date {
    var dateStringFromDate: String {
        DateManager.shared.stringFromDate(date: self, withFormat: "d MMM")
    }
    
    var dateTimeStringFromDate: String {
        DateManager.shared.stringFromDate(date: self, withFormat: "d MMM hh:mm a")
    }
    
    func stringFromDateWithFormat(format: String) -> String {
        DateManager.shared.stringFromDate(date: self, withFormat: format)
    }
}

import Foundation

extension Date {
    var dateStringFromDate: String {
        DateManager.shared.stringFromDate(date: self, withFormat: "d MMM")
    }

    var dateTimeStringFromDate: String {
        DateManager.shared.stringFromDate(date: self, withFormat: "d MMM h:mm a")
    }

    func stringFromDateWithFormat(format: String) -> String {
        DateManager.shared.stringFromDate(date: self, withFormat: format)
    }
}

import Foundation

extension String {

    var dateFromDateString: Date? {
        DateManager.shared.dateFromString(dateString: self, withFormat: "yyyy-MM-dd")
    }

    var dateFromDateTimeString: Date? {
        DateManager.shared.dateFromString(dateString: self, withFormat: "yyyy-MM-dd hh:mm a")
    }

    func dateFromStringWithFormat(withFormat strDate: String) -> Date? {
        DateManager.shared.dateFromString(dateString: self, withFormat: strDate)
    }
}

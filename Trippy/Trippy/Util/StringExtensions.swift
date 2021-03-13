import Foundation

extension String {
    
    var dateFromDateString: Date? {
        return DateManager.shared.dateFromString(dateString: self, withFormat: "yyyy-MM-dd")
    }
    
    var dateFromDateTimeString: Date? {
        return DateManager.shared.dateFromString(dateString: self, withFormat: "yyyy-MM-dd hh:mm a")
    }
    
    func dateFromStringWithFormat(withFormat strDate: String) -> Date? {
        return DateManager.shared.dateFromString(dateString: self, withFormat: strDate)
    }
}

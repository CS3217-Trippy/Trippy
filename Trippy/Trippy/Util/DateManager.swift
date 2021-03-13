import Foundation

class DateManager {
    
    static let shared = DateManager()
    private init() {}
    
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        return dateFormatter
    }()
    
    func dateFromString(dateString: String, withFormat format: String?) -> Date? {
        dateFormatter.dateFormat = format
        if let date = dateFormatter.date(from: dateString) {
            return date
        } else {
            return nil
        }
    }
    
    func stringFromDate(date: Date, withStyle dateStyle: DateFormatter.Style) -> String {
        dateFormatter.dateStyle = dateStyle
        let dateStr = dateFormatter.string(from: date)
        return dateStr
    }
    
    func stringFromDate(date: Date, withFormat format: String) -> String {
        dateFormatter.dateFormat = format
        let dateStr = dateFormatter.string(from: date)
        return dateStr
    }
    
}

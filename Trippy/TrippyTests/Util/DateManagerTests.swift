import XCTest
@testable import Trippy
class DateManagerTests: XCTestCase {
    var date: Date?
    var manager = DateManager.shared

    override func setUp() {
        super.setUp()
        var dateComponents = DateComponents()
        dateComponents.day = 25
        dateComponents.month = 12
        dateComponents.year = 2_020
        dateComponents.hour = 15
        dateComponents.minute = 30
        date = Calendar(identifier: Calendar.Identifier.gregorian).date(from: dateComponents)
    }

    func testStringFromDate() {
        guard let dateOpt = date else {
            fatalError("date should be found")
        }
        XCTAssertEqual(manager.stringFromDate(date: dateOpt, withStyle: .full), "Friday, December 25, 2020")
    }

    func testFormatDatewithformat() {
        guard let dateOpt = date else {
            fatalError("date should be found")
        }
        XCTAssertEqual(manager.stringFromDate(date: dateOpt, withFormat: "yyyy-MM-dd"), "2020-12-25")
        XCTAssertEqual(manager.stringFromDate(date: dateOpt, withFormat: "yyyy-MM-dd HH:mm"), "2020-12-25 15:30")
    }

    func testFormatDateFromString() {
        guard let dateOpt = date else {
            fatalError("date should be found")
        }
        XCTAssertEqual(manager.dateFromString(dateString: "2020-12-25 15:30", withFormat: "yyyy-MM-dd HH:mm"), dateOpt)
    }
}

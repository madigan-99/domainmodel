import XCTest
@testable import DomainModel

class ExtraCreditTests: XCTestCase {
  
    
    let first = Money(amount: 100, currency: "USD")
    let second = Money(amount: 1, currency: "USD")
    let seventh = Money(amount: 43, currency: "GBP")
    let eigth = Money(amount: 1, currency: "GBP")
    let nineBad = Money(amount: 35, currency: "Fake")
    let tenBad = Money(amount: -1000, currency: "CAD")
    
    func testAddUSDtoUSD() {
      let total = first.add(second)
      XCTAssert(total.amount == 101)
      XCTAssert(total.currency == "USD")
    }
    
    func testSubGBPtoGBP() {
      let total = eigth.subtract(seventh)
      XCTAssert(total.amount == 42)
      XCTAssert(total.currency == "GBP")
    }
    
    func testBadConvert() {
        let conv = nineBad.convert("USD")
        XCTAssert(conv.amount == 0)
        XCTAssert(conv.currency == "USD")
    }
    
    func testBadAmt() {
        XCTAssert(tenBad.amount == 0)
        XCTAssert(tenBad.currency == "USD")
    }
    
    func testCreateSalaryJob2() {
        let job = Job(title: "Guest Lecturer", type: Job.JobType.Salary(5000))
        XCTAssert(job.calculateIncome(50) == 5000)
        XCTAssert(job.calculateIncome(100) == 5000)
        // Salary jobs pay the same no matter how many hours you work
    }

    func testTitleOfJob() {
        let job = Job(title: "SUB Initative Designer", type: Job.JobType.Hourly(2))
        XCTAssert(job.title == "SUB Initative Designer")
    }
    
    func testCreateHourlyJob2() {
        let job = Job(title: "Janitor", type: Job.JobType.Hourly(100.0))
        XCTAssert(job.calculateIncome(1) == 100)
        XCTAssert(job.calculateIncome(1000) == 100000)
    }

    func testSalariedRaise2() {
        let job = Job(title: "Guest Lecturer", type: Job.JobType.Salary(500))
        XCTAssert(job.calculateIncome(0) == 500)

        job.raise(byAmount: 1000)
        XCTAssert(job.calculateIncome(0) == 1500)

        job.raise(byPercent: 1)
        XCTAssert(job.calculateIncome(0) == 3000)
        
        job.raise(byAmount: 500.50)
        XCTAssert(job.calculateIncome(0) == 3500)
    }
    
    func testPerson() {
        let ted = Person(firstName: "Ted", lastName: "Neward", age: 45)
        XCTAssert(ted.toString() == "[Person: firstName:Ted lastName:Neward age:45 job:nil spouse:nil]")
    }
    
    static var allTests = [
        ("testAddUSDtoUSD", testAddUSDtoUSD),
        ("testSubGBPtoGBP", testSubGBPtoGBP),
        ("testBadConvert", testBadConvert),
        ("testBadAmt", testBadAmt),
        ("testCreateSalaryJob2", testCreateSalaryJob2),
        ("testTitleOfJob", testTitleOfJob),
        ("testCreateHourlyJob2", testCreateHourlyJob2),
        ("testSalariedRaise2", testSalariedRaise2)
    ]
}

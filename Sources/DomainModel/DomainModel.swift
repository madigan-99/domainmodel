import Foundation

struct DomainModel {
    var text = "Hello, World!"
        // Leave this here; this value is also tested in the tests,
        // and serves to make sure that everything is working correctly
        // in the testing harness and framework.
}

////////////////////////////////////
// Money
//
public struct Money {
    var amount: Int
    var currency: String
    
    private let currencyConverter: Dictionary<String, Double> = ["USD" : 1.00, "GBP": 0.5, "EUR": 1.5, "CAN": 1.25]
    
    
    init(amount amt: Int, currency curr: String) {
        if (currencyConverter[curr] != nil && amt >= 0) {
            amount = amt
            currency = curr
        } else {
            amount = 0
            currency = "USD"
        }
    }
    
    
    func convert(_ currencyType: String) -> Money {
        var selfAmount: Double = Double(self.amount);
        let conversionA: Double = currencyConverter[currencyType]!
        let conversionB: Double = currencyConverter[self.currency]!
        let tempToUSD = selfAmount / conversionB;
        selfAmount =  (tempToUSD * conversionA );
        let result = Money(amount: Int(selfAmount), currency: currencyType);
        return result
        
    }
    
    func add(_ mon: Money) -> Money {
        let temp = self.convert(mon.currency)
        let res = Money(amount: temp.amount + mon.amount, currency: mon.currency)
        return res;
    }
    
    func subtract(_ mon: Money) -> Money {
        let temp = self.convert(mon.currency);
        return Money(amount: mon.amount - temp.amount, currency: mon.currency);
    }
}

////////////////////////////////////
// Job
//
public class Job {
    public enum JobType {
        case Hourly(Double)
        case Salary(UInt)
    }
    var title: String
    var type: JobType
    
    init(title t: String, type jt: JobType) {
        title = t
        type = jt
    }
    
    func calculateIncome(_ hours: Int) -> Int {
        switch self.type {
        case .Hourly(let wage):
            return Int(wage * Double(hours))
        case .Salary(let salary):
            return Int(salary)
        }
    }
    
    func raise(byPercent p: Double) {
        switch self.type {
        case .Hourly(let wage):
            self.type = JobType.Hourly((1+p) * wage)
        case .Salary(let salary):
            self.type = JobType.Salary(salary + UInt(Double(salary) * p))
        }
    }
    func raise(byAmount a: Double) {
        switch self.type {
        case .Hourly(let wage):
            self.type = JobType.Hourly(wage + a)
        case .Salary(let salary):
            self.type = JobType.Salary(UInt(a) + salary)
        }
    }
    func raise(byAmount a: Int) {
        switch self.type {
        case .Hourly(let wage):
            self.type = JobType.Hourly(wage + Double(a))
        case .Salary(let salary):
            self.type = JobType.Salary(salary + UInt(a))
        }
    }

}

////////////////////////////////////
// Person
//
public class Person {
    var firstName: String
    var lastName: String
    var age: Int
    var job: Job? {
        didSet {
            if age < 16 {
                job = nil
            }
        }
    }
    var spouse: Person? {
        didSet {
            if age < 16 {
                spouse = nil
            }
        }
    }
    
    init(firstName fn: String, lastName ln: String, age a: Int) {
        firstName = fn
        lastName = ln
        age = a
    }
    
  

    func toString() -> String{
        return "[Person: firstName:\(self.firstName) lastName:\(self.lastName) age:\(self.age) job:\(self.job) spouse:\(self.spouse)]"
    
    }
    
}

////////////////////////////////////
// Family
//
public class Family {
    var members: [Person] = []
    init (spouse1: Person, spouse2: Person) {
        if (spouse1.spouse != nil || spouse2.spouse != nil) {
            self.members = []
            return
        }
        spouse1.spouse = spouse2
        spouse2.spouse = spouse1
        self.members.append(spouse1)
        self.members.append(spouse2)
    }
    
    func haveChild(_ child: Person) {
        if (self.members[0].age > 21 && self.members[1].age > 21) {
            members.append(child)
        }
        return
    }
    func householdIncome() -> Int {
        var res: Int = 0
        for x in self.members {
            if (x.job != nil) {
                res += x.job!.calculateIncome(2000)
            }
        }
        return res
    }
}

import Foundation

open class RegexRule: IRule {
	private var regex: String
	private var message: String
	
	public init(regex: String, message: String = "Invalid Expression") {
		self.regex = regex
		self.message = message
	}
	
	public func validate(_ value: String) -> Bool {
		let test = NSPredicate(format: "SELF MATCHES %@", self.regex)
		return test.evaluate(with: value)
	}
	
	public func errorMessage() -> String {
		return message
	}
}

import Foundation

open class EquatableRule: IRule {
	private var message: String
	private var string: String
	
	public init(string: String, message: String) {
		self.string = string
		self.message = message
	}
	
	public func validate(_ value: String) -> Bool {
		return value == string
	}
	
	public func errorMessage() -> String {
		return message
	}
}

import Foundation

open class RequiredRule: IRule {
	private var message: String
	
	public init(message: String) {
		self.message = message
	}
	
	public func validate(_ value: String) -> Bool {
		return !value.isEmpty
	}
	
	public func errorMessage() -> String {
		return message
	}
}

import Foundation

public protocol IValidator {
	func validateValue(_ value: String, rules: [IRule]) -> String?
}

open class Validator: IValidator {
	
	public init() {}
	
	public func validateValue(_ value: String, rules: [IRule]) -> String? {
		for rule in rules {
			if !rule.validate(value) {
				return rule.errorMessage()
			}
		}
		return nil
	}
}

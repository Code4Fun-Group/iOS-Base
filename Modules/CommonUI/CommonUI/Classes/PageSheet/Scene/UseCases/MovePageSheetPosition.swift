import Foundation

public enum MovePageSheetPosition {
	public struct Request {
		public let position: PageSheetPosition
		
		public init(position: PageSheetPosition) {
			self.position = position
		}
	}
	
	public struct Response {
		public let position: PageSheetPosition
		
		public init(position: PageSheetPosition) {
			self.position = position
		}
	}
	
	public struct ViewModel {
		public let position: PageSheetPosition
		
		public init(position: PageSheetPosition) {
			self.position = position
		}
	}
}

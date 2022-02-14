import Foundation

private enum Constants {
	static let defaultBackgroupAlpha: CGFloat = 0.7
	static let defaultGrabberAreaOffset: CGFloat = 36
	static let defaultCornerRadius: CGFloat = 20
}

public enum PageSheetStyle {
	case modal
	case alert
	case embedded
	case dialogue
	case dismissableModal
}

// MARK: - IPageSheetAppearance
extension PageSheetStyle: IPageSheetAppearance {
	
	public var backdropAlpha: CGFloat {
		switch self {
		case .modal: return Constants.defaultBackgroupAlpha
		case .alert: return Constants.defaultBackgroupAlpha
		case .embedded: return 0
		case .dialogue: return Constants.defaultBackgroupAlpha
		case .dismissableModal: return Constants.defaultBackgroupAlpha
		}
	}
	
	public var backdropColor: UIColor {
		commonUIConfig.colorSet.neutral600
	}
	
	public var dismissTapGestureEnabled: Bool {
		switch self {
		case .modal: return true
		case .alert: return true
		case .embedded: return false
		case .dialogue: return true
		case .dismissableModal: return true
		}
	}
	
	public var surfaceBackgroundColor: UIColor {
		UIColor.clear
	}
	
	public var surfaceCornerRadius: CGFloat {
		Constants.defaultCornerRadius
	}
	
	public var grabberAreaOffset: CGFloat {
		switch self {
		case .modal: return Constants.defaultGrabberAreaOffset
		case .alert: return 0
		case .embedded: return Constants.defaultGrabberAreaOffset
		case .dialogue: return 0
		case .dismissableModal: return Constants.defaultGrabberAreaOffset
		}
	}
	
	public var panGestureRecognizerEnabled: Bool {
		switch self {
		case .modal: return false
		case .alert: return false
		case .embedded: return false
		case .dialogue: return false
		case .dismissableModal: return false
		}
	}
}

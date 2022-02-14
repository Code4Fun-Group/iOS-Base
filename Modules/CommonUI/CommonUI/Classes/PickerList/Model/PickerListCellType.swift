import Foundation

public enum PickerListCellType: String {
	case picker
	case radio
	case imageRadio
	
	var cellIdentifier: String {
		switch self {
		case .picker:
			return "PickerListRadioViewCell"
		case .radio:
			return "PickerListRadioViewCell"
		case .imageRadio:
			return "PickerListImageRadioViewCell"
		}
	}
}

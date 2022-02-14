//
//  UIImageExtension.swift
//  CommonUI
//
//  Created by NamNH on 09/12/2021.
//

import UIKit

public extension UIImage {
	// MARK: - Barcode
	static func generateBarcode(from string: String) -> UIImage {
		guard let data = string.data(using: String.Encoding.ascii) else {
			return UIImage()
		}
		
		guard let filter = CIFilter(name: "CICode128BarcodeGenerator") else {
			return UIImage()
		}
		
		filter.setValue(data, forKey: "inputMessage")
		
		let transform = CGAffineTransform(scaleX: 3, y: 3)
		
		guard let outputBarcode = filter.outputImage?.transformed(by: transform) else {
			return UIImage()
		}
		
		let colorParameters = [
			"inputColor0": CIColor(color: UIColor.black),
			"inputColor1": CIColor(color: UIColor.clear)
		]
		
		let barCodeImage = outputBarcode.applyingFilter("CIFalseColor", parameters: colorParameters)
		
		return UIImage(ciImage: barCodeImage)
	}
	
	// MARK: - QRCode
	static func generateQRcode(from string: String, color: UIColor = UIColor.black) -> UIImage? {
		guard let data = string.data(using: String.Encoding.ascii) else {
			return nil
		}
		
		guard let filter = CIFilter(name: "CIQRCodeGenerator") else {
			return nil
		}
		
		filter.setValue(data, forKey: "inputMessage")
		filter.setValue("H", forKey: "inputCorrectionLevel")
		
		let transform = CGAffineTransform(scaleX: 10, y: 10)
		
		guard let outputQRcode = filter.outputImage?.transformed(by: transform) else {
			return nil
		}
		
		let colorParameters = [
			"inputColor0": CIColor(color: color),
			"inputColor1": CIColor(color: UIColor.clear)
		]
		
		let qrCodeImage = outputQRcode.applyingFilter("CIFalseColor", parameters: colorParameters)
		let finalImage = UIImage(ciImage: qrCodeImage)
		
		return finalImage
	}
}


import UIKit

extension UIColor {
    public convenience init(hexString: String) {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 1
        
        let hexColor = hexString.replacingOccurrences(of: "#", with: "")
        let scanner = Scanner(string: hexColor)
        var hexNumber: UInt64 = 0
        
        guard scanner.scanHexInt64(&hexNumber) else {
            self.init(red: r, green: g, blue: b, alpha: a)
            return
        }

        switch hexColor.count {
        case 8:
            r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
            g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
            b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
            a = CGFloat(hexNumber & 0x000000ff) / 255
            
        case 6:
            r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
            g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
            b = CGFloat(hexNumber & 0x0000ff) / 255
            
        case 3:
            r = CGFloat((hexNumber & 0xf00) >> 8) / 15
            g = CGFloat((hexNumber & 0x0f0) >> 4) / 15
            b = CGFloat(hexNumber & 0x00f) / 15
            
        default:
            break
        }
        
        self.init(red: r, green: g, blue: b, alpha: a)
    }
}

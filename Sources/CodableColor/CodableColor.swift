import Foundation

// Credits to
// https://www.rapidtables.com/convert/color/rgb-to-hex.html
// https://gist.github.com/mjackson/5311256
// https://en.wikipedia.org/wiki/HSL_and_HSV#:~:text=HSL%20stands%20for%20hue%2C%20saturation,hue%2C%20saturation%2C%20and%20intensity.

// CodableColor provides a platform independent color object that can be easily serialized and deserialized whilst also providing equivalent functions and functionality to UIColor
public struct CodableColor {
    public let hexString: String
    public let red: CGFloat
    public let green: CGFloat
    public let blue: CGFloat
    public let alpha: CGFloat
    
    // Initialise from a
    public init(_ hexString: String) {
        self.hexString = CodableColor.correctHexColor(hexString)
        (red, green, blue, alpha) = CodableColor.hexToRGB(hexString)
    }
    
    // Simplistic `luminance` calculation that can be used to suggest whether you should put `black` or `white` text on a particular `background color`
    public var luminance: CGFloat {
        let (red, green, blue, _) = rgba
        return (0.2126 * red) + (0.7152 * green) + (0.0722 * blue)
    }
    
    // This color `is light` and you would likely have better `accessible contrast` if you put `dark text` on top of this color
    public var isLight: Bool {
        luminance >= 0.6
    }

    // Return the `red`, `green`, `blue`, `alpha` components of this color
    public var rgb: (red: CGFloat, green: CGFloat, blue: CGFloat) {
        (red, green, blue)
    }

    // Return the `red`, `green`, `blue`, `alpha` components of this color
    public var rgba: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        (red, green, blue, alpha)
    }
    
    // Return the `hue`, `saturation`, `lightness` of this color
    public var hsl: (hue: CGFloat, saturation: CGFloat, lightness: CGFloat) {
        let (h, s, l, _) = CodableColor.rgbToHSL(red: red, green: green, blue: blue, alpha: alpha)
        return (h, s, l)
    }
    
    // Return the `hue`, `saturation`, `lightness`, `alpha` of this color
    public var hsla: (hue: CGFloat, saturation: CGFloat, lightness: CGFloat, alpha: CGFloat) {
        return CodableColor.rgbToHSL(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    // Return the `hue`, `saturation`, `brightness` of this color
    public var hsb: (hue: CGFloat, saturation: CGFloat, brightness: CGFloat) {
        let (h, s, b, _) = CodableColor.rgbToHSB(red: red, green: green, blue: blue, alpha: alpha)
        return (h, s, b)
    }
    
    // Return the `hue`, `saturation`, `brightness`, `alpha` of this color
    public var hsba: (hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat) {
        let (red, green, blue, alpha) = rgba
        return CodableColor.rgbToHSB(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    /// Amends a the colors lightness value to return a lighter/ darker version of the color
    ///
    /// - Parameter value: A multiplier of the existing colors lightness values
    ///       <1 will make a darker color
    ///       >1 will make a lighter color
    /// - Returns: a CodableColor with the new lightness
    public func applying(lightness value: CGFloat) -> CodableColor {
        var (hue, saturation, lightness, alpha) = hsla
        lightness *= value
        let offset = saturation * (lightness < 0.5 ? lightness : 1 - lightness)
        let brightness = lightness + offset
        saturation = lightness > 0 ? 2 * offset / brightness : 0
        
        let (r, g, b, a) = CodableColor.hsbToRGB(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
        var hexString: String = ""
        if alpha == 1 {
            hexString = CodableColor.rgbToHex(red: r, green: g, blue: b)
        } else {
            hexString = CodableColor.rgbToHex(red: r, green: g, blue: b, alpha: a)
        }
        
        return CodableColor(hexString)

    }
}

extension CodableColor: CustomStringConvertible {
    public var description: String {
        hexString
    }
}

extension CodableColor: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let string = try container.decode(String.self)
        self.hexString = CodableColor.correctHexColor(string)
        (red, green, blue, alpha) = CodableColor.hexToRGB(hexString)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(hexString.description)
    }
}

public extension CodableColor {
    // Convert an RGB color to a Hex string
    static func rgbToHex(red: CGFloat, green: CGFloat, blue: CGFloat) -> String {
        let r = String(format: "%02X", Int(255 * red)) //String(Int(255 * red), radix: 16, uppercase: true)
        let g = String(format: "%02X", Int(255 * green)) //String(Int(255 * green), radix: 16, uppercase: true)
        let b = String(format: "%02X", Int(255 * blue)) //String(Int(255 * blue), radix: 16, uppercase: true)
        return "#\(r)\(g)\(b)".uppercased()
    }
    
    // Convert an RGBA color to a Hex string
    static func rgbToHex(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> String {
        let r = String(format: "%02X", Int(255 * red)) //String(Int(255 * red), radix: 16, uppercase: true)
        let g = String(format: "%02X", Int(255 * green)) //String(Int(255 * green), radix: 16, uppercase: true)
        let b = String(format: "%02X", Int(255 * blue)) //String(Int(255 * blue), radix: 16, uppercase: true)
        let a = String(format: "%02X", Int(255 * alpha)) //String(Int(255 * alpha), radix: 16, uppercase: true)
        return "#\(r)\(g)\(b)\(a)".uppercased()
    }
    
    // Convert HSLA to RGBA
    static func hslToRGB(hue h: CGFloat, saturation s: CGFloat, lightness l: CGFloat, alpha: CGFloat = 1) -> (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        
        func hue2rgb(_ p: CGFloat, _ q: CGFloat, _ t: CGFloat) -> CGFloat {
            var t = t
            if t < 0 { t += 1 }
            if t > 1 { t -= 1 }
            if t < 1/6 { return p + (q - p) * 6 * t }
            if t < 1/2 { return q }
            if t < 2/3 { return p + (q - p) * (2/3 - t) * 6 }
            return p
        }

        let q = l < 0.5 ? l * (1 + s) : l + s - l * s
        let p = 2 * l - q
        
        let r = hue2rgb(p, q, h + 1/3)
        let g = hue2rgb(p, q, h)
        let b = hue2rgb(p, q, h - 1/3)
        
        return (r, g, b, alpha)
    }

    // Convert HSLA to HSBA
    static func hslToHSB(hue: CGFloat, saturation: CGFloat, lightness: CGFloat, alpha: CGFloat = 1) -> (hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat) {
        let (r, g, b, a) = hslToRGB(hue: hue, saturation: saturation, lightness: lightness, alpha: alpha)
        return rgbToHSB(red: r, green: g, blue: b, alpha: a)
    }
    
    private static func hueComponents(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> (hue: CGFloat, maxV: CGFloat, minV: CGFloat, delta: CGFloat) {
        let maxV: CGFloat = max(red, green, blue)
        let minV: CGFloat = min(red, green, blue)
        let delta: CGFloat = maxV - minV
        var hue: CGFloat = 0
        if delta != 0 {
            switch maxV {
                case red: hue = (green - blue) / delta + (green < blue ? 6 : 0)
                case green: hue = (blue - red) / delta + 2
                case blue: hue = (red - green) / delta + 4
                default: break
            }
            
            hue /= 6
        }
        return (hue, maxV, minV, delta)
    }
    
    // Convert RGBA to HSLA
    static func rgbToHSL(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> (hue: CGFloat, saturation: CGFloat, lightness: CGFloat, alpha: CGFloat) {
        let (hue, maxV, minV, delta) = hueComponents(red: red, green: green, blue: blue, alpha: alpha)
        let lightness: CGFloat = (maxV + minV) / 2
        let saturation: CGFloat = delta == 0 ? 0 : lightness > 0.5 ? delta / (2 - maxV - minV) : delta / (maxV + minV)
        return (hue, saturation, lightness, alpha)
    }
    
    // Convert RGBA to HSBA
    static func rgbToHSB(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> (hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat) {
        let (hue, maxV, _, delta) = hueComponents(red: red, green: green, blue: blue, alpha: alpha)
        let saturation = maxV == 0 ? 0 : (delta / maxV)
        let brightness = maxV
        return (hue, saturation, brightness, alpha)
    }
    
    // Convert HSBA to RGBA
    static func hsbToRGB(hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat) -> (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        
        let i = floor(hue * 6)
        let f = hue * 6 - i
        let p = brightness * (1 - saturation)
        let q = brightness * (1 - f * saturation)
        let t = brightness * (1 - (1 - f) * saturation)
        
        switch i.truncatingRemainder(dividingBy: 6) {
            case 0:
                red = brightness
                green = t
                blue = p
            case 1:
                red = q
                green = brightness
                blue = p
            case 2:
                red = p
                green = brightness
                blue = t
            case 3:
                red = p
                green = q
                blue = brightness
            case 4:
                red = t
                green = p
                blue = brightness
            case 5:
                red = brightness
                green = p
                blue = q
            default:
                break
        }
        
        return (red, green, blue, alpha)
    }
    
    // Convert Hex string to RGBA, returns `black` is color was invalid / could not be parsed correctly
    static func hexToRGB(_ value: String) -> (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 1
        var cString: String = value.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        cString = cString.replacingOccurrences(of: "#", with: "")

        var rgbValue: UInt64 = 0
        guard Scanner(string: cString).scanHexInt64(&rgbValue) else {
            return (r,g,b,a)
        }
        
        switch cString.count {
            case 8:
                r = CGFloat((rgbValue & 0xff000000) >> 24) / 255
                g = CGFloat((rgbValue & 0x00ff0000) >> 16) / 255
                b = CGFloat((rgbValue & 0x0000ff00) >> 8) / 255
                a = CGFloat(rgbValue & 0x000000ff) / 255
                
            case 6:
                r = CGFloat((rgbValue & 0xff0000) >> 16) / 255
                g = CGFloat((rgbValue & 0x00ff00) >> 8) / 255
                b = CGFloat(rgbValue & 0x0000ff) / 255
                
            case 3:
                r = CGFloat((rgbValue & 0xf00) >> 8) / 15
                g = CGFloat((rgbValue & 0x0f0) >> 4) / 15
                b = CGFloat(rgbValue & 0x00f) / 15
                
            default:
                break
        }
        
        return (r,g,b,a)
    }
}

private extension CodableColor {
    static func correctHexColor(_ value: String) -> String {
        var value = value
        if !value.hasPrefix("#") {
            value = "#" + value
        }
//        if ![4, 7, 9].contains(value.count) {
//            struct InvalidHexColor: Error {}
//            throw InvalidHexColor()
//        }
        return value
    }
}

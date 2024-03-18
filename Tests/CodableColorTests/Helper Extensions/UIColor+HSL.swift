
import UIKit

/// see http://colorizer.org/ for an indication of how the different colour spaces act
/// from https://stackoverflow.com/questions/30011208/return-lighter-color-from-skcolor-using-hsl-lightness-factor
extension UIColor {
    
    /// Creates a UIColor from HSL color space
    ///
    /// - Parameters:
    ///   - hue: The hue indicates the shade eg. red, blue, green
    ///   - saturation: The amount of saturation between 0-1 where 1 is a bright colour and 0 is grayscale
    ///   - lightness: The lightness/ brightness of the colour between 0-1 where 0 is black and 1 is white
    ///   - alpha: The transparancey of the colour where 1 is opaque and 0 is completly clear (invisible)
    public convenience init(hue: CGFloat, saturation: CGFloat, lightness: CGFloat, alpha: CGFloat = 1) {

        let offset = saturation * (lightness < 0.5 ? lightness : 1 - lightness)
        let brightness = lightness + offset
        let saturation = lightness > 0 ? 2 * offset / brightness : 0

        self.init(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
    }
    
    /// Returns a value on a UIColor that has its hue saturation and lightness using the HSL color space
    public var hsl: (hue: CGFloat, saturation: CGFloat, lightness: CGFloat, alpha: CGFloat)? {

        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        var hue: CGFloat = 0

        guard
            getRed(&red, green: &green, blue: &blue, alpha: &alpha),
            getHue(&hue, saturation: nil, brightness: nil, alpha: nil)
        else {
            return nil
        }

        let upper = max(red, green, blue)
        let lower = min(red, green, blue)
        let range = upper - lower
        let lightness = (upper + lower) / 2
        let saturation = range == 0 ? 0 : range / (lightness < 0.5 ? lightness * 2 : 2 - lightness * 2)

        return (hue, saturation, lightness, alpha)
    }
    
    /// Amends a UIColor's lightness value to return a lighter/ darker version of the color
    ///
    /// - Parameter value: A multiplier of the existing colors lightness values
    ///       <1 will make a darker color
    ///       >1 will make a lighter color
    /// - Returns: a UIColor with the new lightness
    public func applying(lightness value: CGFloat) -> UIColor {
        
        guard let hsl = hsl else { return self }
        return UIColor(hue: hsl.hue, saturation: hsl.saturation, lightness: hsl.lightness * value, alpha: hsl.alpha)
    }
}

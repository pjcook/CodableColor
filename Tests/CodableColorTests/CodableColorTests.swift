import CodableColor
import UIKit
import XCTest

final class ColorSystemTests: XCTestCase {
    
    var colors = [
        "#E40046",
        "#F3F3F3",
        "#F7F7F7",
        "#FFFFFF",
        "#000000",
        "#711C46",
        "#E0E6EA",
        "#EED29E",
        "#EBE3DC",
        "#DBEBE7",
    ]
    
    var isLightResults = [
        false,
        true,
        true,
        true,
        false,
        false,
        true,
        true,
        true,
        true,
    ]
    
    func test_hexString() throws {
        for color in colors {
            let hexColor = try CodableColor(color)
            XCTAssertEqual(hexColor.hexString, color)
            XCTAssertEqual(hexColor.description, color)
        }
    }
    
    func test_rgb() throws {
        for color in colors {
            let uiColor = UIColor(hexString: color)
            let hexColor = try CodableColor(color)
            
            var r1: CGFloat = 0
            var g1: CGFloat = 0
            var b1: CGFloat = 0
            uiColor.getRed(&r1, green: &g1, blue: &b1, alpha: nil)
            
            let (r2, g2, b2) = hexColor.rgb
            
            XCTAssertEqual(r1, r2, "Failed: \(color)")
            XCTAssertEqual(g1, g2, "Failed: \(color)")
            XCTAssertEqual(b1, b2, "Failed: \(color)")
        }
    }
    
    func test_rgba() throws {
        for color in colors {
            let uiColor = UIColor(hexString: color)
            let hexColor = try CodableColor(color)
            
            var r1: CGFloat = 0
            var g1: CGFloat = 0
            var b1: CGFloat = 0
            var a1: CGFloat = 0
            uiColor.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
            
            let (r2, g2, b2, a2) = hexColor.rgba
            
            XCTAssertEqual(r1, r2, "Failed: \(color)")
            XCTAssertEqual(g1, g2, "Failed: \(color)")
            XCTAssertEqual(b1, b2, "Failed: \(color)")
            XCTAssertEqual(a1, a2, "Failed: \(color)")
        }
    }
    
    func test_hsb() throws {
        for color in colors {
            let uiColor = UIColor(hexString: color)
            let hexColor = try CodableColor(color)
            
            var h1: CGFloat = 0
            var s1: CGFloat = 0
            var b1: CGFloat = 0
            uiColor.getHue(&h1, saturation: &s1, brightness: &b1, alpha: nil)
            
            let (h2, s2, b2) = hexColor.hsb
            
            // There are some rounding issues, so converting to integers helps
            XCTAssertEqual(Int(h1 * 256), Int(h2 * 256), "Failed: \(color)")
            XCTAssertEqual(s1, s2, "Failed: \(color)")
            XCTAssertEqual(b1, b2, "Failed: \(color)")
        }
    }
    
    func test_hsba() throws {
        for color in colors {
            let uiColor = UIColor(hexString: color)
            let hexColor = try CodableColor(color)
            
            var h1: CGFloat = 0
            var s1: CGFloat = 0
            var b1: CGFloat = 0
            var a1: CGFloat = 0
            uiColor.getHue(&h1, saturation: &s1, brightness: &b1, alpha: &a1)
            
            let (h2, s2, b2, a2) = hexColor.hsba
            
            // There are some rounding issues, so converting to integers helps
            XCTAssertEqual(Int(h1 * 256), Int(h2 * 256), "Failed: \(color)")
            XCTAssertEqual(s1, s2, "Failed: \(color)")
            XCTAssertEqual(b1, b2, "Failed: \(color)")
            XCTAssertEqual(a1, a2, "Failed: \(color)")
        }
    }
    
    func test_hsl() throws {
        let hexColor = try CodableColor("#E40046")
        
        let h1: CGFloat = 342.0/360.0
        let s1: CGFloat = 1
        let l1: CGFloat = 0.45
        
        let (h2, s2, l2) = hexColor.hsl
        
        // There are some rounding issues, so rounding helps
        XCTAssertEqual(h1, h2.rounded(to: 2))
        XCTAssertEqual(s1, s2)
        XCTAssertEqual(l1, l2.rounded(to: 2))
    }
    
    func test_rgbToHSL() throws {
        let hexColor = try CodableColor("#E60045")
        let r1: CGFloat = 230/255
        let g1: CGFloat = 0
        let b1: CGFloat = 69/255
        let h1: CGFloat = 341/360
        let s1: CGFloat = 1
        let l1: CGFloat = 0.451
        
        let (r2, g2, b2, a2) = hexColor.rgba
        let (h3, s3, l3, a3) = CodableColor.rgbToHSL(red: r2, green: g2, blue: b2, alpha: a2)
        let (h4, s4, l4, a4) = hexColor.hsla
        
        XCTAssertEqual(r1, r2)
        XCTAssertEqual(g1, g2)
        XCTAssertEqual(b1, b2)
        XCTAssertEqual(h1.rounded(to: 2), h3.rounded(to: 2))
        XCTAssertEqual(s1, s3)
        XCTAssertEqual(l1, l3.rounded(to: 3))
        XCTAssertEqual(a2, 1)
        XCTAssertEqual(a3, 1)
        XCTAssertEqual(h1.rounded(to: 2), h4.rounded(to: 2))
        XCTAssertEqual(s1, s4)
        XCTAssertEqual(l1.rounded(to: 2), l4.rounded(to: 2))
        XCTAssertEqual(a2, a4)
    }
    
    func test_rgbToHex() throws {
        for color in colors {
            let hexColor = try CodableColor(color)
            let (r1, g1, b1, a1) = hexColor.rgba
            let hex1 = CodableColor.rgbToHex(red: r1, green: g1, blue: b1)
            let hex2 = CodableColor.rgbToHex(red: r1, green: g1, blue: b1, alpha: a1)
            XCTAssertEqual(color, hex1)
            XCTAssertEqual(color + "FF", hex2)
        }
    }
    
    func test_rgbToHex_withAlpha() throws {
        let hexColor = try CodableColor("#E4004657")
        let (r1, g1, b1, a1) = hexColor.rgba
        let hex2 = CodableColor.rgbToHex(red: r1, green: g1, blue: b1, alpha: a1)
        XCTAssertEqual("#E4004657", hex2)
    }
    
    func test_hsl_and_rgbToHSL() throws {
        for color in colors {
            let hexColor = try! CodableColor(color)
            let (r1, g1, b1, a1) = hexColor.rgba
            let (h2, s2, l2, a2) = hexColor.hsla
            let (h3, s3, l3, a3) = CodableColor.rgbToHSL(red: r1, green: g1, blue: b1, alpha: a1)
            XCTAssertEqual(h2.rounded(to: 2), h3.rounded(to: 2), "Failed: \(color) \(Int(r1*255)),\(Int(g1*255)),\(Int(b1*255))")
            XCTAssertEqual(s2.rounded(to: 2), s3.rounded(to: 2), "Failed: \(color) \(Int(r1*255)),\(Int(g1*255)),\(Int(b1*255))")
            XCTAssertEqual(l2, l3, "Failed: \(color) \(Int(r1*255)),\(Int(g1*255)),\(Int(b1*255))")
            XCTAssertEqual(a2, a3, "Failed: \(color) \(Int(r1*255)),\(Int(g1*255)),\(Int(b1*255))")
        }
    }
    
    func test_hslToRGB() throws {
        for color in colors {
            let hexColor = try CodableColor(color)
            let (r1, g1, b1, a1) = hexColor.rgba
            let (h2, s2, l2, a2) = hexColor.hsla
            let (r3, g3, b3, a3) = CodableColor.hslToRGB(hue: h2, saturation: s2, lightness: l2, alpha: a2)
            
            XCTAssertEqual(r1.rounded(to: 2), r3.rounded(to: 2), "Failed: \(color)")
            XCTAssertEqual(g1.rounded(to: 2), g3.rounded(to: 2), "Failed: \(color)")
            XCTAssertEqual(b1.rounded(to: 2), b3.rounded(to: 2), "Failed: \(color)")
            XCTAssertEqual(a1, a3, "Failed: \(color)")
        }
    }
    
    func test_hslToRGB2() throws {
        let hexColor = try CodableColor("E60045")
        let (r1, g1, b1, a1) = hexColor.rgba
        XCTAssertEqual(230/255, r1)
        XCTAssertEqual(0, g1)
        XCTAssertEqual(69/255, b1)
        
        let (r2, g2, b2, a2) = CodableColor.hslToRGB(hue: 342/360, saturation: 1, lightness: 0.45, alpha: 1)
        XCTAssertEqual(r1.rounded(to: 2), r2.rounded(to: 2))
        XCTAssertEqual(g1.rounded(to: 2), g2.rounded(to: 2))
        XCTAssertEqual(b1.rounded(to: 2), b2.rounded(to: 2))
        XCTAssertEqual(a1, a2)
    }
    
    func test_hue() throws {
        for color in colors {
            let hexColor = try CodableColor(color)
            let (r, g, b, a) = hexColor.rgba
            let (h1, _, _, _) = CodableColor.rgbToHSB(red: r, green: g, blue: b, alpha: a)
            let (h2, _, _, _) = CodableColor.rgbToHSL(red: r, green: g, blue: b, alpha: a)
            XCTAssertEqual(h1.rounded(to: 9), h2.rounded(to: 9), "Failed: \(color)")
        }
    }
    
    func test_hslToRGB3() throws {
        let hexColor = try CodableColor("000000")
        let (r1, g1, b1, a1) = hexColor.rgba
        let (h3, s3, l3, a3) = hexColor.hsla
        let (r2, g2, b2, a2) = CodableColor.hslToRGB(hue: h3, saturation: s3, lightness: l3, alpha: a3)
        XCTAssertEqual(r1.rounded(to: 2), r2.rounded(to: 2))
        XCTAssertEqual(g1.rounded(to: 2), g2.rounded(to: 2))
        XCTAssertEqual(b1.rounded(to: 2), b2.rounded(to: 2))
        XCTAssertEqual(a1, a2)
    }
    
    func test_hslToHSB() throws {
        for color in colors {
            let uiColor = UIColor(hexString: color)
            let hexColor = try CodableColor(color)
            
            var h1: CGFloat = 0
            var s1: CGFloat = 0
            var b1: CGFloat = 0
            var a1: CGFloat = 0
            uiColor.getHue(&h1, saturation: &s1, brightness: &b1, alpha: &a1)
            
            let (h2, s2, l2, a2) = hexColor.hsla
            let (h3, s3, b3, a3) = CodableColor.hslToHSB(hue: h2, saturation: s2, lightness: l2, alpha: a2)
            
            // There are some rounding issues, so converting to integers helps
            XCTAssertEqual(Int(h1*256), Int(h3*256), "Failed: \(color)")
            XCTAssertEqual(Int(s1*256), Int(s3*256), "Failed: \(color)")
            XCTAssertEqual(Int(b1*256), Int(b3*256), "Failed: \(color)")
            XCTAssertEqual(Int(a1*256), Int(a3*256), "Failed: \(color)")
        }
    }
    
    func test_hsbToRGB() throws {
        for color in colors {
            let hexColor = try CodableColor(color)
            let (r1, g1, b1, a1) = hexColor.rgba
            let (h2, s2, b2, a2) = hexColor.hsba
            let (r3, g3, b3, a3) = CodableColor.hsbToRGB(hue: h2, saturation: s2, brightness: b2, alpha: a2)
            XCTAssertEqual(r1, r3)
            XCTAssertEqual(g1.rounded(to: 9), g3.rounded(to: 9))
            XCTAssertEqual(b1.rounded(to: 9), b3.rounded(to: 9))
            XCTAssertEqual(a1, a3)
        }
    }
    
    func test_correctHexColor() throws {
        let hexColor1 = try CodableColor("E40046")
        XCTAssertEqual("#E40046", hexColor1.hexString)
        
        let hexColor2 = try CodableColor("E4004657")
        XCTAssertEqual("#E4004657", hexColor2.hexString)
        
        let hexColor3 = try CodableColor("000")
        XCTAssertEqual("#000", hexColor3.hexString)
    }
    
    func test_invalidHexColor() throws {
        XCTAssertThrowsError(try CodableColor("0464"))
        XCTAssertThrowsError(try CodableColor("#0465"))
        let hexColor = try CodableColor("##04655")
        
        // Invalid colour defaults to black
        let (r1, g1, b1, a1) = hexColor.rgba
        let (r2, g2, b2, a2) = try! CodableColor("000000").rgba
        XCTAssertEqual(r1, r2)
        XCTAssertEqual(g1, g2)
        XCTAssertEqual(b1, b2)
        XCTAssertEqual(a1, a2)
        
        let (r3, g3, b3, a3) = try! CodableColor("XXX").rgba
        XCTAssertEqual(r1, r3)
        XCTAssertEqual(g1, g3)
        XCTAssertEqual(b1, b3)
        XCTAssertEqual(a1, a3)
        
        let black = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        let white = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        XCTAssertEqual(UIColor(hexString: "XXX"), black)
        XCTAssertEqual(UIColor(hexString: "000"), black)
        XCTAssertEqual(UIColor(hexString: "FFF"), white)
        XCTAssertEqual(UIColor(hexString: "##000000FF"), black)
        XCTAssertEqual(UIColor(hexString: "#FFFFFFFF"), white)
    }
    
    func test_isLight() throws {
        for (color, isLight) in zip(colors, isLightResults) {
            let hexColor = try CodableColor(color)
            XCTAssertEqual(isLight, hexColor.isLight, "Failed: \(color)")
        }
    }
    
    func test_codable() throws {
        let hexColor1 = try CodableColor("E40046")
        let data = try JSONEncoder().encode(hexColor1)
        let hexColor2 = try JSONDecoder().decode(CodableColor.self, from: data)
        
        XCTAssertEqual(hexColor1.hexString, hexColor2.hexString)
        XCTAssertEqual(hexColor1.red, hexColor2.red)
        XCTAssertEqual(hexColor1.green, hexColor2.green)
        XCTAssertEqual(hexColor1.blue, hexColor2.blue)
        XCTAssertEqual(hexColor1.alpha, hexColor2.alpha)
    }
    
    func test_lightness() throws {
        let lightnesses = [
            "#E40046": ["#160006", "#2D000D", "#440014", "#5B001B", "#720022"],
            "#F3F3F3": ["#181818", "#303030", "#484848", "#616161", "#797979"],
            "#F7F7F7": ["#181818", "#313131", "#4A4A4A", "#626262", "#7B7B7B"],
            "#FFFFFF": ["#191919", "#333333", "#4C4C4C", "#666666", "#7F7F7F"],
            "#000000": ["#000000", "#000000", "#000000", "#000000", "#000000"],
            "#711C46": ["#0B0206", "#16050D", "#210814", "#2D0B1B", "#380D23"],
            "#E0E6EA": ["#12171B", "#242F36", "#374751", "#495F6D", "#5C7688"],
            "#EED29E": ["#211705", "#432F0B", "#654711", "#865F17", "#A8771D"],
            "#EBE3DC": ["#1C1610", "#392C21", "#564331", "#735942", "#906F52"],
            "#DBEBE7": ["#101D19", "#203A33", "#30574D", "#407467", "#519181"],
        ]
        
        let variantLightness = [0.1, 0.2, 0.3, 0.4, 0.5]
        
        for color in colors {
            let hexColor1 = try CodableColor(color)
            for (variance, expectedResult) in zip(variantLightness, lightnesses[color]!) {
                let lighterColor = try hexColor1.applying(lightness: variance)
                XCTAssertEqual(lighterColor.hexString, expectedResult)
            }
        }
    }
    
    func test_json() throws {
        struct TestObject: Codable {
            let color: CodableColor
        }
        
        let sut = TestObject(color: try CodableColor("E40046"))
        let data = try JSONEncoder().encode(sut)
        let json = try XCTUnwrap(String(data: data, encoding: .utf8))
        let expectedResult = "{\"color\":\"#E40046\"}"
        XCTAssertEqual(json, expectedResult)
    }
}

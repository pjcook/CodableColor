//
//  Numbers+Rounding.swift
//  ColorSystem
//
//  Created by PJ on 18/03/2024.
//

import Foundation

extension Double {
    public func rounded(to places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension CGFloat {
    public func rounded(to places: Int) -> CGFloat {
        let divisor = pow(10.0, CGFloat(places))
        return (self * divisor).rounded() / divisor
    }
}

extension Float {
    public func rounded(to places: Int) -> Float {
        let divisor = pow(10.0, Float(places))
        return (self * divisor).rounded() / divisor
    }
}

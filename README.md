# CodableColor

The purpose of this project is to provide a Codable color class that can be used on a server with Vapor cloud. I needed the functionality and flexibility of UIColor, but UIKit is not supported in Swift Server, therefore I had to reverse engineer a Codable container and reverse engineer all the useful functions for converting betweenL HexString, RGB, HSL, HSB (also know as HSV). I also included a useful `luminance` function that I'm using to determine whether I should put `black` or `white` text on top of certain background colors. 

### Credits to
* https://www.rapidtables.com/convert/color/rgb-to-hex.html
* https://gist.github.com/mjackson/5311256
* https://en.wikipedia.org/wiki/HSL_and_HSV#:~:text=HSL%20stands%20for%20hue%2C%20saturation,hue%2C%20saturation%2C%20and%20intensity.

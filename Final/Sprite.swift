//
//  Sprite.swift
//  Final
//
//  Created by Zak Peters on 4/10/17.
//  Copyright © 2017 Zak. All rights reserved.
//

import GLKit

class Sprite {
    //    let aspect: Float
    var positionX: Float = 0.0
    var positionY: Float = 0.0
    
    var scaleX: Float = 1.0
    var scaleY: Float = 1.0
    
    var rotation: Float = 0.0
    
    let image: UIImage
    
    private var texture: GLKTextureInfo?
    
    private static var program: GLuint = 0
    
    private static let quad: [Float] = [
        0.5, -0.5, //Pos(x, y)
        1.0, 0.0, 0.0, 1.0, //Color (rgba)
        1.0, 1.0, //Texture Info (x, y)
        
        -0.5, -0.5,
        0.0, 1.0, 0.0, 1.0,
        0.0, 1.0,
        
        0.5, 0.5,
        0.0, 0.0, 1.0, 1.0,
        1.0, 0.0,
        
        -0.5, 0.5,
        1.0, 0.5, 0.0, 1.0,
        0.0, 0.0
    ]
    
    init(image: UIImage) {
        self.image = image
        texture = try? GLKTextureLoader.texture(with: image.cgImage!, options: nil)
        Sprite.setup()
    }
    
    
    private static func setup() {
        
        if program != 0{
            return
        }
        
        print("Setting up sprite program")
        
        let vertexShaderPath: String = Bundle.main.path(forResource: "vertex", ofType: "glsl", inDirectory: nil)!
        let vertexShaderSource: NSString = try! NSString(contentsOfFile: vertexShaderPath, encoding: String.Encoding.utf8.rawValue)
        var vertexShaderData = vertexShaderSource.cString(using: String.Encoding.utf8.rawValue)
        
        let vertexShader: GLuint = glCreateShader(GLenum(GL_VERTEX_SHADER))
        
        glShaderSource(vertexShader, 1, &vertexShaderData, nil)
        glCompileShader(vertexShader)
        
        //vertex shader
        var vertexCompileStatus: GLint = GL_FALSE
        glGetShaderiv(vertexShader, GLenum(GL_COMPILE_STATUS), &vertexCompileStatus)
        
        if vertexCompileStatus == GL_FALSE {
            var logLength: GLint = 0
            glGetShaderiv(vertexShader, GLenum(GL_INFO_LOG_LENGTH), &logLength)
            let logBuffer = UnsafeMutablePointer<GLchar>.allocate(capacity: Int(logLength))
            
            glGetShaderInfoLog(vertexShader, logLength, nil, logBuffer)
            
            let logString = String(cString: logBuffer)
            
            print(logString)
            fatalError("Error: Shader did not compile")
        }
        
        //fragment shader
        let fragmentShaderPath: String = Bundle.main.path(forResource: "fragment", ofType: "glsl", inDirectory: nil)!
        let fragmentShaderSource: NSString = try! NSString(contentsOfFile: fragmentShaderPath, encoding: String.Encoding.utf8.rawValue)
        var fragmentShaderData = fragmentShaderSource.cString(using: String.Encoding.utf8.rawValue)
        
        let fragmentShader: GLuint = glCreateShader(GLenum(GL_FRAGMENT_SHADER))
        
        glShaderSource(fragmentShader, 1, &fragmentShaderData, nil)
        glCompileShader(fragmentShader)
        
        var fragmentCompileStatus: GLint = GL_FALSE
        glGetShaderiv(fragmentShader, GLenum(GL_COMPILE_STATUS), &fragmentCompileStatus)
        
        if fragmentCompileStatus == GL_FALSE {
            var logLength: GLint = 0
            glGetShaderiv(fragmentShader, GLenum(GL_INFO_LOG_LENGTH), &logLength)
            let logBuffer = UnsafeMutablePointer<GLchar>.allocate(capacity: Int(logLength))
            
            glGetShaderInfoLog(fragmentShader, logLength, nil, logBuffer)
            
            let logString = String(cString: logBuffer)
            
            print(logString)
            fatalError("Error: fragment shader did not compile")
        }
        
        program = glCreateProgram()
        glAttachShader(program, vertexShader)
        glAttachShader(program, fragmentShader)
        glBindAttribLocation(program, 0, "position")
        glBindAttribLocation(program, 1, "color")
        glBindAttribLocation(program, 2, "texturePos")
        glLinkProgram(program)
        
        var linkStatus : GLint = GL_FALSE
        glGetProgramiv(program, GLenum(GL_LINK_STATUS), &linkStatus)
        if linkStatus == GL_FALSE{
            var logLength: GLint = 0
            
            glGetProgramiv(program, GLenum(GL_LINK_STATUS), &logLength)
            
            let logBuffer = UnsafeMutablePointer<GLchar>.allocate(capacity: Int(logLength))
            
            glGetProgramInfoLog(program, logLength, nil, logBuffer)
            
            let logString: String = String(cString: logBuffer)
            
            print(logString)
            fatalError("Error: Program did not link")
        }
        
        glUseProgram(program)
        
        glEnableVertexAttribArray(0)
        glEnableVertexAttribArray(1)
        glEnableVertexAttribArray(2)
    }
    
    
    
    
    func draw() {
        
        glVertexAttribPointer(0, 2, GLenum(GL_FLOAT), GLboolean(GL_FALSE), 32, Sprite.quad)
        
        glVertexAttribPointer(1, 4, GLenum(GL_FLOAT), GLboolean(GL_FALSE), 32, UnsafePointer(Sprite.quad) + 2)
        
        glVertexAttribPointer(2, 2, GLenum(GL_FLOAT), GLboolean(GL_FALSE), 32, UnsafePointer(Sprite.quad) + 6)
        
        glUniform2f(glGetUniformLocation(Sprite.program, "translate"), positionX, positionY)
        glUniform2f(glGetUniformLocation(Sprite.program, "scale"), scaleX, scaleY)
        glUniform1f(glGetUniformLocation(Sprite.program, "rotation"), rotation)
        
        if let texture = texture {
            glBindTexture(GLenum(GL_TEXTURE_2D), texture.name)
        }
        
        glDrawArrays(GLenum(GL_TRIANGLE_STRIP), 0, 4)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

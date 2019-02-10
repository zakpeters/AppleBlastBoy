attribute vec2 position;
uniform vec2 translate;
uniform vec2 scale;
uniform float rotation;


attribute vec4 color;
varying vec4 colorInterpolated;

attribute vec2 texturePos;
varying vec2 texturePosInterpolated;

void main() {
    
    if (rotation == 0.0){
        gl_Position = vec4( (position.x * scale.x) + translate.x,  (position.y * scale.y) + translate.y, 0.0, 1.0);
    }
    if (rotation != 0.0){
        gl_Position = vec4( (position.x * cos(rotation) - position.y * sin(rotation)) * scale.x + translate.x,  (position.x * sin(rotation) + position.y * cos(rotation)) * scale.y + translate.y, 0.0, 1.0);
    }
    
    colorInterpolated = color;
    texturePosInterpolated = texturePos;
}

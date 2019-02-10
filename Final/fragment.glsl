varying highp vec4 colorInterpolated;
varying highp vec2 texturePosInterpolated;

uniform sampler2D textureUnit;

void main() {
    gl_FragColor = texture2D(textureUnit, texturePosInterpolated);
}

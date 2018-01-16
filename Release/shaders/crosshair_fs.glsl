#version 140

uniform sampler2D texSampler;

in vec2 texCoord_v;

out vec4 fragmentColor;

void main() {

  fragmentColor = texture(texSampler, texCoord_v);

}
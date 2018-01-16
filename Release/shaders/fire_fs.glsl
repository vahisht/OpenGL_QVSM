#version 140

uniform float time;           // used for simulation of moving lights (such as sun) and to select proper animation frame
uniform mat4 Vmatrix;         // view (camera) transform --> world to eye coordinates
uniform sampler2D texSampler; // sampler for texture access

smooth in vec3 position_v;    // camera space fragment position
smooth in vec2 texCoord_v;    // fragment texture coordinates

out vec4 fragmentColor;

uniform ivec2 pattern = ivec2(4, 4);


vec4 sampleTexture(int frame) {
	
  vec2 offset = vec2(1.0) / vec2(pattern);

  vec2 texCoordBase = texCoord_v / vec2(pattern);
  vec2 texCoord = texCoordBase + vec2(frame % pattern.x,  -(frame / pattern.y)) * offset;

  return texture(texSampler, texCoord);
}

void main() {
  float frameDuration = 0.1f;

  int frame = int(time / frameDuration);

  fragmentColor = sampleTexture(frame);

}
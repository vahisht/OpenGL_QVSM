#version 140

uniform float time;           // used for simulation of moving lights (such as sun) and to select proper animation frame
uniform mat4 Vmatrix;         // view (camera) transform --> world to eye coordinates
uniform sampler2D texSampler; // sampler for texture access

smooth in vec3 position_v;    // camera space fragment position
smooth in vec2 texCoord_v;    // fragment texture coordinates

out vec4 fragmentColor;

uniform ivec2 pattern = ivec2(4, 4);

float decay = 0.05;
float factor = 5.0f;
vec2 aspect = vec2(0.56f , 1.0f);
float timeRatio = 0.5f;
vec2 border = vec2(-0.5);

void main() {
  float frameDuration = 0.1f;

  float localTime = time * decay * timeRatio;
  //localTime = 0;

  vec2 offset = vec2((floor(localTime) - localTime) * 4 + 1.0, 0.0);

  vec2 texCoord = (texCoord_v * aspect) * factor + offset + border;

  fragmentColor = texture(texSampler, texCoord);

}
#version 140

in vec3 position;       
in vec2 texCoord;   

smooth out vec2 texCoord_v;

void main() {

float factor = 20.0f;

  texCoord_v = texCoord;
  gl_Position = vec4( position.x / factor , position.y / factor*1.6 , 0.0f, 1.0f);

}
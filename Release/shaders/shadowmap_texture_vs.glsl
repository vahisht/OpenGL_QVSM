#version 330 core

// Input vertex data, different for all executions of this shader.
layout(location = 0) in vec3 vertexPosition_modelspace;

// Output data ; will be interpolated for each fragment.
out vec4 ShadowCoord;

uniform mat4 MVP;
uniform mat4 DepthBiasMVP;

void main() {
	// Output position of the vertex, in clip space : MVP * position
	gl_Position = MVP * vec4(vertexPosition_modelspace, 1);

	// Same, but with the light's view matrix
	ShadowCoord = DepthBiasMVP * vec4(vertexPosition_modelspace, 1);
}


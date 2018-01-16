#version 330 core

// Ouput data
//layout(location = 0) out vec4 color;
out vec4 fragmentColor;

uniform sampler2D	shadowMap;
uniform bool		update;
uniform sampler2D	previous;

in vec4 ShadowCoord;
//in vec4 v_normal;

void main() {

	// discard out of range fragments during refinement
	//if (update) {
		if (ShadowCoord.x < 0.0 || ShadowCoord.x > 1.0) discard;
		if (ShadowCoord.y < 0.0 || ShadowCoord.y > 1.0) discard;
	//}
	
	float bias = 0.002;
	bias = clamp(bias, 0, 0.01);
	float visibility = 1.0;
	if ( texture(shadowMap, ShadowCoord.xy).z  <  ShadowCoord.z - bias ) {
		visibility = 0.0;
	}

	float x_coord = gl_FragCoord.x / 1024;
	float y_coord = gl_FragCoord.y / 1024;

	// change the fragment color if it's different from the previous iteration. If it's the same, discard it
	if ( update && ( abs(texture(previous, vec2(x_coord, y_coord) ).r - visibility ) ) < 0.1f) discard;

	fragmentColor = vec4(visibility, visibility, visibility, 1.0);



}
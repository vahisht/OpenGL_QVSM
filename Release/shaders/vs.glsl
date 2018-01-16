#version 140

in		vec3	position;
in		vec3	normal;             
in		vec3	color;
in		vec2	texCoord;

smooth	out		vec2	texCoord_v;
		out		float	mistFactor;
smooth	out		vec3	phNormal;
smooth	out		vec3	vertexPosition;

uniform		mat4	PVMmatrix;   // transformation matrix
uniform		mat4	Vmatrix;		// View matrix
uniform		mat4	Mmatrix;		// Model matrix
uniform		mat4	normalMatrix;   // Normal matrix
uniform		int		task;
uniform		vec3	lightPos;	// world coords
uniform		vec3	playerPos;	// world coords
uniform		vec3	playerDir;
uniform		bool	mist;
uniform		bool	flash;

void main()
{
	float dist;

	vertexPosition = (Mmatrix * vec4(position, 1.0)).xyz;         // vertex in world coordinates
	vec3 vertexNormal   = normalize( (normalMatrix * vec4(normal, 0.0) ).xyz);   // normal in world coordinates by NormalMatrix

	gl_Position = PVMmatrix * vec4(position, 1.0) ;
	texCoord_v = texCoord;
	
	dist = distance( vec4(playerPos, 0.0) , (Mmatrix * vec4(position, 1.0))*vec4(1.0f, 1.0f, 0.0f, 1.0f) );

	dist = dist - 4*position.y;

	if ( dist > 17 ) { 
		mistFactor = 1.0f; 
	} else {
		if ( dist < 7 )  {
			mistFactor = 0.0f;
		} else {
			mistFactor = (dist - 7.0)/10.0;
		} 

	}
	
	if ( !mist ) mistFactor = 0.0f;

	vec4 normalTrans = Mmatrix * vec4(normal,0.0f);

	phNormal = normalize(normalTrans.xyz);
}

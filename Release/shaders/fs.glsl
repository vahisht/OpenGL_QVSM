#version 140

struct Light {         // structure describing light parameters
  vec3  ambient;       // intensity & color of the ambient component
  vec3  diffuse;       // intensity & color of the diffuse component
  vec3  specular;      // intensity & color of the specular component
  vec3  position;      // light position
  vec3  spotDirection; // spotlight direction
  float spotCosCutOff; // cosine of the spotlight's half angle
  float spotExponent;  // distribution of the light energy within the reflector's cone (center->cone's edge)
};

smooth	in vec2 texCoord_v;
		in float mistFactor;
smooth	in	vec3	phNormal;
smooth	in	vec3	vertexPosition;

uniform		sampler2D texSampler;  // sampler for the texture access
uniform		sampler2D shadowMap;	// shadowmap sampler

uniform		vec3	ambient;       // ambient component
uniform		vec3	diffuse;       // diffuse component
uniform		vec3	specular;      // specular component
uniform		float	shininess;     // sharpness of specular reflection
uniform		bool	useTexture;


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

out vec4 fragmentColor;



vec4 directionalLight(Light light, vec3 vertexPosition, vec3 vertexNormal) {

  vec3 ret = vec3(0.0f);

  vec3 L = normalize(light.position);
  float LdotN = max(dot(-L, vertexNormal), 0.0f);

  ret += diffuse * light.diffuse * LdotN;

  return vec4(ret, 1.0f);
}

vec4 spacePointLight(Light light, vec3 vertexPosition, vec3 vertexNormal) {

  vec3 ret = vec3(0.0f);

  vec3 L = normalize(vertexPosition - light.position);
  vec3 R = reflect( -L , vertexNormal );
  vec3 V = normalize(-vertexPosition);

  ret += diffuse * light.diffuse * max( dot( -L, vertexNormal) , 0 ) + 
		 ambient * light.ambient;

  return vec4(ret, 1.0f);
}

vec4 reflectorLight(Light light, vec3 vertexPosition, vec3 vertexNormal) {

  vec3 ret = vec3(0.0f);

  vec3 L = normalize(light.position - vertexPosition);
  vec3 R = reflect(L, vertexNormal);
  vec3 V = normalize(-vertexPosition);
  float NdotL = max(0.0, dot(vertexNormal, L));
  float RdotV = max(0.0, dot(R, V));
  float spotCoef = max(0.0, dot(-L, light.spotDirection));

  ret += ambient * light.ambient;
  ret += diffuse * light.diffuse * NdotL;

  if(spotCoef < light.spotCosCutOff)
    ret *= 0.0;
  else
    ret *= pow(spotCoef, light.spotExponent);

  return vec4(ret, 1.0);
}



Light sun;
Light pointLight;
Light reflector;

void loadLights() {

  // set up sun parameters
  sun.ambient  = vec3(0.02f);
  sun.diffuse  = vec3(0.2f, 0.2f, 0.2f);
  sun.specular = vec3(1.0f);
  sun.position = vec3( 0.0f , 0.0f, -5.0f);

  pointLight.ambient  = vec3(0.2f);
  pointLight.diffuse  = vec3(0.7f, 0.7f, 0.7f);
  pointLight.specular = vec3(1.0f);
  pointLight.position = lightPos;

  reflector.ambient = vec3(0.0f);
  reflector.diffuse  = vec3(0.9f, 0.9f, 0.9f);
  reflector.specular = vec3(1.0f);
  reflector.position = playerPos;
  reflector.spotDirection = playerDir;
  reflector.spotCosCutOff = 0.90f;
  reflector.spotExponent = 5.0f;

}


void main()
{

  loadLights();

  fragmentColor = vec4(0.0f);
  float x_coord = gl_FragCoord.x / 1024;
  float y_coord = gl_FragCoord.y / 1024;

  // Light computation
  vec4 vertexComputedColor = vec4 ( pointLight.ambient, 1.0 );
 
		if ( texture(shadowMap, vec2( x_coord, y_coord ) ).r > 0.5f ) vertexComputedColor += directionalLight(pointLight, vertexPosition, phNormal);
		//vertexComputedColor += spacePointLight(pointLight, vertexPosition, phNormal);
		if (flash) vertexComputedColor += reflectorLight(reflector, vertexPosition, phNormal);

	fragmentColor =  vertexComputedColor;

  if (useTexture) fragmentColor *= texture(texSampler, texCoord_v*10); 
	

  fragmentColor = mix(fragmentColor, vec4(0.75, 0.75, 0.75, 1.0), mistFactor);

  //fragmentColor = vec4(phNormal, 1.0f);

}

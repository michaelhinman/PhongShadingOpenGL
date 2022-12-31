#version 140

#define MAX_LIGHTS 10
#define EPSILON 0.000001

// input vertex attributes
in vec3 position;
in vec3 normal;

struct PointLight {
  vec3 position;
  vec3 intensity;
  vec3 ambient;
};

struct PhongMaterial {
  vec3 ambient;
  vec3 diffuse;
  vec3 specular;
  float shininess;
};

// uniform attributes
uniform PointLight point_lights[MAX_LIGHTS];
uniform uint point_light_count;
uniform PhongMaterial material;
uniform mat4 mv_matrix;
uniform mat4 norm_matrix;
uniform mat4 proj_matrix;

// output attributes
out vec3 out_normal;
out vec3 vertpos;

void main(void)
{
  vec4 mv_position = mv_matrix * vec4(position, 1);
  vertpos = vec3(mv_position) /mv_position.w;
  out_normal = normalize((norm_matrix * vec4(normal, 0)).xyz);
  gl_Position = proj_matrix * mv_position;
}

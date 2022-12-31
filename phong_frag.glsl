#version 140

#define MAX_LIGHTS 10
#define EPSILON 0.000001

// input fragment attributes
in vec3 out_normal;
in vec3 vertpos;

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
out vec4 Frag_color;

vec3 Illuminate(vec3 vertex_position, uint i, vec3 view_vec, vec3 normal_vec)
{
  // compute irradiance
  vec3 light_vec = point_lights[i].position - vertex_position;
  float dist2 = max(EPSILON, dot(light_vec, light_vec));
  light_vec = normalize(light_vec);
  vec3 irradiance = point_lights[i].intensity * (max(0, dot(light_vec, normal_vec))
					     / dist2);

  // ambient coefficient
  vec3 out_color = point_lights[i].ambient * material.ambient;

  // specular coefficient
  vec3 half_vec = normalize((light_vec + view_vec) * .5);
  float half_dot_normal = dot(half_vec, normal_vec);
  vec3 specular_coeff = vec3(0);
  if (half_dot_normal > 0)
    specular_coeff = material.specular*pow(half_dot_normal, material.shininess);

  // compute out color
  out_color += (material.diffuse + specular_coeff) * irradiance;
  return out_color;
}

void main(void)
{
  vec3 normal_vec = normalize((norm_matrix * vec4(out_normal, 0)).xyz);
  vec3 view_vec = normalize(-vertpos);
  Frag_color = vec4(0, 0, 0, 1);
  for (uint i = 0u; i < point_light_count; ++i)
    Frag_color.xyz += Illuminate(vertpos, i, view_vec, normal_vec);
}


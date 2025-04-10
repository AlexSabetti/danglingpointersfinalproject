shader_type spatial;
render_mode specular_toon, cull_disabled, alpha_to_coverage, diffuse_toon;

uniform sampler2D tex;

uniform float time_scale = 2.0;
uniform float side_to_side = 0.125;
uniform float pivot = 1.0;
uniform float wave = 0.25;
uniform float twist = 0.125;

void vertex() {
	//time_scale is a uniform float
	float time = TIME * time_scale;
	
	//side_to_side is a uniform float
	VERTEX.x += cos(time) * side_to_side;
	
	//angle is scaled by 0.1 so that the fish only pivots and doesn't rotate all the way around
	//pivot is a uniform float
	float pivot_angle = cos(time) * 0.1 * pivot;
	mat2 rotation_matrix = mat2(vec2(cos(pivot_angle), -sin(pivot_angle)), vec2(sin(pivot_angle), cos(pivot_angle)));
	
	VERTEX.xy = rotation_matrix * VERTEX.xy;
	
	float body = (VERTEX.z + 1.0) / 2.0; //for a fish centered at (0, 0) with a length of 2
	
	//wave is a uniform float
	VERTEX.x += cos(time + body) * wave;
	
	//twist is a uniform float
	float twist_angle = cos(time + body) * 0.3 * twist;
	mat2 twist_matrix = mat2(vec2(cos(twist_angle), -sin(twist_angle)), vec2(sin(twist_angle), cos(twist_angle)));
	
	VERTEX.xy = twist_matrix * VERTEX.xy;
}

void fragment() {
	ALBEDO = texture(tex, UV).rgb;
	ALPHA = texture(tex, UV).a;
	ROUGHNESS = 1.0;
}
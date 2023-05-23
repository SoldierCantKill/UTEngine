// NOTE: Shader automatically converted from Godot Engine 4.0.stable's ParticleProcessMaterial.

shader_type particles;
uniform vec3 direction;
uniform float spread;
uniform float initial_linear_velocity_min;
uniform float initial_linear_velocity_max;
uniform float initial_angle_min;
uniform float initial_angle_max;
uniform float angular_velocity_min;
uniform float angular_velocity_max;
uniform float linear_accel_min;
uniform float linear_accel_max;
uniform float radial_accel_min;
uniform float radial_accel_max;
uniform float tangent_accel_min;
uniform float tangent_accel_max;
uniform float scale_min;
uniform float scale_max;
uniform float lifetime_randomness;
uniform vec3 emission_box_extents;
uniform sampler2D sprite : filter_nearest, repeat_disable;
uniform float scrolly;

float rand_from_seed(inout uint seed) {
	int k;
	int s = int(seed);
	if (s == 0)
	s = 305420679;
	k = s / 127773;
	s = 16807 * (s - k * 127773) - 2836 * k;
	if (s < 0)
		s += 2147483647;
	seed = uint(s);
	return float(seed % uint(65536)) / 65535.0;
}

float rand_from_seed_m1_p1(inout uint seed) {
	return rand_from_seed(seed) * 2.0 - 1.0;
}

uint hash(uint x) {
	x = ((x >> uint(16)) ^ x) * uint(73244475);
	x = ((x >> uint(16)) ^ x) * uint(73244475);
	x = (x >> uint(16)) ^ x;
	return x;
}

void start() {
	uint base_number = NUMBER;
	uint alt_seed = hash(base_number + uint(1) + RANDOM_SEED);
	float angle_rand = rand_from_seed(alt_seed);
	float pi = 3.14159;
	float degree_to_rad = pi / 180.0;

	float tex_angle = 0.0;
	float spread_rad = spread * degree_to_rad;
	if (RESTART_VELOCITY) {
		{
			float angle1_rad = rand_from_seed_m1_p1(alt_seed) * spread_rad;
			angle1_rad += direction.x - 0.0 < 0.0001 ? atan(direction.y, direction.x) : sign(direction.y) * (pi / 2.0);
			vec3 rot = vec3(cos(angle1_rad), sin(angle1_rad), 0.0);
			VELOCITY = rot * mix(initial_linear_velocity_min,initial_linear_velocity_max, rand_from_seed(alt_seed));
		}
	}
	float base_angle = (tex_angle) * mix(initial_angle_min, initial_angle_max, angle_rand);
	CUSTOM.x = base_angle * degree_to_rad;
	CUSTOM.y = 0.0;
	CUSTOM.w = (1.0 - lifetime_randomness * rand_from_seed(alt_seed));
	if (RESTART_POSITION) {
		TRANSFORM[3].xyz = vec3(rand_from_seed(alt_seed) * 2.0 - 1.0, rand_from_seed(alt_seed) * 2.0 - 1.0, rand_from_seed(alt_seed) * 2.0 - 1.0) * emission_box_extents;
		vec2 textureS = vec2(textureSize(sprite,0));
		vec2 particlePosition = TRANSFORM[3].xy;
		vec4 spriteColor = texture(sprite,particlePosition/textureS + vec2(0.5,scrolly));
	if (RESTART_VELOCITY) VELOCITY = (EMISSION_TRANSFORM * vec4(VELOCITY, 0.0)).xyz;
	if (COLOR.a - 0.0 < 0.0001){
		ACTIVE = false;
	}
	COLOR = spriteColor;
	TRANSFORM = EMISSION_TRANSFORM * TRANSFORM;
	VELOCITY.z = 0.0;
	TRANSFORM[3].z = 0.0;
	}
}

void process() {
	uint base_number = NUMBER;
	uint alt_seed = hash(base_number + uint(1) + RANDOM_SEED);
	float scale_rand = rand_from_seed(alt_seed);
	float pi = 3.14159;
	float degree_to_rad = pi / 180.0;

	CUSTOM.y += DELTA / LIFETIME;
	float tex_angular_velocity = 1.0;
	float tex_linear_accel = 1.0;
	float tex_radial_accel = 1.0;
	float tex_tangent_accel = 1.0;
	float tex_angle = 1.0;
	vec3 force = vec3( 0, 0, 0);
	vec3 pos = TRANSFORM[3].xyz;
	pos.z = 0.0;
	// apply linear acceleration
	force += length(VELOCITY) > 0.0 ? normalize(VELOCITY) * tex_linear_accel * mix(linear_accel_min, linear_accel_max, rand_from_seed(alt_seed)) : vec3(0.0);
	// apply radial acceleration
	vec3 org = EMISSION_TRANSFORM[3].xyz;
	vec3 diff = pos - org;
	force += length(diff) > 0.0 ? normalize(diff) * tex_radial_accel * mix(radial_accel_min, radial_accel_max, rand_from_seed(alt_seed)) : vec3(0.0);
	// apply tangential acceleration;
	float tangent_accel_val = tex_tangent_accel * mix(tangent_accel_min, tangent_accel_max, rand_from_seed(alt_seed));
	force += length(diff.yx) > 0.0 ? vec3(normalize(diff.yx * vec2(-1.0, 1.0)), 0.0) * tangent_accel_val : vec3(0.0);
	force += ATTRACTOR_FORCE;

	// apply attractor forces
	VELOCITY += force * DELTA;
	
	float base_angle = (tex_angle) * mix(initial_angle_min, initial_angle_max, rand_from_seed(alt_seed));
	base_angle += CUSTOM.y * LIFETIME * (tex_angular_velocity) * mix(angular_velocity_min,angular_velocity_max, rand_from_seed(alt_seed));
	CUSTOM.x = base_angle * degree_to_rad;
	vec3 tex_scale = vec3(1.0);

	TRANSFORM[0] = vec4(cos(CUSTOM.x), -sin(CUSTOM.x), 0.0, 0.0);
	TRANSFORM[1] = vec4(sin(CUSTOM.x), cos(CUSTOM.x), 0.0, 0.0);
	TRANSFORM[2] = vec4(0.0, 0.0, 1.0, 0.0);
	TRANSFORM[3].z = 0.0;
	float base_scale = mix(scale_min, scale_max, scale_rand);
	base_scale = sign(base_scale) * max(abs(base_scale), 0.001);
	TRANSFORM[0].xyz *= base_scale * sign(tex_scale.r) * max(abs(tex_scale.r), 0.001);
	TRANSFORM[1].xyz *= base_scale * sign(tex_scale.g) * max(abs(tex_scale.g), 0.001);
	TRANSFORM[2].xyz *= base_scale * sign(tex_scale.b) * max(abs(tex_scale.b), 0.001);
	if(COLOR.a > 0.0)
	{
		COLOR.a -= 1.0 / LIFETIME * DELTA;
	}
	if (CUSTOM.y > CUSTOM.w) {
		ACTIVE = false;
	}
}


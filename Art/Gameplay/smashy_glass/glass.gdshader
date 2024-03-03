shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back, diffuse_burley, specular_schlick_ggx, unshaded;

uniform sampler2D glass_texture;
uniform float specular;
uniform float offset = 0.05;
uniform float opacity = 0.5;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform float darkness_scale = 1.6; // Uniform to control the scale of darkness

varying flat vec3 norm;

void vertex() {
    norm = NORMAL;
}

void fragment() {
	// don't render backfaces
	if (dot(NORMAL, normalize(VERTEX)) > 1.0) {
		discard;
	}
	
    vec3 normx = normalize(NORMAL);
    vec3 camera_dir = normalize(-VERTEX);
    
    // Calculate the dot product and invert it for less oblique faces to be darker
    float obliqueness = 1.0 - abs(dot(normx, camera_dir)) / length(camera_dir);
    
    // Scale the darkness based on the obliqueness
    obliqueness = obliqueness * darkness_scale;
    
    vec2 displacement = vec2(offset) * normx.xy * 2.0;
    vec4 alpha = texture(SCREEN_TEXTURE, SCREEN_UV + displacement);
    
    // Apply the displacement when fetching the glass_color texture
    vec4 glass_color = texture(glass_texture, SCREEN_UV + displacement);

    // Darken the color based on the obliqueness
    glass_color.rgb *= mix(vec3(1.0), vec3(0.0, 0.0, 1.0), obliqueness);

    ALBEDO = mix(alpha.rgb, glass_color.rgb, opacity);
    SPECULAR = specular;
    ALPHA = opacity;
}

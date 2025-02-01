shader_type canvas_item;

uniform float width_px : hint_range(0.0, 30.0);
uniform vec4 outline_color : source_color;
uniform bool is_active;

// I implemented an initial solution based on GDScript's video but had an issue.
// Sprites were to small and thus the outline would stop at the image's borders.
// And I'm too lazy to resize images. Then I found this thread: 
// https://forum.godotengine.org/t/solved-2d-shader-how-to-apply-a-margin-to-a-texture-before-applying-an-outline/5814/2

void vertex(){
	// start with adding margin to the original sprite
	// this will scale up the sprite, will scale down later in fragment()
	VERTEX += (UV * 2.0 - 1.0) * width_px ;
}

void fragment() {
	if (is_active) {
		// note that TEXTURE_PIXEL_SIZE is actually 1.0/vec2(WIDTH_OF_TEXTURE, HEIGHT_OF_TEXTURE)
		// so 1.0 / TEXTURE_PIXEL_SIZE is vec2(WIDTH, HEIGHT)
		vec2 real_texture_size = 1.0 / TEXTURE_PIXEL_SIZE;
		
		// This is texture size when add margin equal to 
		// width of the outline*2 (left and right / top and down)
		vec2 added_margin_texture_pixel_size = 1.0 / (real_texture_size + (width_px*2.0));
		
		// width in range (0,1), respected to the new texture size
		vec2 width_size = added_margin_texture_pixel_size * width_px;
		// shift the original uv bottom-right for 'width' unit 
		// Calculate how much bigger is the new size compared to the old one
		vec2 shifted_uv = UV - width_size;
		// Then scale the uv down to that ratio
		vec2 ratio = TEXTURE_PIXEL_SIZE / added_margin_texture_pixel_size;
		vec2 scaled_shifted_uv = shifted_uv * ratio;
		
		// sample the original texture with new uv to scale it down
		// to the original size
		vec4 color;
		color = texture(TEXTURE, scaled_shifted_uv);
		// This if is to remove artifacts outside the boundary of sprites
		if (scaled_shifted_uv != clamp(scaled_shifted_uv, vec2(0.0), vec2(1.0))) {
			color.a = 0.0;
		}
		
		
		// Number of times we offset the texture and offset
		vec4 sprite_color = texture(TEXTURE, UV);
		float alpha = -8.0 * sprite_color.a;
		
		vec2 size = vec2(width_px) / vec2(textureSize(TEXTURE, 0));
		float outline = 0.0;
		// lookup offsetted
		outline += texture(TEXTURE, scaled_shifted_uv + vec2(size.x, 0)).a;
		outline += texture(TEXTURE, scaled_shifted_uv + vec2(-size.x, 0)).a;
		outline += texture(TEXTURE, scaled_shifted_uv + vec2(0, size.y)).a;
		outline += texture(TEXTURE, scaled_shifted_uv + vec2(0, -size.y)).a;
		
		outline += texture(TEXTURE, scaled_shifted_uv + vec2(size.x, size.y)).a;
		outline += texture(TEXTURE, scaled_shifted_uv + vec2(-size.x, size.y)).a;
		outline += texture(TEXTURE, scaled_shifted_uv + vec2(size.x, -size.y)).a;
		outline += texture(TEXTURE, scaled_shifted_uv + vec2(-size.x, -size.y)).a;
		
		//vec3 final_color = mix(outline_color.rgb, sprite_color.rgb, sprite_color.a);
		//COLOR = vec4(final_color, clamp(abs(alpha) + sprite_color.a, 0.0, 1.0));
		
		outline = min(outline, 1.0);
		COLOR = mix(color, outline_color, outline - color.a);
	}
}
shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture;

void fragment() {COLOR = texture(SCREEN_TEXTURE, SCREEN_UV) * vec4(1.0, 1.0, 1.0, COLOR.a);}
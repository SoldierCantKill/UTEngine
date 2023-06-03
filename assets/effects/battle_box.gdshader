shader_type canvas_item;

uniform vec3 fgcolor = vec3(1, 1, 1);
uniform float fgopacity = 1;
uniform vec3 bgcolor = vec3(0, 0, 0);
uniform float bgopacity = 1;

void fragment() {
    vec4 color = texture(TEXTURE, UV);
    float isBorder = step(1.0 - COLOR.r, 0.01);
    vec3 finalColor = mix(bgcolor, fgcolor, isBorder);
    COLOR = vec4(finalColor, COLOR.a);
	if(COLOR == vec4(fgcolor,COLOR.a)) COLOR.a = fgopacity;
	else if(COLOR == vec4(bgcolor,COLOR.a)) COLOR.a = bgopacity;
}
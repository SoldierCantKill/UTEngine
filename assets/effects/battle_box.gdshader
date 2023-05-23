shader_type canvas_item;

uniform vec3 fgcolor = vec3(1, 1, 1);
uniform vec3 bgcolor = vec3(0, 0, 0);

void fragment() {
    vec4 color = texture(TEXTURE, UV);

    // Determine if the fragment is part of the border
    float isBorder = step(1.0 - COLOR.r, 0.01);
    
    // Mix the background and foreground colors based on the border condition
    vec3 finalColor = mix(bgcolor, fgcolor, isBorder);
    
    COLOR = vec4(finalColor, COLOR.a);
}
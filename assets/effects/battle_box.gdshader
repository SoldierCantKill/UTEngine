shader_type canvas_item;

uniform vec4 fgcolor = vec4(1.0, 1.0, 1.0, 1.0);
uniform vec4 bgcolor = vec4(0.0, 0.0, 0.0, 1.0);

void fragment()
	{
		if(COLOR.a != 0.0)
		{
			vec4 color = texture(TEXTURE, UV);
			float isBorder = step(1.0 - COLOR.r, 0.01); 
			vec3 finalColor = mix(vec3(bgcolor.rgb), vec3(fgcolor.rgb), isBorder);
			COLOR = vec4(finalColor, COLOR.a);
			if(COLOR == vec4(vec3(fgcolor.rgb),COLOR.a)) COLOR.a = fgcolor.a;
			else if(COLOR == vec4(vec3(bgcolor.rgb),COLOR.a)) COLOR.a = bgcolor.a;
		}
	}
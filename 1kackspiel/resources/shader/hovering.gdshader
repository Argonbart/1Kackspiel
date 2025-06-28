shader_type canvas_item;

uniform float amplitude;
uniform float speed;
uniform float offset;
uniform float time_offset;

void vertex() {
	VERTEX.y += amplitude * sin(speed * TIME + time_offset) + offset;
}
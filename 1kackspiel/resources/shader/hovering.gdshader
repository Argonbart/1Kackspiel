shader_type canvas_item;

void vertex() {
	VERTEX.y += 40.0 * sin(5.0 * TIME);
}
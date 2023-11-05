#version 450
#extension GL_ARB_separate_shader_objects : enable

layout(location = 0) out vec4 color;

layout (binding = 0) uniform sampler2D colorTex;

layout (location = 0 ) in VS_OUT
{
  vec2 texCoord;
} surf;

void main() {
  ivec2 texSize = textureSize(colorTex, 0);
  vec4 values[9];
  int ind = 0;
  for (int y = -1; y <= 1; ++y) {
    for (int x = -1; x <= 1; ++x) {
      ivec2 offset = ivec2(x, y);
      vec2 coord = (surf.texCoord + vec2(offset));
      values[ind] = textureLod(colorTex, coord, 0);
      ++ind;
    }
  }

  for (int i = 0; i < 8; i++) {
    for (int j = 0; j < 8 - i; j++) {
      if (values[j] > values[j + 1]) {
        int temp = values[j];
        values[j] = values[j + 1];
        values[j + 1] = temp;
      }
    }
  }
  color = values[4];
}


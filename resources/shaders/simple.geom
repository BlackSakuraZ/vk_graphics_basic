#version 450
layout (triangles) in;
layout (triangle_strip, max_vertices = 32) out;

layout(push_constant) uniform params_t
{
    mat4 mProjView;
    mat4 mModel;
} params;

layout (location = 0) out VS_IN
{
    vec3 wPos;
    vec3 wNorm;
    vec3 wTangent;
    vec2 texCoord;

} vIn[];

layout (location = 0) out VS_OUT
{
    vec3 wPos;
    vec3 wNorm;
    vec3 wTangent;
    vec2 texCoord;

} vOut;

void emitVertex(vec3 norm, int i) {
    vOut.wPos = vIn[i].wPos;
    vOut.wNorm = vIn[i].wNorm;
    vOut.wTangent = vIn[i].wTangent;
    vOut.texCoord = vIn[i].texCoord;
    gl_Position = params.mProjView * vec4(vIn[i].wPos + norm * 0.02, 1.0);
    EmitVertex();
}

void makeTriangles() {
    vec3 vector0 = vIn[1].wPos - vIn[0].wPos;
    vec3 vector1 = vIn[2].wPos - vIn[1].wPos;
    vec3 surfaceNormal = normalize(cross(vector0, vector1));
    for (int i = 0; i < 3; i++) {
        emitVertex(surfaceNormal, i);
    }
}

void main() {
    makeTriangles();
    EndPrimitive();
}
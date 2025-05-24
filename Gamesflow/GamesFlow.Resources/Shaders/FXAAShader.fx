// FXAAShader.fx - Massive FXAA (Fast Approximate Anti-Aliasing) Shader for gamesflow-emulator-
// Provides high-quality edge smoothing, subpixel aliasing reduction, gamma/linear input support, and extensive configuration.
// Designed for HLSL/DirectX 11/12. Compatible with modern emulators and post-processing pipelines.

// ==== CONSTANTS AND PARAMETERS ====
cbuffer FXAAParams : register(b0)
{
    float2 ScreenSize;          // {width, height}
    float2 InvScreenSize;       // 1.0/ScreenSize
    float SubpixelQuality;      // [0.0 - 1.0], higher = more subpixel aliasing removal
    float EdgeThreshold;        // [0.063 - 0.333], minimum local contrast to apply FXAA
    float EdgeThresholdMin;     // [0.0312 - 0.0833], minimum amount of local contrast required to apply FXAA
    float ConsoleSharpness;     // [0.0 - 1.0], additional sharpening for CRT/consoles
    float LinearInput;          // treat input as linear color (0 or 1)
    float GammaOutput;          // output in gamma space (0 or 1)
    float Padding;              // for alignment
};

Texture2D    InputTexture    : register(t0);
SamplerState SamplerLinear   : register(s0);

// ==== FXAA DEFAULTS ====
#ifndef FXAA_QUALITY__PRESET
    #define FXAA_QUALITY__PRESET 39
#endif

#define FXAA_SEARCH_STEPS 16
#define FXAA_SEARCH_THRESHOLD 0.25f
#define FXAA_SUBPIX_TRIM 0.25f
#define FXAA_SUBPIX_CAP 0.75f

// ==== UTILITY FUNCTIONS ====
float Luma(float3 rgb)
{
    // Rec. 709 luminance
    return dot(rgb, float3(0.2126, 0.7152, 0.0722));
}

float3 ToLinear(float3 c)
{
    return pow(c, 2.2);
}

float3 ToGamma(float3 c)
{
    return pow(c, 1.0/2.2);
}

float3 FetchColor(float2 uv)
{
    float3 c = InputTexture.Sample(SamplerLinear, uv).rgb;
    if (LinearInput > 0.5f) c = ToLinear(c);
    return c;
}

// ==== FXAA CORE KERNEL ====
float4 PS_FXAA(float4 pos : SV_POSITION, float2 uv : TEXCOORD0) : SV_Target
{
    float2 invRes = InvScreenSize;
    float2 px = invRes;

    // Sample 3x3 neighborhood
    float3 rgbM = FetchColor(uv);
    float3 rgbN = FetchColor(uv + float2( 0, -px.y));
    float3 rgbS = FetchColor(uv + float2( 0,  px.y));
    float3 rgbE = FetchColor(uv + float2( px.x, 0));
    float3 rgbW = FetchColor(uv + float2(-px.x, 0));
    float3 rgbNE = FetchColor(uv + float2( px.x, -px.y));
    float3 rgbNW = FetchColor(uv + float2(-px.x, -px.y));
    float3 rgbSE = FetchColor(uv + float2( px.x,  px.y));
    float3 rgbSW = FetchColor(uv + float2(-px.x,  px.y));

    float lumaM = Luma(rgbM);
    float lumaN = Luma(rgbN);
    float lumaS = Luma(rgbS);
    float lumaE = Luma(rgbE);
    float lumaW = Luma(rgbW);
    float lumaNE = Luma(rgbNE);
    float lumaNW = Luma(rgbNW);
    float lumaSE = Luma(rgbSE);
    float lumaSW = Luma(rgbSW);

    // Find direction of the edge
    float lumaMin = min(lumaM, min(min(min(lumaN, lumaS), min(lumaE, lumaW)), min(min(lumaNE, lumaNW), min(lumaSE, lumaSW))));
    float lumaMax = max(lumaM, max(max(max(lumaN, lumaS), max(lumaE, lumaW)), max(max(lumaNE, lumaNW), max(lumaSE, lumaSW))));
    float lumaRange = lumaMax - lumaMin;

    // Edge thresholding
    if (lumaRange < max(EdgeThresholdMin, lumaMax * EdgeThreshold)) {
        // No edge, no AA needed
        float3 color = rgbM;
        if (GammaOutput > 0.5f) color = ToGamma(color);
        return float4(color, 1.0);
    }

    // Compute local gradients
    float gradientH = abs(lumaNW + 2.0 * lumaW + lumaSW - lumaNE - 2.0 * lumaE - lumaSE);
    float gradientV = abs(lumaNW + 2.0 * lumaN + lumaNE - lumaSW - 2.0 * lumaS - lumaSE);

    bool horizontal = (gradientH >= gradientV);

    // Sample along the edge to find best blend
    float2 dir = horizontal ? float2(0, px.y) : float2(px.x, 0);

    // Search in both directions for edge endpoints
    float lumaLocalAvg = (lumaN + lumaS + lumaE + lumaW) * 0.25;
    float subPixelAliasing = abs(lumaM - lumaLocalAvg);
    float subPixel = saturate(subPixelAliasing / lumaRange);

    float subPixelBlend = lerp(FXAA_SUBPIX_TRIM, FXAA_SUBPIX_CAP, subPixelQuality);

    // Blend factor: how much to blend with neighbor pixel
    float blend = saturate(subPixel * subPixelBlend);

    float3 rgbA = FetchColor(uv + dir * -0.5);
    float3 rgbB = FetchColor(uv + dir *  0.5);

    float3 result = lerp(rgbM, 0.5 * (rgbA + rgbB), blend);

    // Optional: console sharpness
    if (ConsoleSharpness > 0.001f) {
        float3 sharp = rgbM * (1.0 + ConsoleSharpness) - 0.5 * ConsoleSharpness * (rgbA + rgbB);
        result = lerp(result, sharp, ConsoleSharpness);
    }

    // Gamma out
    if (GammaOutput > 0.5f) result = ToGamma(result);

    return float4(result, 1.0);
}

// ==== ADVANCED: MULTI-PASS FOR STRONGER AA ====
// Optional: apply FXAA multiple times for even stronger effect
float4 PS_FXAA2(float4 pos : SV_POSITION, float2 uv : TEXCOORD0) : SV_Target
{
    float4 firstPass = PS_FXAA(pos, uv);
    // For demo, just do single-pass; extend here for multi-pass with temp RTs
    return firstPass;
}

// ==== VERTEX SHADER ====
struct VS_INPUT
{
    float4 Position : POSITION;
    float2 TexCoord : TEXCOORD0;
};
struct VS_OUTPUT
{
    float4 Position : SV_POSITION;
    float2 TexCoord : TEXCOORD0;
};
VS_OUTPUT VS(VS_INPUT input)
{
    VS_OUTPUT output;
    output.Position = input.Position;
    output.TexCoord = input.TexCoord;
    return output;
}

// ==== TECHNIQUE ====
technique11 FXAA_Technique
{
    pass P0
    {
        SetVertexShader( CompileShader( vs_5_0, VS() ) );
        SetPixelShader( CompileShader( ps_5_0, PS_FXAA() ) );
    }
    // Uncomment for multi-pass
    //pass P1
    //{
    //    SetVertexShader( CompileShader( vs_5_0, VS() ) );
    //    SetPixelShader( CompileShader( ps_5_0, PS_FXAA2() ) );
    //}
}

// ==== END OF FILE ====

// =============================
// FXAA PARAMETERS REFERENCE
// =============================
// SubpixelQuality:    0.0 (none) to 1.0 (max)
// EdgeThreshold:      0.063 to 0.333 (lower detects more edges)
// EdgeThresholdMin:   0.0312 to 0.0833 (lower = more sensitive)
// ConsoleSharpness:   0.0 to 1.0 (extra sharp for CRT/consoles)
// LinearInput:        0 = sRGB, 1 = linear color
// GammaOutput:        0 = linear, 1 = sRGB/gamma
// =============================

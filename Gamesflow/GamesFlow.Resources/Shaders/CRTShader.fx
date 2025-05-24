// CRTShader.fx - Massive CRT Shader for gamesflow-emulator-
// Simulates CRT display effects: scanlines, phosphor, curvature, color bleed, vignette, bloom, shadow mask, and more.
// Designed for HLSL/DirectX 11/12. Tweak constants for different CRT styles.

// === CONSTANTS AND PARAMETERS ===
cbuffer Matrices : register(b0)
{
    float4x4 World;
    float4x4 View;
    float4x4 Projection;
};

cbuffer FrameConstants : register(b1)
{
    float2 ScreenSize;          // {width, height}
    float2 InvScreenSize;       // 1.0/ScreenSize
    float2 InputSize;           // {width, height} of input (game image)
    float2 InvInputSize;        // 1.0/InputSize
    float2 OutputSize;          // {width, height} of final render target
    float2 InvOutputSize;       // 1.0/OutputSize
    float2 Time;                // {totalTime, frameTime}
    float2 Padding;
};

Texture2D    InputTexture    : register(t0);
SamplerState SamplerLinear   : register(s0);

// --- CRT Controls ---
#define PI 3.14159265359

// Scanline
float ScanlineIntensity = 0.7f;    // 0=off, 1=classic strong
float ScanlineThickness = 1.2f;

// Curvature
float CurvatureAmount = 0.12f;     // 0=flat, >0=curved
float2 CurvatureCenter = float2(0.5, 0.5);

// Shadow Mask / Slot Mask
float MaskStrength = 0.15f;        // 0=off, 1=full
float SlotWidth = 3.0f;            // RGB slots

// Color Bleed
float ColorBleed = 0.14f;

// Phosphor
float PhosphorGlow = 0.08f;
float PhosphorFade = 0.92f;

// Vignette
float VignetteStrength = 0.25f;

// Bloom
float BloomStrength = 0.18f;

// Barrel Distortion
float BarrelDistortion = 0.10f;

// --- PREPROCESSING STRUCTS ---
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
    output.Position = mul(input.Position, mul(World, mul(View,Projection)));
    output.TexCoord = input.TexCoord;
    return output;
}

// === UTILITY FUNCTIONS ===
float2 BarrelDistort(float2 coord, float amt)
{
    float2 cc = coord - 0.5;
    float dist = dot(cc, cc);
    return coord + cc * dist * amt;
}

float4 SampleInput(float2 uv)
{
    return InputTexture.Sample(SamplerLinear, uv);
}

// --- Shadow (Slot) Mask Pattern ---
float3 SlotMask(float2 uv)
{
    float mask = 1.0;
    float slot = frac(uv.x * ScreenSize.x / SlotWidth);
    mask = lerp(1.0, 0.6, (slot < 0.33) ? 1 : (slot < 0.66) ? 0.5 : 0.0);
    // RGB stripes
    float3 rgbMask = float3(mask, 1.0 - mask, mask*0.7);
    return lerp(float3(1,1,1), rgbMask, MaskStrength);
}

// --- Scanline Effect ---
float Scanline(float y)
{
    float f = frac(y * ScreenSize.y);
    return lerp(1.0, 1.0 - ScanlineIntensity, pow(sin(PI * f) * 0.5 + 0.5, ScanlineThickness));
}

// --- Vignette ---
float Vignette(float2 uv)
{
    float2 d = uv - 0.5;
    float vign = 1.0 - VignetteStrength * dot(d, d) * 4.0;
    return saturate(vign);
}

// --- Bloom (simplified) ---
float4 ApplyBloom(float2 uv)
{
    float4 color = 0.0;
    float total = 0;
    float radius = 2.0 / ScreenSize.x;
    for (int i = -2; i <= 2; i++)
    {
        for (int j = -2; j <= 2; j++)
        {
            float2 offset = float2(i, j) * radius;
            color += SampleInput(uv + offset);
            total += 1.0;
        }
    }
    return color / total;
}

// --- Color Bleed ---
float3 BleedColors(float2 uv)
{
    float3 col = SampleInput(uv).rgb;
    float3 right = SampleInput(uv + float2(1.0 / ScreenSize.x, 0)).rgb;
    float3 down = SampleInput(uv + float2(0, 1.0 / ScreenSize.y)).rgb;
    return lerp(col, 0.5 * (right + down), ColorBleed);
}

// --- Phosphor Glow ---
float3 Phosphor(float3 color)
{
    return lerp(color, float3(1,1,1), PhosphorGlow) * PhosphorFade;
}

// === MAIN PIXEL SHADER ===
float4 PS(VS_OUTPUT input) : SV_Target
{
    float2 uv = input.TexCoord;

    // Barrel distortion
    uv = BarrelDistort(uv, BarrelDistortion);

    // Clamp to screen
    if (uv.x < 0 || uv.x > 1 || uv.y < 0 || uv.y > 1)
        return float4(0,0,0,1);

    // Color bleed + phosphor
    float3 color = BleedColors(uv);
    color = Phosphor(color);

    // Scanline
    color *= Scanline(uv.y);

    // Shadow mask
    color *= SlotMask(uv);

    // Vignette
    color *= Vignette(uv);

    // Bloom
    float3 bloom = ApplyBloom(uv).rgb * BloomStrength;
    color = saturate(color + bloom);

    return float4(color, 1.0);
}

// === TECHNIQUE DEFINITION ===
technique11 CRT_Technique
{
    pass P0
    {
        SetVertexShader( CompileShader( vs_5_0, VS() ) );
        SetPixelShader( CompileShader( ps_5_0, PS() ) );
    }
}

// === END OF FILE ===

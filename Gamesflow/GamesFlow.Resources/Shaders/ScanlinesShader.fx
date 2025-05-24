// ScanlinesShader.fx - Massive Scanlines Shader for gamesflow-emulator-
// Simulates CRT scanline effects: horizontal/vertical scanlines, variable intensity, color modulation, bloom, phosphor, rolling scan, and advanced options.
// Designed for DirectX 11/12 (HLSL). Highly configurable for classic and modern CRT looks.

// =====================
// CONSTANTS & PARAMETERS
// =====================
cbuffer ScanlineParams : register(b0)
{
    float2 ScreenSize;        // {width, height}
    float2 InvScreenSize;     // 1.0/ScreenSize
    float2 InputSize;         // {width, height} of source image
    float2 InvInputSize;      // 1.0/InputSize
    float2 OutputSize;        // {width, height} of output
    float2 InvOutputSize;     // 1.0/OutputSize
    float2 Time;              // {totalTime, deltaTime}
    float2 Padding;

    // Scanline Parameters
    float ScanlineIntensity;    // Strength of scanlines [0-1]
    float ScanlineBrightness;   // Controls brightness of scanlines [0.5-2.0]
    float ScanlineThickness;    // Controls thickness [0.5-2.0]
    float ScanlineSoftness;     // Softness of scanlines [0-1]
    float ScanlineJitter;       // Amount of scanline jitter [0-1]
    float VerticalScanlines;    // 1=vertical, 0=off
    float VerticalIntensity;    // Strength of vertical scanlines
    float VerticalThickness;    // Thickness of vertical scanlines

    // Advanced
    float RGBSplit;             // Simulate slight color channel offset
    float RollingScanSpeed;     // Rolling scan effect speed (Hz)
    float RollingScanHeight;    // Height of scan beam [0-1]
    float PhosphorGlow;         // Phosphor bloom/glow
    float NoiseAmount;          // Adds TV noise [0-1]
    float ColorBoost;           // Boosts color vibrance [1-2]
    float3 ScanlineColor;       // Tint for scanlines (e.g. for green/amber CRTs)
}

// ===========
// SAMPLERS
// ===========
Texture2D    InputTexture    : register(t0);
SamplerState SamplerLinear   : register(s0);

// ==========
// STRUCTS
// ==========
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

// ==========
// VERTEX SHADER
// ==========
VS_OUTPUT VS(VS_INPUT input)
{
    VS_OUTPUT output;
    output.Position = input.Position;
    output.TexCoord = input.TexCoord;
    return output;
}

// ==========
// UTILITY FUNCTIONS
// ==========
float Noise(float2 uv)
{
    float n = sin(dot(uv * ScreenSize.xy, float2(12.9898, 78.233))) * 43758.5453;
    return frac(n);
}

float3 RGBChannelSplit(Texture2D tex, SamplerState samp, float2 uv, float split)
{
    float offset = split / ScreenSize.x;
    float3 color;
    color.r = tex.Sample(samp, uv + float2(-offset, 0)).r;
    color.g = tex.Sample(samp, uv).g;
    color.b = tex.Sample(samp, uv + float2(offset, 0)).b;
    return color;
}

// ==========
// SCANLINE FUNCTIONS
// ==========

// Horizontal scanlines
float HorizontalScan(float y, float time)
{
    float base = frac(y * ScreenSize.y);
    float phase = sin((y + time) * 6.2831853);
    float scan = 1.0 - ScanlineIntensity * pow(sin(PI * base), ScanlineThickness) * ScanlineBrightness;
    scan = lerp(scan, scan * (1.0 - ScanlineJitter * (Noise(float2(y, time)) - 0.5)), ScanlineSoftness);
    return scan;
}

// Vertical scanlines
float VerticalScan(float x)
{
    float base = frac(x * ScreenSize.x);
    float scan = 1.0 - VerticalIntensity * pow(sin(PI * base), VerticalThickness);
    return scan;
}

// Rolling scan (simulates scanning beam going down screen, like TVs powering up)
float RollingScan(float y, float time)
{
    float rollPos = fmod(time * RollingScanSpeed, 1.0);
    float scanY = y;
    float beam = smoothstep(rollPos, rollPos + RollingScanHeight, scanY);
    return lerp(1.0, 0.7, beam);
}

// Phosphor glow (bloomish effect)
float3 Phosphor(float3 color, float2 uv)
{
    float radius = 2.5 / ScreenSize.x;
    float3 glow = 0;
    float total = 0;
    for (int dx = -2; dx <= 2; dx++)
    for (int dy = -2; dy <= 2; dy++)
    {
        float2 offset = float2(dx, dy) * radius;
        glow += InputTexture.Sample(SamplerLinear, uv + offset).rgb;
        total += 1.0;
    }
    glow /= total;
    return lerp(color, glow, PhosphorGlow);
}

// ==========
// MAIN PIXEL SHADER
// ==========
float4 PS(VS_OUTPUT input) : SV_Target
{
    float2 uv = input.TexCoord;
    float2 screenUV = uv * ScreenSize.xy / OutputSize.xy;

    // Rolling scan beam
    float rolling = RollingScan(uv.y, Time.x);

    // RGB channel split
    float3 color = RGBChannelSplit(InputTexture, SamplerLinear, uv, RGBSplit);

    // Phosphor glow
    color = Phosphor(color, uv);

    // Add TV noise
    if (NoiseAmount > 0.0)
        color += (Noise(uv + Time.xy) - 0.5) * NoiseAmount;

    // Apply scanlines (horizontal)
    float scanH = HorizontalScan(uv.y, Time.x);
    color *= lerp(1.0, scanH, ScanlineIntensity);

    // Apply vertical scanlines if enabled
    if (VerticalScanlines > 0.5)
    {
        float scanV = VerticalScan(uv.x);
        color *= lerp(1.0, scanV, VerticalIntensity);
    }

    // Multiply rolling scan effect
    color *= rolling;

    // Color vibrance boost
    color = pow(color, float3(1.0 / ColorBoost, 1.0 / ColorBoost, 1.0 / ColorBoost));

    // Tint with scanline color (for green/amber CRTs, or leave white for RGB)
    color = lerp(color, color * ScanlineColor, 0.25);

    // Clamp
    color = saturate(color);

    return float4(color, 1.0);
}

// ==========
// TECHNIQUE
// ==========
technique11 Scanlines_Technique
{
    pass P0
    {
        SetVertexShader( CompileShader( vs_5_0, VS() ) );
        SetPixelShader( CompileShader( ps_5_0, PS() ) );
    }
}

// =====================
// PARAMETER SUGGESTIONS
// =====================
// ScanlineIntensity   = 0.7   // CRT TV: 0.5-0.8, PVM: 0.2-0.5
// ScanlineBrightness  = 1.1
// ScanlineThickness   = 1.4
// ScanlineSoftness    = 0.5
// ScanlineJitter      = 0.03
// VerticalScanlines   = 1.0
// VerticalIntensity   = 0.10
// VerticalThickness   = 1.6
// RGBSplit            = 0.003
// RollingScanSpeed    = 0.5
// RollingScanHeight   = 0.03
// PhosphorGlow        = 0.07
// NoiseAmount         = 0.03
// ColorBoost          = 1.2
// ScanlineColor       = float3(1,1,1) (white) or float3(0.7,1,0.7) (green CRT)
// =====================

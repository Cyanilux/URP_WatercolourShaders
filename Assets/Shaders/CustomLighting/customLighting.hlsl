#ifndef CUSTOM_LIGHTING_INCLUDED
#define CUSTOM_LIGHTING_INCLUDED

void MainLight_float (float3 WorldPos, out float3 Direction, out float3 Color,
	out float DistanceAtten, out float ShadowAtten){

#ifdef SHADERGRAPH_PREVIEW
	Direction = normalize(float3(1,1,-0.4));
	Color = float4(1,1,1,1);
	DistanceAtten = 1;
	ShadowAtten = 1;
#else
	float4 shadowCoord = TransformWorldToShadowCoord(WorldPos);
	Light mainLight = GetMainLight(shadowCoord);

	Direction = mainLight.direction;
	Color = mainLight.color;
	DistanceAtten = mainLight.distanceAttenuation;
	ShadowAtten = mainLight.shadowAttenuation;
#endif

}

// Alternative method, which bypasses keywords
void MainLightShadows_float (float3 WorldPos, out float3 Direction, out float3 Color,
	out float DistanceAtten, out float ShadowAtten){

#ifdef SHADERGRAPH_PREVIEW
	Direction = normalize(float3(1,1,-0.4));
	Color = float4(1,1,1,1);
	DistanceAtten = 1;
	ShadowAtten = 1;
#else
	Light mainLight = GetMainLight();
	Direction = mainLight.direction;
	Color = mainLight.color;
	DistanceAtten = mainLight.distanceAttenuation;

	float4 shadowCoord = TransformWorldToShadowCoord(WorldPos);
	// or if cascades are needed :
	// half cascadeIndex = ComputeCascadeIndex(WorldPos);
	// float4 shadowCoord = mul(_MainLightWorldToShadow[cascadeIndex], float4(WorldPos, 1.0));

	ShadowSamplingData shadowSamplingData = GetMainLightShadowSamplingData();
	float shadowStrength = GetMainLightShadowStrength();
	ShadowAtten = SampleShadowmap(shadowCoord, TEXTURE2D_ARGS(_MainLightShadowmapTexture, sampler_MainLightShadowmapTexture), shadowSamplingData, shadowStrength, false);
#endif
}

#endif // CUSTOM_LIGHTING_INCLUDED
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Sprites/Outline"
{
    Properties
    {
        [PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}
        _Color ("Tint", Color) = (1,1,1,1)
        [MaterialToggle] PixelSnap ("Pixel snap", Float) = 0

        // Add values to determine if outlining is enabled and outline color.
        [PerRendererData] _OutlineSize ("Outline", Float) = 0
        [PerRendererData] _OutlineColor("Outline Color", Color) = (1,1,1,1)
    }

    CGINCLUDE
    #include "UnityCG.cginc"

    struct appdata_t
    {
        float4 vertex   : POSITION;
        float4 color    : COLOR;
        float2 texcoord : TEXCOORD0;
    };

    struct v2f
    {
        float4 vertex   : SV_POSITION;
        fixed4 color    : COLOR;
        float2 texcoord  : TEXCOORD0;
    };
    fixed4 _Color;

    v2f vert_outline(appdata_t IN)
    {
        v2f OUT;
        OUT.vertex = UnityObjectToClipPos(IN.vertex);
        OUT.texcoord = IN.texcoord;
        OUT.color = IN.color * _Color;
        #ifdef PIXELSNAP_ON
        OUT.vertex = UnityPixelSnap (OUT.vertex);
        #endif

        return OUT;
    }

   	sampler2D _MainTex;
    sampler2D _AlphaTex;

    float4 _MainTex_TexelSize; //magic var
    float _OutlineSize; //outline size
    fixed4 _OutlineColor; // outlie color

    fixed4 SampleSpriteTexture (float2 uv)
    {
        fixed4 color = tex2D (_MainTex, uv);
        return color;
    }

	ENDCG

    SubShader
    {
        Tags
        {
            "Queue"="Transparent"
            "IgnoreProjector"="True"
            "RenderType"="Transparent"
            "PreviewType"="Plane"
            "CanUseSpriteAtlas"="True"
        }

        Cull Off
        Lighting Off
        ZWrite Off
        Blend One OneMinusSrcAlpha

        //outline down
        Pass
        {
       		Offset 1, 1

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile _ PIXELSNAP_ON
            #pragma shader_feature ETC1_EXTERNAL_ALPHA

            v2f vert(appdata_t IN)
            {
            	return vert_outline(IN);
            }

            fixed4 frag(v2f IN) : SV_Target
            {
               	fixed4 texColor = SampleSpriteTexture (IN.texcoord + fixed2(0,_MainTex_TexelSize.y*_OutlineSize)) * IN.color;
               	fixed4 c = _OutlineColor * texColor.a;
                return c;
            }
            ENDCG
        }

        //outline up
        Pass
        {
       		Offset 1, 1

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile _ PIXELSNAP_ON
            #pragma shader_feature ETC1_EXTERNAL_ALPHA

            v2f vert(appdata_t IN)
            {
            	return vert_outline(IN);
            }

            fixed4 frag(v2f IN) : SV_Target
            {

               	fixed4 texColor = SampleSpriteTexture (IN.texcoord + fixed2(0,- _MainTex_TexelSize.y* _OutlineSize)) * IN.color;
               	fixed4 c = _OutlineColor * texColor.a;
                return c;
            }
            ENDCG
        }

        //outline left
        Pass
        {
       		Offset 1, 1

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile _ PIXELSNAP_ON
            #pragma shader_feature ETC1_EXTERNAL_ALPHA

            v2f vert(appdata_t IN)
            {
            	return vert_outline(IN);
            }

            fixed4 frag(v2f IN) : SV_Target
            {

               	fixed4 texColor = SampleSpriteTexture (IN.texcoord + fixed2(_MainTex_TexelSize.x* _OutlineSize,0)) * IN.color;
               	fixed4 c = _OutlineColor * texColor.a;
                return c;
            }
            ENDCG
        }

        //outline right
        Pass
        {
       		Offset 1, 1

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile _ PIXELSNAP_ON
            #pragma shader_feature ETC1_EXTERNAL_ALPHA

            v2f vert(appdata_t IN)
            {
            	return vert_outline(IN);
            }

            fixed4 frag(v2f IN) : SV_Target
            {

               	fixed4 texColor = SampleSpriteTexture (IN.texcoord + fixed2(-_MainTex_TexelSize.x* _OutlineSize,0)) * IN.color;
               	fixed4 c = _OutlineColor * texColor.a;
                return c;
            }
            ENDCG
        }
//
        Pass
        {
        	Offset 0, 0

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile _ PIXELSNAP_ON
            #pragma shader_feature ETC1_EXTERNAL_ALPHA

            v2f vert(appdata_t IN)
            {
                v2f OUT;
                OUT.vertex = UnityObjectToClipPos(IN.vertex);
                OUT.texcoord = IN.texcoord;
                OUT.color = IN.color * _Color;
                #ifdef PIXELSNAP_ON
                OUT.vertex = UnityPixelSnap (OUT.vertex);
                #endif

                return OUT;
            }


            fixed4 frag(v2f IN) : SV_Target
            {
                fixed4 c = SampleSpriteTexture (IN.texcoord) * IN.color;
                c.rgb *= c.a;
                return c;
            }
            ENDCG
        }
    }
}
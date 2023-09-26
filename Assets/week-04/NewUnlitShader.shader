Shader "Unlit/NewUnlitShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Color("Color", color) = (1,1,1,1)
        _CalcOption ("CalcOption", Range(1, 3)) = 1

    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"


            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            uniform float4 _Color;
            uniform float _CalcOption;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                float4 color = _Color;


                switch(int(round(_CalcOption)))
                {
                    case 1:
                        col.rgb += color;
                        break;
                    case 2:
                        col.rgb -= color;
                        break;
                    case 3:
                        col.rgb *= color;
                        break;
                }
                return col;
                //sreturn col * color;
                // Add makes the colors lighter as it is values getting higher
                // Subtract makes the colors more inverse, as you are removing colors from
                // Multiplication makes the texture be based on the defined color
            }
            ENDCG
        }
    }
}

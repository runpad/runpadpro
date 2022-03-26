
#ifndef __CORE_GFX_H__
#define __CORE_GFX_H__



void ApplyCornerEffect(CLayer &layer);
CLayer32* CreateSheetShadowLayer(int sheet_width,int sheet_height,int smooth,BYTE alpha);
CLayer32* CreateLighterLayer(int width,int height,int color,float alpha_k);



#endif

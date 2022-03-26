

function  Z_Compress(const src:pointer; src_size:cardinal; _dest_size:pcardinal):pointer cdecl; external 'z_dll.dll';
function  Z_Decompress(const src:pointer; src_size:cardinal; _dest_size:pcardinal):pointer cdecl; external 'z_dll.dll';
procedure Z_Free(buff:pointer) cdecl; external 'z_dll.dll';
function Z_CRC32(const buff:pointer; size:cardinal):cardinal cdecl; external 'z_dll.dll';



APP=rs_api

CC = cl
CFLAGS = /nologo /MT /W3 /O1 /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /D "_MBCS" /D "_USRDLL" /D "_ATL_STATIC_REGISTRY"
LFLAGS = -Fe$(APP) -nologo -LD
LOPT = -link /MACHINE:X86 /DEF:$(APP).def

OBJS = rs_api.obj runpadshell.obj runpadshell2.obj runpadproshell.obj impl.obj utils.obj resource.res
LIBS = kernel32.lib user32.lib advapi32.lib ole32.lib uuid.lib shlwapi.lib shell32.lib

type_lib:
         midl /nologo /tlb $(APP).tlb /h $(APP).h /iid $(APP)_i.c /Oicf $(APP).idl >nul

res_make:
         rc /nologo resource.rc

$(APP).dll: $(OBJS)
         $(CC) $(LFLAGS) $(OBJS) $(LOPT) $(LIBS)

delphi:
       tlibimp -Dexamples\include $(APP).tlb

clean: 
       if exist $(APP)_i.c move /Y $(APP)_i.c "examples\include\"
       if exist $(APP).h move /Y $(APP).h "examples\include\"
       if exist *.obj del *.obj
       if exist *.res del *.res
       if exist *.exp del *.exp
       if exist *.lib del *.lib
       if exist *.tlb del *.tlb
       if exist examples\include\*.dcr del /Q examples\include\*.dcr
       if exist dlldata.c del dlldata.c
       if exist $(APP)_p.c del $(APP)_p.c


all: type_lib res_make $(APP).dll delphi clean


.cpp.obj:
        $(CC) $(CFLAGS) -c $<

rs_api.obj	   : rs_api.cpp
runpadshell.obj	   : runpadshell.cpp
runpadshell2.obj   : runpadshell2.cpp
runpadproshell.obj : runpadproshell.cpp
impl.obj	   : impl.cpp
utils.obj	   : utils.cpp



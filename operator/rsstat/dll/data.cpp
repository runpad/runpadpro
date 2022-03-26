#include <Windows.h>
#include <Shlwapi.h>
#include "stat.h"
#include <vector>
#include <fstream>
#include <algorithm>

#ifdef STAT_USE_HASH_MAPS
#include "hash_bob_jankins.h"
#include <hash_map>
#else
#include <map>
#endif

#include <assert.h>


using namespace std;


#include "sys.c"


//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Configuration variables
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
static DATE BeginDate = 0;
static DATE EndDate = 0;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Data structure classes
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
class CstatMachine;
class CstatSheet;
class CstatShortcut;

class C_statRating
{
public:
	C_statRating(const C_statRating &p) { machine = p.machine; date = p.date; midlevel = p.midlevel; data.clear(); data.insert(data.end(), p.data.begin(), p.data.end()); };
	C_statRating() { machine = 0; date = 0; midlevel = 0; };
	void Update(); // Recalculates midlevel

	// Data items
	CstatMachine *machine;
	DATE date;
	vector<float> data;
	// Cache items
	float midlevel;
};


class CstatItem
{
protected:
	CstatItem(){};
public:
	CstatItem(const CstatItem& p) { *this = p; };
	CstatItem(const char* _caption) { caption = new char[lstrlen(_caption)+1]; lstrcpy(caption, _caption); active = false; };
	~CstatItem() { delete[] caption; };
	CstatItem& operator=(const CstatItem& p);
	virtual int Type() { return 0; };
	// Data items
	char *caption;
	// Cache items
	bool active; // use statItem to show statistics. Incapsulates check-boxes
	virtual const bool Active() { return active; };
	// Recognize functions
	virtual const COLOR Color() = 0;
	virtual const HICON Icon() = 0;
	virtual const float Midlevel() = 0;
	virtual const C_statRating* MidlevelRaw() = 0;
};


class CstatSheet : public CstatItem
{
public:
	CstatSheet(const CstatSheet& p) { *this = p; };
	CstatSheet(const char* _caption) : CstatItem(_caption) { color = 0; icon = 0; };
	~CstatSheet() {};
	CstatSheet& operator=(const CstatSheet& p);

	virtual int Type() { return ST_TYPE_SHEET; };
	void Update(); // Recalculates midlevel
	void UpdateCacheLinks(); // Link to color and icon, if present

	// Data items
	COLOR color;
	HICON icon;
	// Cache items
	vector<CstatShortcut*> shortcuts;
	C_statRating midlevel;
	// Recognize functions
	const COLOR Color() { return color; };
	const HICON Icon() { return icon; };
	const float Midlevel() { return midlevel.midlevel; };
	const C_statRating* MidlevelRaw() { return &midlevel; };
};


class CstatShortcut : public CstatItem
{
public:
	CstatShortcut(const CstatShortcut& p) { *this = p; };
	CstatShortcut(const char* _caption) : CstatItem(_caption) { icon = 0; sheet = 0; };
	~CstatShortcut() {};
	CstatShortcut& operator=(const CstatShortcut& p);

	virtual int Type() { return ST_TYPE_SHORTCUT; };
	void Update(); // Recalculates midlevel
	void UpdateCacheLinks(); // Link to icon, if present

	// Data items
	vector<C_statRating> ratings;
	HICON icon;
	CstatSheet *sheet;
	// Cache items
	C_statRating midlevel;
	virtual const bool Active() { return active ? active : sheet->active; };
	// Recognize functions
	const COLOR Color() { return sheet->color; };
	const HICON Icon() { return icon ? icon : sheet->Icon(); };
	const float Midlevel() { return midlevel.midlevel; };
	const C_statRating* MidlevelRaw() { return &midlevel; };
};


class CstatMachine : public CstatItem
{
public:
	CstatMachine(const CstatMachine& p) { *this = p; };
	CstatMachine(const char* _caption) : CstatItem(_caption) { ip = 0; };
	~CstatMachine() {};
	CstatMachine& operator=(const CstatMachine& p);
	virtual int Type() { return ST_TYPE_MACHINE; };
	// Data items
	int ip;
	// Cache items
	// Recognize functions
	const COLOR Color() { return 0; };
	const HICON Icon() { return 0; };
	const float Midlevel() { return 0; };
	const C_statRating* MidlevelRaw() { return NULL; };
};


//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Data caches
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#ifdef STAT_USE_HASH_MAPS
struct eqstr
{
	bool operator()(const char* s1, const char* s2) const
	{
		return strcmp(s1, s2) == 0;
	}
};

struct hfctico
{
	size_t operator()(const char* s1) const
	{
		unsigned *isize = (unsigned*)s1;
		unsigned char *buf = (unsigned char*)s1+4;
		size_t result = (size_t)CalculateHashFunction(buf, *isize, 0);
		return result;
	}
};

struct eqico
{
	bool operator()(const char* s1, const char* s2) const
	{
		int *size1 = (int*)s1;
		int *size2 = (int*)s2;
		if (*size1 != *size2)
			return false;
		for (int i = 0; i<*size1; i++)
			if (s1[i+4] != s2[i+4])
				return false;
		return true;
	}
};

#else

struct ltstr
{
	bool operator()(const char* s1, const char* s2) const
	{
		return strcmp(s1, s2) < 0;
	}
};

struct ltico
{
	bool operator()(const char* s1, const char* s2) const
	{
		int *size1 = (int*)s1;
		int *size2 = (int*)s2;
		if (*size1 != *size2)
			return *size1 < *size2;
		for (int i = 0; i<*size1; i++)
			if (s1[i+4] != s2[i+4])
				return s1[i+4] < s2[i+4];
		return false;
	}
};
#endif

#ifdef STAT_USE_HASH_MAPS
typedef hash_map<char*, COLOR, hash<const char*>, eqstr> COLORS_CACHE;
typedef hash_map<char*, HICON, hash<const char*>, eqstr> ICONS_CACHE;
typedef hash_map<char*, HICON, hfctico, eqico> ICONS_SHARE;
#else
typedef map<char*, COLOR, ltstr> COLORS_CACHE;
typedef map<char*, HICON, ltstr> ICONS_CACHE;
typedef map<char*, HICON, ltico> ICONS_SHARE;
#endif

static COLORS_CACHE colors_cache;
static ICONS_CACHE icons_cache;
static ICONS_SHARE icons_share;


//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Data structure functions
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


CstatItem& CstatItem::operator=(const CstatItem& p)
{ 
	caption = new char[lstrlen(p.caption)+1];
	lstrcpy(caption, p.caption);
	active = p.active;
	return *this;
};

CstatSheet& CstatSheet::operator=(const CstatSheet& p)
{
	color = p.color;
	icon = p.icon;
	shortcuts.clear();
	shortcuts.insert(shortcuts.end(), p.shortcuts.begin(), p.shortcuts.end());
	CstatItem::operator=(p);
	return *this;
};

CstatShortcut& CstatShortcut::operator=(const CstatShortcut& p)
{
	icon = p.icon;
	sheet = p.sheet;
	ratings.clear();
	ratings.insert(ratings.end(), p.ratings.begin(), p.ratings.end());
	midlevel = p.midlevel;
	CstatItem::operator=(p);
	return *this;
};

CstatMachine& CstatMachine::operator=(const CstatMachine& p)
{
	ip = p.ip;
	CstatItem::operator=(p);
	return *this;
};


void C_statRating::Update()
{
	midlevel = 0;

	if (EndDate < BeginDate)
	{
		DATE SwapDate = EndDate;
		EndDate = BeginDate;
		BeginDate = SwapDate;
	}

	int date_offset = 0;
	int date_stop_i = 0;

	if (!(BeginDate | EndDate))
	{
		date_offset = 0;
		date_stop_i = data.size();
	}
	else
	{
		date_offset = BeginDate - date;
		date_stop_i = date_offset + EndDate - BeginDate + 1;
		if (date_offset<0)
			date_offset = 0;
		if (date_stop_i<0)
			return; // midlevel = 0;
	}


	if (data.size() <= date_offset)
		return;

	vector<float>::iterator it = data.begin() + date_offset;
	for (int i = 0; i < date_stop_i && it < data.end(); i++, it++ )
		midlevel += *it;

	midlevel /= date_stop_i - date_offset + 1;
}


void CstatSheet::Update()
{
	UpdateCacheLinks();

	int size = 0;

	midlevel.machine = NULL;
	midlevel.data.clear();
	midlevel.date = 0;
	if (shortcuts.size() == 0)
	{
		midlevel.Update();
		return;
	}
	
	vector<CstatShortcut*>::iterator it;
	for (it = shortcuts.begin(); it < shortcuts.end(); it++ )
		if ((*it)->midlevel.date)
		{
			midlevel.date = (*it)->midlevel.date;
			break;
		}

	for (it = shortcuts.begin(); it < shortcuts.end(); it++ )
	{
		if ((*it)->midlevel.date)
		{
			if ((*it)->midlevel.date < midlevel.date)
				midlevel.date = (*it)->midlevel.date;
		}
	}

	for (it = shortcuts.begin(); it < shortcuts.end(); it++ )
	{
		if ((*it)->midlevel.date)
		{
			int new_size = (*it)->midlevel.data.size()+((*it)->midlevel.date - midlevel.date);
			if (new_size > size)
				size = new_size;
		}
	}
	
	if (size == 0)
	{
		midlevel.Update();
		return;
	}

	vector<int> weights;
	weights.resize(size, 0);
	midlevel.data.resize(size, 0);
	
	for (it = shortcuts.begin(); it < shortcuts.end(); it++)
	{
		if ((*it)->midlevel.date)
		{
			int j = (*it)->midlevel.date - midlevel.date;
			for (int i = 0; i < (*it)->midlevel.data.size(); i++, j++)
			{
				midlevel.data[j] = (midlevel.data[j]*weights[j] + (*it)->midlevel.data[i])/(weights[j] + 1);
				weights[j]++;
			}
		}
	}

	midlevel.Update();
}


void CstatShortcut::Update()
{
	UpdateCacheLinks();

	int size = 0;

	midlevel.machine = NULL;
	midlevel.data.clear();
	midlevel.date = 0;
	if (ratings.size() == 0)
	{
		midlevel.Update();
		return;
	}
	
	vector<C_statRating>::iterator it;

	for (it = ratings.begin(); it < ratings.end(); it++ )
		if (it->machine->active)
		{
			midlevel.date = it->date;
			break;
		}

	for (it = ratings.begin(); it < ratings.end(); it++ )
		if (it->machine->active)
		{
			if (it->date < midlevel.date)
				midlevel.date = it->date;
		}

	for (it = ratings.begin(); it < ratings.end(); it++ )
		if (it->machine->active)
		{
			int new_size = it->data.size()+(it->date - midlevel.date);
			if (new_size > size)
				size = new_size;
		}
	
	if (size == 0)
	{
		midlevel.Update();
		return;
	}

	vector<int> weights;
	weights.resize(size, 0);
	midlevel.data.resize(size, 0);
	
	for (it = ratings.begin(); it < ratings.end(); it++)
		if (it->machine->active)
		{
			int j = it->date - midlevel.date;
			for (int i = 0; i<it->data.size(); i++, j++)
			{
				midlevel.data[j] = (midlevel.data[j]*weights[j] + it->data[i])/(weights[j] + 1);
				weights[j]++;
			}
		}

	midlevel.Update();
}


void CstatSheet::UpdateCacheLinks()
{
	// Search for color
	COLORS_CACHE::iterator it = colors_cache.find(caption);
	if (it != colors_cache.end())
		color = it->second;
	else
		color = 0x00FFFFFF;
}


void CstatShortcut::UpdateCacheLinks()
{
	// Search for icon
	char *composite_caption = new char[lstrlen(caption)+lstrlen(sheet->caption)+2];
	lstrcpy(composite_caption, sheet->caption);
	lstrcat(composite_caption, "\\");
	lstrcat(composite_caption, caption);
	ICONS_CACHE::iterator it = icons_cache.find(composite_caption);
	if (it != icons_cache.end())
		icon = it->second;
	else
		icon = NULL;
	delete[] composite_caption;
}


//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Data structures
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
static vector<CstatMachine*> machines;
static vector<CstatSheet*> sheets;
static vector<CstatShortcut*> shortcuts;

static vector<CstatItem*> sort_tree;
static vector<CstatItem*> sheet_ptrs;

static int emode;
static int esort;
static vector<CstatItem*> *ecollection; // enumerator
static CstatItem* ep;
static vector<CstatItem*>::iterator e; // enumerator
static vector<CstatMachine*>::iterator em; // enumerator for machines

void AddToSortTree(CstatShortcut* shortcut);

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Functors for data structures
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

struct statitem_less_a
{
	bool operator()(const CstatItem* sh1, const CstatItem* sh2)
		{ return lstrcmpi(sh1->caption, sh2->caption) < 0; };
};

struct statitem_less_r
{
	bool operator()(const CstatItem* sh1, const CstatItem* sh2)
		{ return const_cast<CstatItem*>(sh1)->Midlevel() > const_cast<CstatItem*>(sh2)->Midlevel(); };
};

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// DLL interface functions
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

extern "C" __declspec(dllexport) void* __cdecl st_Clean()
{
	for (vector<CstatMachine*>::iterator it = machines.begin(); it<machines.end(); it++)
		delete *it;
	for (vector<CstatSheet*>::iterator it = sheets.begin(); it<sheets.end(); it++)
		delete *it;
	for (vector<CstatShortcut*>::iterator it = shortcuts.begin(); it<shortcuts.end(); it++)
		delete *it;
	machines.clear();
	sheets.clear();
	shortcuts.clear();

	for (COLORS_CACHE::iterator it = colors_cache.begin(); it != colors_cache.end(); it++)
		delete it->first;
	for (ICONS_CACHE::iterator it = icons_cache.begin(); it != icons_cache.end(); it++)
		delete it->first;
	for (ICONS_SHARE::iterator it = icons_share.begin(); it != icons_share.end(); it++)
	{
		sys_free(it->first);
		DestroyIcon(it->second);
	}
	icons_share.clear();
	colors_cache.clear();
	icons_cache.clear();

	sort_tree.clear();

	return 0;
}

extern "C" __declspec(dllexport) void* __cdecl st_Update()
{
	for (vector<CstatShortcut*>::iterator it = shortcuts.begin(); it<shortcuts.end(); it++)
		(*it)->Update();
	for (vector<CstatSheet*>::iterator it = sheets.begin(); it<sheets.end(); it++)
		(*it)->Update();
	return 0;
}

extern "C" __declspec(dllexport) void* __cdecl st_SetBeginDate(DATE date)
{
	BeginDate = date;
	return 0;
}

extern "C" __declspec(dllexport) void* __cdecl st_SetEndDate(DATE date)
{
	EndDate = date;
	return 0;
}

extern "C" __declspec(dllexport) char* __cdecl st_GetItName(void *handle)
{
	return ((CstatItem*)handle)->caption;
}

extern "C" __declspec(dllexport) int __cdecl st_GetItColor(void *handle)
{
	return ((CstatItem*)handle)->Color();
}

extern "C" __declspec(dllexport) HICON __cdecl st_GetItIcon(void *handle)
{
	return ((CstatItem*)handle)->Icon();
}

extern "C" __declspec(dllexport) int __cdecl st_GetItType(void *handle)
{
	return ((CstatItem*)handle)->Type();
}

extern "C" __declspec(dllexport) float __cdecl st_GetItMidlevel(void *handle)
{
	return ((CstatItem*)handle)->Midlevel();
}

extern "C" __declspec(dllexport) DATE __cdecl st_GetItDate(void *handle)
{
	return ((CstatItem*)handle)->MidlevelRaw()->date;
}

extern "C" __declspec(dllexport) int __cdecl st_GetItRawLen(void *handle)
{
	return ((CstatItem*)handle)->MidlevelRaw()->data.size();
}

extern "C" __declspec(dllexport) float __cdecl st_GetItRawItem(void *handle, int i)
{
	return ((CstatItem*)handle)->MidlevelRaw()->data[i];
}

extern "C" __declspec(dllexport) void* __cdecl st_GetItSheet(void *handle)
{
	return ((CstatShortcut*)handle)->sheet;
}

extern "C" __declspec(dllexport) int __cdecl st_GetItActive(void *handle)
{
	return ((CstatItem*)handle)->active;
}

extern "C" __declspec(dllexport) int __cdecl st_SetItActive(void *handle, int active)
{
	((CstatItem*)handle)->active = active;
	return 0;
}

extern "C" __declspec(dllexport) int __cdecl st_SetItChildrenActive(void *handle, int active)
{
	for (vector<CstatShortcut*>::iterator it = ((CstatSheet*)handle)->shortcuts.begin(); it < ((CstatSheet*)handle)->shortcuts.end(); it++)
		(*it)->active = active;
	//((CstatSheet*)handle)->active = active;
	return 0;
}

extern "C"__declspec(dllexport) int __cdecl st_GetItIp(void *handle)
{
	return ((CstatMachine*)handle)->ip;
}

extern "C" __declspec(dllexport) int __cdecl st_SetEnumMode(int mode)
{
	emode = mode;
	return 0;
}

extern "C" __declspec(dllexport) int __cdecl st_SetEnumSort(int sort)
{
	esort = sort;
	return 0;
}

extern "C" __declspec(dllexport) void* __cdecl st_EnumStart(void* handle)
{
	switch (emode)
	{
	case ST_EMODE_SHEETS:
	{
		sheet_ptrs.clear();
		for (vector<CstatSheet*>::iterator it = sheets.begin(); it < sheets.end(); it++)
			sheet_ptrs.push_back(*it);
		ecollection = &sheet_ptrs;
		if (esort == ST_ESORT_RATING)
			sort(ecollection->begin(), ecollection->end(), statitem_less_r());
		if (esort == ST_ESORT_ALPHA)
			sort(ecollection->begin(), ecollection->end(), statitem_less_a());
		break;
	}
	case ST_EMODE_SHORTCUTS:
	{
		sheet_ptrs.clear();
		for (vector<CstatShortcut*>::iterator it = shortcuts.begin(); it < shortcuts.end(); it++)
			sheet_ptrs.push_back(*it);
		ecollection = &sheet_ptrs;
		if (esort == ST_ESORT_RATING)
			sort(ecollection->begin(), ecollection->end(), statitem_less_r());
		if (esort == ST_ESORT_ALPHA)
			sort(ecollection->begin(), ecollection->end(), statitem_less_a());
		break;
	}
	case ST_EMODE_SHEETSHORTCUTS:
	{
		sheet_ptrs.clear();
		for (vector<CstatShortcut*>::iterator it = ((CstatSheet*)handle)->shortcuts.begin(); it < ((CstatSheet*)handle)->shortcuts.end(); it++)
			sheet_ptrs.push_back(*it);
		ecollection = &sheet_ptrs;
		if (esort == ST_ESORT_RATING)
			sort(ecollection->begin(), ecollection->end(), statitem_less_r());
		break;
	}
	case ST_EMODE_TREE:
		ecollection = &sort_tree;
		if (esort == ST_ESORT_RATING)
		{
			sort(sheets.begin(), sheets.end(), statitem_less_r());

			sheet_ptrs.clear();
			for (vector<CstatSheet*>::iterator it_sheet = sheets.begin(); it_sheet < sheets.end(); it_sheet++)
			{
				sheet_ptrs.push_back(*it_sheet);
				int len = sheet_ptrs.size();
				for (vector<CstatShortcut*>::iterator it_shortcut = (*it_sheet)->shortcuts.begin(); it_shortcut < (*it_sheet)->shortcuts.end(); it_shortcut++)
					sheet_ptrs.push_back(*it_shortcut);
				sort(sheet_ptrs.begin()+len, sheet_ptrs.end(), statitem_less_r());
			}
			ecollection = &sheet_ptrs;
		}
		break;
	}

	e = ecollection->begin();
        ep = e == ecollection->end() ? 0 : *e;
	return ep;
}

extern "C" __declspec(dllexport) void* __cdecl st_EnumNext()
{
	if (ep != 0)
	{
	        e++;
		if (e == ecollection->end()) ep = 0;
		else ep = *e;
	}
	return ep;
}

extern "C" __declspec(dllexport) int __cdecl st_GetEnumSize()
{
	return ecollection ? ecollection->size() : 0;
}

extern "C" __declspec(dllexport) void* __cdecl st_EnumMachinesStart()
{
	em = machines.begin();
	return em==machines.end() ? 0 : *em;
}

extern "C" __declspec(dllexport) void* __cdecl st_EnumMachinesNext()
{
	if (em==machines.end())
		return 0;
	em++;
	return em==machines.end() ? 0 : *em;
}


static HBITMAP ReadBitmap(ifstream *f)
{
  BITMAP bi;
  void *buff;
  HBITMAP bitmap;
  int size;

  ZeroMemory(&bi,sizeof(bi));
  f->read((char*)&bi.bmWidth,sizeof(bi.bmWidth));
  f->read((char*)&bi.bmHeight,sizeof(bi.bmHeight));
  f->read((char*)&bi.bmWidthBytes,sizeof(bi.bmWidthBytes));
  f->read((char*)&bi.bmPlanes,sizeof(bi.bmPlanes));
  f->read((char*)&bi.bmBitsPixel,sizeof(bi.bmBitsPixel));

  size = bi.bmWidthBytes*bi.bmHeight;
  buff = sys_alloc(size);
  f->read((char*)buff,size);
  bitmap = CreateBitmap(bi.bmWidth,bi.bmHeight,bi.bmPlanes,bi.bmBitsPixel,buff);
  sys_free(buff);

  return bitmap;
}


char* memcpyIncremental(char* dst, const char* src, size_t size)
{
	memcpy(dst, src, size);
	return (char*)src + size;
}

static HBITMAP ReadBitmapFromBuf(char** buf)
{
	BITMAP bi;
	HBITMAP bitmap;

	char* p = *buf;

	ZeroMemory(&bi,sizeof(bi));
	p = memcpyIncremental((char*)&bi.bmWidth, p, sizeof(bi.bmWidth));
	p = memcpyIncremental((char*)&bi.bmHeight, p, sizeof(bi.bmHeight));
	p = memcpyIncremental((char*)&bi.bmWidthBytes, p, sizeof(bi.bmWidthBytes));
	p = memcpyIncremental((char*)&bi.bmPlanes, p, sizeof(bi.bmPlanes));
	p = memcpyIncremental((char*)&bi.bmBitsPixel, p, sizeof(bi.bmBitsPixel));

	bitmap = CreateBitmap(bi.bmWidth,bi.bmHeight,bi.bmPlanes,bi.bmBitsPixel,p);

	int size = bi.bmWidthBytes*bi.bmHeight;
	*buf = p+size;

	return bitmap;
}


static HICON CreateIconFromBuf(char* buf)
{
	char *p = buf + 4;
	HICON icon;
	ICONINFO i;
	i.fIcon = TRUE;
	i.xHotspot = 0;
	i.yHotspot = 0;
	i.hbmColor = ReadBitmapFromBuf(&p);
	i.hbmMask = ReadBitmapFromBuf(&p);

	icon = CreateIconIndirect(&i);

	DeleteObject(i.hbmColor);
	DeleteObject(i.hbmMask);

	return icon;
}


extern "C" __declspec(dllexport) int __cdecl st_LoadFile(char* file)
{
	ifstream f(file, ios_base::in|ios_base::binary);
	char SheetName[256], *pSheetName = SheetName;
	char ShortcutName[256], *pShortcutName = ShortcutName;
	CstatSheet *CurSheet = 0;
	CstatShortcut *CurShortcut = 0;
	CstatMachine *CurMachine = 0;
	union
	{
		int all;
		struct
		{
			int runcount:1;
		};
	}flags;

	while(!f.eof())
	{
		int tag = f.get();
		if (f.eof())
			break;

		assert(8*sizeof(char) <= sizeof(FILETIME));
		assert(4*sizeof(char) <= sizeof(int));
		assert(3*sizeof(char) <= sizeof(COLOR));

		switch(tag)
		{
		case 'c': // Sheet color
			{
				// Contains sheet name
				f.getline(SheetName, sizeof(SheetName), '\0');
				COLOR color = 0;
				f.read((char*)&color, 3);

				// Store color
				COLORS_CACHE::iterator it = colors_cache.find(SheetName);
				if (it == colors_cache.end())
					colors_cache[strdup(SheetName)] = color;
				else
					it->second = color;
			}
			break;

		case 'i': // Icon
			{
				// Contains sheet or sheet+shortcut name
				f.getline(ShortcutName, sizeof(ShortcutName), '\0');
				int isize = 0;
				f.read((char*)&isize, 4);
				for (int i = 0; i < isize; i++)
					f.get();
			}
			break;

		
		case 'e': // Color + Icon
			{
				// Contains sheet or sheet+shortcut name
				f.getline(ShortcutName, sizeof(ShortcutName), '\0');
				COLOR color = 0;
				f.read((char*)&color, 3);

				// Store color
				COLORS_CACHE::iterator it = colors_cache.find(ShortcutName);
				if (it == colors_cache.end())
					colors_cache[strdup(ShortcutName)] = color;
				else
					it->second = color;

				// Read icon size
				int isize = 0;
				f.read((char*)&isize, 4);

				if (isize>0)
				{
					HICON icon;

					// Read icon data to buffer
					char* buf = (char*)sys_alloc(isize+4);
					*((int*)buf) = isize;
					f.read(buf+4, isize);

					// Create shared icon
					ICONS_SHARE::iterator it = icons_share.find(buf);
					if (it != icons_share.end())
					{
						sys_free(buf);
						icon = it->second;
					}
					else
					{
						icon = CreateIconFromBuf(buf);
						icons_share[buf] = icon;
					}

					// Associate icon with Shortcut by name (Cache icon)
					if (icon)
					{
						ICONS_CACHE::iterator it = icons_cache.find(ShortcutName);
						if (it == icons_cache.end())
							icons_cache[strdup(ShortcutName)] = icon;
						else
							it->second = icon;
					}
				}

/*				if (isize>0)
				{
					// Read icon
					ICONINFO i;
					HICON icon;
	                  
					i.fIcon = TRUE;
					i.xHotspot = 0;
					i.yHotspot = 0;
					i.hbmColor = ReadBitmap(&f);
					i.hbmMask = ReadBitmap(&f);
	                  
					icon = CreateIconIndirect(&i);

					DeleteObject(i.hbmColor);
					DeleteObject(i.hbmMask);

					// Store icon
					if ( icon )
					{
						ICONS_CACHE::iterator it = icons_cache.find(ShortcutName);
						if (it == icons_cache.end())
							icons_cache[strdup(ShortcutName)] = icon;
						else
						{
							DestroyIcon(it->second);
							it->second = icon;
						}
					}
				}
*/
			}
			break;
		
		
		case 'm': // Machine information
			{
				// Read machine information
				int number = f.get();
				int ip = 0;
				f.read((char*)&ip, 4);

				char MachineName[32];

				wsprintf(MachineName, "%d", number);
                        
				// Store machine information
				CurMachine = 0;
				for (vector<CstatMachine*>::iterator it = machines.begin(); it<machines.end(); it++)
					if (!lstrcmpi((*it)->caption, MachineName))
					{
						CurMachine = *it;
						break;
					}
				if (!CurMachine)
				{
					CurMachine = new CstatMachine(MachineName);
					machines.push_back(CurMachine);
					CurMachine->active = true;
				}
				CurMachine->ip = ip;
			}
			break;
		case 'r': // Rating data
			{
				if (!CurMachine)
				{
					//assert(0);
					st_Clean();
					return -2;
				}

				f.getline(SheetName, sizeof(SheetName), '\\');
				f.getline(ShortcutName, sizeof(ShortcutName), '\0');
        	        
				// Search/add sheet
				CurSheet = 0;
				for (vector<CstatSheet*>::iterator it = sheets.begin(); it<sheets.end(); it++)
					if (!strcmp((*it)->caption, SheetName))
					{
						CurSheet = *it;
						break;
					}
				if (!CurSheet)
				{
					CurSheet = new CstatSheet(SheetName);
					sheets.push_back(CurSheet);
					CurSheet->active = false;//true;
				}
        	        
				
				// Search/add shortcut
				CurShortcut = 0;
				for (vector<CstatShortcut*>::iterator it = CurSheet->shortcuts.begin(); it<CurSheet->shortcuts.end(); it++)
				{
					if (!strcmp((*it)->caption, ShortcutName))
					{
						CurShortcut = *it;
						break;
					}
				}
				if (!CurShortcut)
				{
					CurShortcut = new CstatShortcut(ShortcutName);
					shortcuts.push_back(CurShortcut);
					CurShortcut->sheet = CurSheet;
					CurSheet->shortcuts.push_back(CurShortcut);
					CurShortcut->active = false;//true;
					// additionally
					AddToSortTree(CurShortcut);
				}
        	        
				// Add data
				CurShortcut->ratings.push_back(C_statRating());
				C_statRating *CurRating = &*(CurShortcut->ratings.end()-1);
				CurRating->machine = CurMachine;
        	        
				// Read flags
				flags.all = f.get();

				// Read starting date-time
				FILETIME BeginDate;
				f.read((char*)&BeginDate, 8);

				// Read ending date-time
				FILETIME EndDate;
				f.read((char*)&EndDate, 8);

				// Store starting date in Delphi format
				CurRating->date = (DATE)(((*(ULARGE_INTEGER*)&BeginDate).QuadPart - 94353552000000000)/864000000000);

				SYSTEMTIME st;
				FileTimeToSystemTime(&BeginDate, &st);
				int BeginDayFract = 1440 - (st.wHour*60 + st.wMinute);
				FileTimeToSystemTime(&EndDate, &st);
				int EndDayFract = st.wHour*60 + st.wMinute;

				// Read raw data
				while(!f.eof())
				{
					int CurData = 0;
					f.read((char*)&CurData, 2);
					if (CurData == 0xFFFF)
						break;
					CurRating->data.push_back(static_cast<float>(CurData));
				}

//				// Correct begin/end day statistic fractions
//				if (*((__int64*)&EndDate) != 0 && CurRating->data.size() > 0)
//				{
//					if (CurRating->data.size() > 1)
//					{
//						CurRating->data[0] = CurRating->data[0]*1440/BeginDayFract;
//						CurRating->data[CurRating->data.size()-1] = CurRating->data[CurRating->data.size()-1]*1440/EndDayFract;
//					}
//					else // Only one day in statistic
//					{
//						CurRating->data[0] = CurRating->data[0]*1440/(BeginDayFract + EndDayFract - 1440);
//						if (CurRating->data[0]<0) CurRating->data[0] = 0;
//					}
//				}
			
			}	
			break;

		default:
//			assert(0);
			st_Clean();
			return -1;
		}
	}

	for (vector<CstatShortcut*>::iterator it = shortcuts.begin(); it<shortcuts.end(); it++)
		(*it)->Update();

	for (vector<CstatSheet*>::iterator it = sheets.begin(); it<sheets.end(); it++)
		(*it)->Update();

	return 0;
}


void WriteBitmap(ofstream *f,HBITMAP bitmap,int force32)
{
  BITMAP bi;

  if ( GetObject(bitmap,sizeof(bi),&bi) )
     {
       if ( !force32 )
          {
            int size = bi.bmWidthBytes*bi.bmHeight;
            void *buff = sys_alloc(size);
            
            GetBitmapBits(bitmap,size,buff);
            f->write((char*)&bi.bmWidth,sizeof(bi.bmWidth));
            f->write((char*)&bi.bmHeight,sizeof(bi.bmHeight));
            f->write((char*)&bi.bmWidthBytes,sizeof(bi.bmWidthBytes));
            f->write((char*)&bi.bmPlanes,sizeof(bi.bmPlanes));
            f->write((char*)&bi.bmBitsPixel,sizeof(bi.bmBitsPixel));
            f->write((char*)buff,size);

            sys_free(buff);
          }
       else
          {
            HDC hdc;
            void *buff;
            int size;
            BITMAPINFO dib;

            bi.bmWidthBytes = bi.bmWidth*4;
            bi.bmBitsPixel = 32;

            ZeroMemory(&dib,sizeof(dib));
            dib.bmiHeader.biSize = sizeof(dib.bmiHeader);
            dib.bmiHeader.biWidth = bi.bmWidth;
            dib.bmiHeader.biHeight = -bi.bmHeight;
            dib.bmiHeader.biPlanes = bi.bmPlanes;
            dib.bmiHeader.biBitCount = bi.bmBitsPixel;

            size = bi.bmWidthBytes*bi.bmHeight;
            buff = sys_alloc(size);
            
            hdc = GetDC(NULL);
            GetDIBits(hdc,bitmap,0,bi.bmHeight,buff,&dib,DIB_RGB_COLORS);
            ReleaseDC(NULL,hdc);

            f->write((char*)&bi.bmWidth,sizeof(bi.bmWidth));
            f->write((char*)&bi.bmHeight,sizeof(bi.bmHeight));
            f->write((char*)&bi.bmWidthBytes,sizeof(bi.bmWidthBytes));
            f->write((char*)&bi.bmPlanes,sizeof(bi.bmPlanes));
            f->write((char*)&bi.bmBitsPixel,sizeof(bi.bmBitsPixel));
            f->write((char*)buff,size);

            sys_free(buff);
          }
     }
}


extern "C" __declspec(dllexport) int __cdecl st_SaveFile(char* file)
{
	ofstream f(file, ios_base::out|ios_base::binary);

	for (vector<CstatSheet*>::iterator it = sheets.begin(); it<sheets.end(); it++)
	{
	        int buf = 0;
		f.put('e');
		f.write((*it)->caption, lstrlen((*it)->caption)+1); // With trailing '\0'
		f.write((char*)&((*it)->color), 3);
		if ((*it)->Icon())
		{
			ICONINFO ii;
			if (GetIconInfo((*it)->Icon(),&ii))
			{
				buf = 1;
				f.write((char*)&buf, 4);

				WriteBitmap(&f, ii.hbmColor, TRUE);
				WriteBitmap(&f, ii.hbmMask, FALSE);
				DeleteObject(ii.hbmColor);
				DeleteObject(ii.hbmMask);
			}
			else
			{
				buf = 0;
				f.write((char*)&buf, 4);
			}
		}
		else
		{
			buf = 0;
			f.write((char*)&buf, 4);
		}
	}

	for (vector<CstatShortcut*>::iterator it = shortcuts.begin(); it<shortcuts.end(); it++)
	{
		// Write extra information
		int buf = 0;
		f.put('e');
		f.write((*it)->sheet->caption, lstrlen((*it)->sheet->caption)); // Without trailing '\0'
		f.put('\\');
		f.write((*it)->caption, lstrlen((*it)->caption)+1); // With trailing '\0'
		f.write((char*)&((*it)->sheet->color), 3);
		if ((*it)->Icon())
		{
			ICONINFO ii;
			if (GetIconInfo((*it)->Icon(),&ii))
			{
				buf = 1;
				f.write((char*)&buf, 4);

				WriteBitmap(&f, ii.hbmColor, TRUE);
				WriteBitmap(&f, ii.hbmMask, FALSE);
				DeleteObject(ii.hbmColor);
				DeleteObject(ii.hbmMask);
			}
			else
			{
				DWORD x = GetLastError();
				buf = 0;
				f.write((char*)&buf, 4);
			}
		}
		else
		{
			buf = 0;
			f.write((char*)&buf, 4);
		}


		__int64 Date;

		for (vector<C_statRating>::iterator itr = (*it)->ratings.begin(); itr < (*it)->ratings.end(); itr++)
		{
			// Write machine information
			f.put('m');
			f.put(atoi(itr->machine->caption));
			f.write((char*)&(itr->machine->ip), 4);

			// Write rating information
			f.put('r');
			f.write((*it)->sheet->caption, lstrlen((*it)->sheet->caption)); // Without trailing '\0'
			f.put('\\');
			f.write((*it)->caption, lstrlen((*it)->caption)+1); // With trailing '\0'
			f.put(0); // flags

			Date = static_cast<__int64>(itr->date)*864000000000 + 94353552000000000;// - 432000000000 + 1;
			f.write((char*)&Date, 8);
        
			Date = 0; // fake: that means "do not correct begin/end day ratings"
			f.write((char*)&Date, 8);
        
			for (int i = 0; i < itr->data.size(); i++)
			{
				int d = itr->data[i];
				f.write((char*)&d, 2);
			}
			f.put(0xFF);
			f.put(0xFF);
		}
	}
	return 0;
}

#include "ExportHtml.inc.cpp"
#include "ExportXml.inc.cpp"
#include "ExportDebug.inc.cpp"

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

void AddToSortTree(CstatShortcut* shortcut)
{
	vector<CstatItem*>::iterator it = sort_tree.begin();
	
	for(;;)
	{
		// Search for sheet
		while (it!=sort_tree.end() && (*it)->Type()!=ST_TYPE_SHEET)
			it++;
		if (it==sort_tree.end()) // No sheet, greater or equal, found
		{
			sort_tree.push_back(shortcut->sheet);
			sort_tree.push_back(shortcut);
			return;
		}
		else
		{
			int cmp = lstrcmpi((*it)->caption, shortcut->sheet->caption);
			if (cmp>0) // Greater (alphabetically) sheet found
			{
				it = sort_tree.insert(it, shortcut);
				it = sort_tree.insert(it, shortcut->sheet);
				return;
			}
			else if (cmp==0)
			{
				// Search for shortcut
				it++;
				while (it!=sort_tree.end() && (*it)->Type()==ST_TYPE_SHORTCUT)
				{
					int cmp = lstrcmpi((*it)->caption, shortcut->caption);
					if (cmp==0) // Already in tree
						return;
					if (cmp>0) // Greater (alphabetically) shortcut found
					{
						it = sort_tree.insert(it, shortcut);
						return;
					}
					it++;
				}
				it = sort_tree.insert(it, shortcut);
				return;
			}
		}
		it++;
	}
}


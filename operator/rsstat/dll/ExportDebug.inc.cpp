extern "C" __declspec(dllexport) int __cdecl st_Export2Debug(char* file)
{
	ofstream f(file);

	char temp[2048];
	char caption[2048];

	f << "Machines:\n";
	for (vector<CstatMachine*>::iterator it = machines.begin(); it != machines.end(); it++)
	{
		f << "\t" << (*it) << ' ' << ((*it)->active ? '+' : '-') << (*it)->caption << ':\t' << (*it)->ip << '\n';
	}

	f << "Sheets:\n";
	for (vector<CstatSheet*>::iterator it = sheets.begin(); it != sheets.end(); it++)
	{
		f << "\t" << (*it) << ' ' << ((*it)->active ? '+' : '-') << (*it)->caption << " icon:" << (*it)->Icon() << " color:"<< (*it)->Color() << '\n';
		f << "\t\tshortcuts:\n";
		for (vector<CstatShortcut*>::iterator its = (*it)->shortcuts.begin(); its != (*it)->shortcuts.end(); its++)
		{
			f << "\t\t" << (*it) << " (" << (*it)->caption << ")\n";
		}
	}
	
	f << "Shortcuts:\n";
	for (vector<CstatShortcut*>::iterator it = shortcuts.begin(); it != shortcuts.end(); it++)
	{
		f << "\t" << (*it) << ' ' << ((*it)->active ? '+' : '-') << (*it)->caption << " icon:"<< (*it)->Icon() << " color:"<< (*it)->Color() << '\n';
		f << "\t\tratings:\n";
		for (vector<C_statRating>::iterator itr = (*it)->ratings.begin(); itr != (*it)->ratings.end(); itr++)
		{
			f << "\t\tmachine:" << itr->machine << " raw:";
			for (int i = 0; i<itr->data.size(); i++)
				f << itr->data[i] << " ";
			f << "midlevel:" << itr->midlevel << "\n";
		}
	}

	f << "Colors cache:\n";
	for (COLORS_CACHE::iterator it = colors_cache.begin(); it != colors_cache.end(); it++)
	{
		f << "\t" << it->first << " color:" << it->second << "\n";
	}

	f << "Icons cache:\n";
	for (ICONS_CACHE::iterator it = icons_cache.begin(); it != icons_cache.end(); it++)
	{
		f << "\t" << it->first << " icon:" << it->second << "\n";
	}

	f << "Icons share:\n";
	for (ICONS_SHARE::iterator it = icons_share.begin(); it != icons_share.end(); it++)
	{
		f << "\t" /*<< it->first <<*/ " icon:" << it->second << "\n";
	}

	return 0;
}

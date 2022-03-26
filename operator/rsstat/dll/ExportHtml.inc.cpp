char *htmlHead = \
"<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.0 Transitional//EN\">\n" \
"<html>\n" \
"<head>\n" \
"<title>Статистика запуска программ</title>\n" \
"<style type=\"text/css\">\n" \
"     body {\n" \
"                MARGIN-LEFT:      20px;\n" \
"                MARGIN-RIGHT:     20px;\n" \
"                MARGIN-TOP:       20px;\n" \
"                MARGIN-BOTTOM:    20px;\n" \
"                FONT-FAMILY:      Verdana;\n" \
"                FONT-SIZE:        8pt;\n" \
"                COLOR:            #000000;\n" \
"                BACKGROUND-COLOR: #FFFFFF;\n" \
"     }\n" \
"     td {\n" \
"                FONT-FAMILY:      Verdana;\n" \
"                FONT-SIZE:        8pt;\n" \
"     }\n" \
"</style>\n" \
"<meta http-equiv=\"Content-Type\" content=\"text/html; charset=windows-1251\">\n" \
"</head>\n" \
"<body>\n" \
"<table border=0 cellspacing=1 cellpadding=4 bgcolor=#FFFFFF>\n" \
"<tr><td nowrap align=center><b>Статистика запуска программ</b></td></tr>\n"\
"<tr><td>\n";


char *htmlTableHead = \
"<table border=1 cellspacing=1 cellpadding=4 bgcolor=#F5F5F5>\n" \
"<tr>\n" \
"<td nowrap align=center><b>Имя</b></td>\n" \
"<td nowrap align=center><b>Популярность (максимальная %s)</b></td>\n" \
"</tr>\n";


char *htmlTableLine = \
"<tr>\n" \
"<td nowrap align=center>%s</td>\n" \
"<td nowrap align=left>\n" \
"  <table border=0 cellspacing=0 cellpadding=0 bgcolor=#10AA30 width=\"%d%%\">\n"
"  <tr><td>&nbsp;</td></tr>\n"
"  </table>\n"
"</td>\n"
"</tr>\n";


char *htmlFoot = \
"</table>\n" \
"</td></tr></table>" \
"</body></html>";

extern "C" __declspec(dllexport) int __cdecl st_Export2Html(char* file)
{
	ofstream f(file);

	char temp[2048];
	char caption[2048];

	int maxRating = 1;
	for (vector<CstatItem*>::iterator it = sort_tree.begin(); it<sort_tree.end(); it++)
	{
	        if ((*it)->Midlevel() > maxRating)
	        	maxRating = (*it)->Midlevel();
	}

	if (maxRating >= 60)
		wsprintf(caption, "%dч %0.2dмин", maxRating/60, maxRating%60);
	else
		wsprintf(caption, "%0.2dмин", maxRating);

	f << htmlHead;
	wsprintf(temp, htmlTableHead, caption);
	f << temp;

	for (vector<CstatItem*>::iterator it = sort_tree.begin(); it<sort_tree.end(); it++)
	{
	        int rating = 100 * (*it)->Midlevel() / maxRating;
	        if (rating > 100)
	        	rating = 100;
	        if ((*it)->Type() == ST_TYPE_SHEET)
	        	wsprintf(caption, "<b>%s</b>", (*it)->caption);
	        else
	        	wsprintf(caption, "%s", (*it)->caption);
        	wsprintf(temp, htmlTableLine, caption, rating);
		f << temp;
	}

	f << htmlFoot;

	return 0;
}

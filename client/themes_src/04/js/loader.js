/*~~~~~~~! objects loader for desctop program on DOM !~~~~~~~*/

var filter_iborder = "progid:DXImageTransform.Microsoft.AlphaImageLoader(src='"+res_url_iborder+"', sizingMethod='crop')";
var filter_aborder = "progid:DXImageTransform.Microsoft.AlphaImageLoader(src='"+res_url_aborder+"', sizingMethod='crop')";


function setLoader(statusId, companyId, menuId, promoId, infoId)
{
	/*~~~~~~~~~~! user options !~~~~~~~~~*/
	
	/*~~~~~~~~~~! end user options !~~~~~~~~~~*/
	kSet.statusId = statusId;
	kSet.statusBlock = $(kSet.statusId);
	kSet.companyId = companyId;
	kSet.companyBlock = $(kSet.companyId).childNodes[0];
	kSet.companyText = external.getMachineLoc;
	kSet.menuId = menuId;
	kSet.menuCount = external.getNumSheets;
	kSet.menuBlock = $(kSet.menuId);
	kSet.promoId = promoId;
	kSet.promoBlock = $(kSet.promoId).childNodes[1].childNodes[0].childNodes[0];
	kSet.promoText = external.getInfoText;
	kSet.infoId = infoId;
	kSet.infoBlock = $(kSet.infoId).childNodes[0].childNodes[0];
	kSet.infoText = external.getMachineDesc;
	statusLoader();
	companyLoader();
	menuLoader();
	promoLoader();
	infoLoader();
}

function statusLoaderInternal(s) {
	kSet.statusText = s;
	if (kSet.statusBlock.innerHTML != "")
	{
		kSet.statusBlock.innerHTML = "&nbsp;";
	}
	kSet.status = document.createTextNode(kSet.statusText);
	kSet.statusBlock.appendChild(kSet.status);
}


function statusLoader() {
	statusLoaderInternal(external.getStatusString);
}

function statusPostLoader() {
	if (kSet.statusText == "")
	{
		statusLoaderInternal("_");
		statusLoaderInternal("");
	}
}

function companyLoader() {
	if (kSet.companyBlock.innerHTML != "")
	{
		kSet.companyBlock.innerHTML = "";
	}
	kSet.company = document.createTextNode(kSet.companyText);
	kSet.companyBlock.appendChild(kSet.company);
}

function menuLoader() {
	kSet.menuItem = new Array();
	//kSet.borderImg = new Array();
	if (kSet.menu = kSet.menuBlock.childNodes) {
		kSet.menu_length = kSet.menu.length;
		for ( var j = 0; j < kSet.menu_length; j++ ) {
			kSet.menuBlock.removeChild(kSet.menu[0]);
		}
	}
	for ( var i = 0; i < kSet.menuCount; i++ ) {	
		kSet.tempText = document.createTextNode(external.getSheetName(i));
		kSet.tempText1 = document.createTextNode(external.getSheetName(i));
		kSet.tempImg = external.getSheetBGPic(i);
		kSet.tempDiv1 = document.createElement('div');	
		kSet.tempDiv1.className = "text";
		kSet.tempDiv11 = document.createElement('div');	
		kSet.tempDiv11.className = "shadow";
		kSet.tempDiv11.appendChild(kSet.tempText1);
		kSet.tempDiv1.appendChild(kSet.tempDiv11);
		kSet.tempDiv1.appendChild(kSet.tempText);
		kSet.tempDiv2 = document.createElement('div');	
		kSet.tempDiv2.className = "left";
		kSet.tempDiv3 = document.createElement('div');	
		kSet.tempDiv3.className = "sp";
		kSet.tempDiv4 = document.createElement('div');	
		kSet.tempDiv4.className = "border";
		kSet.tempDiv4.style.filter = filter_iborder;
		kSet.tempImg1 = document.createElement('img');
		if (kSet.tempImg) {
			kSet.tempImg1.src = kSet.tempImg;
			if ( kSet.tempImg1.complete )
				kSet.tempImg1.style.width = kSet.tempImg1.width * 92 / kSet.tempImg1.height + "px";
  			 else
				kSet.tempImg1.style.width = "122px";
		} else {
			kSet.tempImg = "imgs/no_image.jpg";
			kSet.tempImg1.src = kSet.tempImg;
		}
		kSet.tempImg1.className = "photo";
		kSet.tempImg1.alt = external.getSheetName(i);
		kSet.tempImg3 = document.createElement('img');
		kSet.tempImg3.src = "imgs/sp.gif";
		kSet.tempImg3.alt = external.getSheetName(i);
		kSet.tempLink = document.createElement('a');
		kSet.tempLink.setAttribute('href','#');
		kSet.tempLink.onclick = new Function('evt', 'doClick(' + i + ')'); 
		kSet.tempLink.appendChild(kSet.tempImg3);
		
		kSet.menuItem[i] = document.createElement('li');
		kSet.menuItem[i].className = "item";
		kSet.menuItem[i].appendChild(kSet.tempDiv1);
		kSet.menuItem[i].appendChild(kSet.tempDiv2);
		kSet.menuItem[i].appendChild(kSet.tempImg1);
		kSet.menuItem[i].appendChild(kSet.tempDiv4);
		kSet.menuItem[i].appendChild(kSet.tempLink);
		kSet.menuItem[i].appendChild(kSet.tempDiv3);
		
		if (external.isSheetActive(i)) {
			kSet.menuItem[i].className = "active item";
			kSet.menuItem[i].childNodes[3].style.filter = filter_aborder;
		}	
		kSet.menuBlock.appendChild(kSet.menuItem[i]);	
	}
}

function promoLoader() {
	kSet.promoType = false;
	if (kSet.promoText.length > 0) {
		for ( var i = 0; i < kSet.promoText.length; i++ ) {
			if (escape(kSet.promoText.charAt(i)) != "%20") kSet.promoType = true;
		}
	}
	if (kSet.promoType) {
		//if (kSet.promo = kSet.promoBlock.childNodes)
		//{
			//for ( var j = 0; j < kSet.promo.length + 1; j++ ) {
				//kSet.promoBlock.removeChild(kSet.promo[j]);
			//}
		//}
		kSet.promoBlock.innerHTML = kSet.promoText;
		kSet.promoBlock.parentNode.parentNode.style.display = "none";  //fix
	}
	else {
		kSet.promoBlock.parentNode.parentNode.style.display = "none";
	}
}

function promoPostLoader() {
	if (kSet.promoType) {
		kSet.promoBlock.parentNode.parentNode.style.display = "block";
	}
}

function infoLoader() {
	kSet.infoType = false;
	if (kSet.infoText.length > 0) {
		for ( var i = 0; i < kSet.infoText.length; i++ ) {
			if (escape(kSet.infoText.charAt(i)) != "%20") kSet.infoType = true;
		}
	}
	if (kSet.infoType) {
		if (kSet.info = kSet.infoBlock.childNodes)
		{
			for ( var j = 0; j < kSet.info.lengthb + 1; j++ ) {
				kSet.infoBlock.removeChild(kSet.info[j]);
			}
		}
		kSet.infoBlock.innerHTML = kSet.infoText;
		kSet.infoBlock.parentNode.parentNode.style.display = "block";
	}
	else {
		kSet.infoBlock.parentNode.parentNode.style.display = "none";
		$('all').style.backgroundImage = "url(imgs/status_right_hide.jpg)";
	}
}

function OnStatusStringChanged() {
	statusLoader();
}

function doClick(number) {
	external.setSheetActive(number,true);
	//onActivate();
	/*
	statusLoader();
	promoLoader();
	infoLoader();*/
}

function OnActiveSheetChanged() {
	onActivate();
} 


function onActivate() {
	for ( var i = 0; i < kSet.menuCount; i++ ) {	
		if (external.isSheetActive(i)) {
			kSet.menuItem[i].className = "active item";
			kSet.menuItem[i].childNodes[3].style.filter = filter_aborder;
			kSet.menuItem[i].childNodes[0].style.display = "none";
			kSet.left_block[i].style.width = 42;
		}	
		else {
			kSet.menuItem[i].className = "item";
			kSet.menuItem[i].childNodes[3].style.filter = filter_iborder;
			kSet.menuItem[i].childNodes[0].style.display = "none";
			kSet.left_block[i].style.width = 26;
		}
	}
}

// Производит выбор тэгов tag в зоне node, имеющие класс searchClass
function getElementsByClass(searchClass,node,tag) {
        var classElements = new Array();
        if ( node == null )
                node = document;
        if ( tag == null )
               tag = '*';
        var els = node.getElementsByTagName(tag);
        var elsLen = els.length;
	
        var pattern = new RegExp("(^|\\s)"+searchClass+"(\\s|$)");
        for ( var i = 0, j = 0; i < elsLen; i++) {
               if ( pattern.test(els[i].className) ) {
                    classElements[j] = els[i];
                   j++;
              }
        }
        return classElements;
}


function SwitchShader(state) {
  var id_name = "global_shader";
  var obj = document.all ? document.all[id_name] : (document.getElementById ? document.getElementById(id_name) : null);

  if ( obj )
  {
    var new_vis = state ? "visible" : "hidden";
    
    if ( obj.style.visibility != new_vis )
       {
         if ( state )
            {
              obj.style.visibility = new_vis;
              obj.style.filter = "progid:DXImageTransform.Microsoft.AlphaImageLoader(src='"+res_url_shader+"',sizingMethod='scale')";
            }
         else
            {
              obj.style.visibility = new_vis;
              obj.style.filter = "";
            }
       }
  }
}


function OnPageShaded()
{
  SwitchShader(external.isPageShaded);
}


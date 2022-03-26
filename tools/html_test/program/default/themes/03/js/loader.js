/*~~~~~~~! objects loader for desctop program on DOM !~~~~~~~*/

function setLoader(statusId, menuId, promoId, infoId)
{
	kSet = new Object();
	/*~~~~~~~~~~! user options !~~~~~~~~~*/
	
	/*~~~~~~~~~~! end user options !~~~~~~~~~~*/
	kSet.statusId = statusId;
	kSet.statusBlock = $(kSet.statusId).childNodes[0];
	//kSet.statusText = external.getStatusString;
	kSet.menuId = menuId;
	kSet.menuCount = external.getNumSheets;
	kSet.menuBlock = $(kSet.menuId);
	kSet.promoId = promoId;
	kSet.promoBlock = $(kSet.promoId).childNodes[0].childNodes[0].childNodes[0];
	//.childNodes[0].childNodes[0];
	kSet.promoText = external.getInfoText;
	kSet.infoId = infoId;
	kSet.infoBlock = $(kSet.infoId).childNodes[0].childNodes[0];
	kSet.infoText = external.getMachineDesc;
	statusLoader();
	menuLoader();
	promoLoader();
	infoLoader();
}

function statusLoader() {
	kSet.statusText = external.getStatusString;
	if (kSet.statusBlock.innerHTML != "")
	{
		kSet.statusBlock.innerHTML = "";
	}
	kSet.status = document.createTextNode(kSet.statusText);
	kSet.statusBlock.appendChild(kSet.status);
	if (!kSet.statusText) kSet.statusBlock.innerHTML = "&nbsp;";
}

function menuLoader() {
	kSet.menuItem = new Array();
	for ( var i = 0; i < kSet.menuCount; i++ ) {	
		kSet.tempText = document.createTextNode(external.getSheetName(i));
		kSet.tempNobr = document.createElement('nobr');
		kSet.tempNobr.appendChild(kSet.tempText);
		kSet.tempLink = document.createElement('a');
		kSet.tempLink.setAttribute('href','#');
		kSet.tempLink.appendChild(kSet.tempNobr);
		kSet.tempDiv = document.createElement('div');	
		kSet.tempDiv.appendChild(kSet.tempLink);
		kSet.menuItem[i] = document.createElement('li');
		kSet.menuItem[i].onclick = new Function('evt', 'doClick(' + i + ')'); 
		if (external.isSheetActive(i)) {
			kSet.menuItem[i].className = "active";
		}	
		kSet.menuItem[i].appendChild(kSet.tempDiv);	
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
		if (kSet.promo = kSet.promoBlock.childNodes)
		{
			for ( var j = 0; j < kSet.promo.length + 1; j++ ) {
				kSet.promoBlock.removeChild(kSet.promo[j]);
			}
		}
		kSet.promoBlock.innerHTML = kSet.promoText;
		kSet.promoBlock.parentNode.parentNode.parentNode.style.display = "block";
	}
	else {
		kSet.promoBlock.parentNode.parentNode.parentNode.style.display = "none";
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
	}
}

function doClick(number) {
	external.setSheetActive(number,true);
	/*for ( var i = 0; i < kSet.menuCount; i++ ) {	
		if (external.isSheetActive(i)) {
			kSet.menuItem[i].className = "active";
		}	
		else {
			kSet.menuItem[i].className = "";
		}
	}*/
	/*
	statusLoader();
	promoLoader();
	infoLoader();*/
}

function OnStatusStringChanged() {
	statusLoader();
}

function OnActiveSheetChanged() {
	for ( var i = 0; i < kSet.menuCount; i++ ) {	
		if (external.isSheetActive(i)) {
			kSet.menuItem[i].className = "active";
		}	
		else {
			kSet.menuItem[i].className = "";
		}
	}
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


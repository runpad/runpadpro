
// config
	kSet = new Object();
	kSet.first_item = 0;
	kSet.show_count = 5;
	kSet.height_item = 104;
	kSet.scroll_speed = 9;
	
	function fNext() {
			kSet.first_item++;
			return fShower();
	}
	
	function fPrevious() {
			kSet.first_item--;
			return fShower();
	}
	
	function loadBlocks() {
		// Установление высоты блока меню
		kSet.show_count = (document.documentElement.offsetHeight - 210 - (document.documentElement.offsetHeight - 210) % kSet.height_item) / kSet.height_item;
		kSet.menu_height = kSet.show_count * kSet.height_item;
		$('menu_block').childNodes[0].style.height = kSet.menu_height + 80 + "px";
		$('menu_target').style.height = kSet.menu_height + "px";
		
		kSet.menu_block = $('menu');
		kSet.blocks = getElementsByClass('item', kSet.portfolio_block, 'li');
		kSet.btnNext = getElementsByClass('btn_down', $('menu_block'), 'a')[0];
		//addEvent(kSet.btnNext, 'mousemove', fNext, false);
		addEvent(kSet.btnNext, 'click', fNext, false);
		kSet.btnNext.onclick = function() {return false;};
		if (kSet.blocks.length <= kSet.first_item + kSet.show_count) {
			kSet.btnNext.style.display = "none";
		} else {
			kSet.btnNext.style.display = "block";
		}
		kSet.btnPrevious = getElementsByClass('btn_up', $('menu_block'), 'a')[0];
		//addEvent(kSet.btnPrevious, 'mousemove', fPrevious, true);
		addEvent(kSet.btnPrevious, 'click', fPrevious, true);
		kSet.btnPrevious.onclick = function() {return false;};
		if (kSet.first_item <= 0) {
			kSet.btnPrevious.style.display = "none";
		} else {
			kSet.btnPrevious.style.display = "block";
		}
		kSet.menu_display = -1 * kSet.first_item * kSet.height_item;
		kSet.menu_block.style.marginTop = kSet.menu_display + "px";
		kSet.next_top = kSet.btnNext.offsetParent.offsetTop;
		kSet.next_bottom = kSet.btnNext.offsetParent.offsetTop + kSet.btnNext.offsetHeight;
		kSet.next_right = kSet.btnNext.offsetParent.offsetLeft + kSet.btnNext.offsetWidth;
		kSet.prev_top = 0;
		kSet.prev_bottom = 29;
		kSet.prev_right = 148;
		//dix = 0;
	}
	
	function fShower() {
		if (kSet.blocks.length <= kSet.first_item + kSet.show_count) {
			kSet.btnNext.style.display = "none";
		} else {
			kSet.btnNext.style.display = "block";
		}
		if (kSet.first_item <= 0) {
			kSet.btnPrevious.style.display = "none";
		} else {
			kSet.btnPrevious.style.display = "block";
		}
		
		kSet.menu_display = -1 * kSet.first_item * kSet.height_item;
		// Движение вниз
		if (kSet.menu_display < kSet.menu_block.offsetTop) {
			if (kSet.menu_display < kSet.menu_block.offsetTop - kSet.scroll_speed) {
				kSet.menu_block.style.marginTop = kSet.menu_block.offsetTop - kSet.scroll_speed;
				kSet.menu_timer = setTimeout("fShower()", 20);
			} else {
				if (kSet.mouse_x < kSet.next_right && (kSet.mouse_y + 39 - kSet.height_item * kSet.first_item) > kSet.next_top && (kSet.mouse_y + 39 - kSet.height_item * kSet.first_item) < kSet.next_bottom && kSet.first_item + kSet.show_count < external.getNumSheets){
					fNext();
				} else {
					kSet.menu_block.style.marginTop = kSet.menu_display + "px";
					clearTimeout(kSet.menu_timer);
				}
			} // Движение вверх
		} else if (kSet.menu_display > kSet.menu_block.offsetTop) {
			if (kSet.menu_display > kSet.menu_block.offsetTop + kSet.scroll_speed) {
				kSet.menu_block.style.marginTop = kSet.menu_block.offsetTop + kSet.scroll_speed;
				kSet.menu_timer = setTimeout("fShower()", 20);
			} else {
				if (kSet.mouse_x < kSet.prev_right && (kSet.mouse_y + 39 - kSet.height_item * kSet.first_item) > kSet.prev_top && (kSet.mouse_y + 39 - kSet.height_item * kSet.first_item) < kSet.prev_bottom && kSet.first_item > 0){
					fPrevious();
				} else {
					kSet.menu_block.style.marginTop = kSet.menu_display + "px";
					clearTimeout(kSet.menu_timer);
				}
			}
		}
		
		return false;
	}
	
	
function all_out() {	
	kSet.mouse_x = event.clientX;
	kSet.mouse_y = event.clientY - $('menu_block').childNodes[0].offsetTop - $('menu_target').offsetTop - kSet.menu_display;	
	if (kSet.first_item + kSet.show_count < external.getNumSheets) {
		kSet.last_show_items = kSet.first_item + kSet.show_count;
	} else {
		kSet.last_show_items = external.getNumSheets;
	}
	for ( var i = kSet.first_item; i < kSet.last_show_items; i++ ) {	
		if (kSet.menu_item[i].className != "active item") {		
			var top = kSet.link_block[i].offsetTop;
			var bottom = kSet.link_block[i].offsetTop + kSet.link_block[i].offsetHeight;
			var right = kSet.link_block[i].offsetLeft + kSet.link_block[i].offsetWidth;
			if (kSet.mouse_x < right && kSet.mouse_y > top && kSet.mouse_y < bottom) {
				kSet.left_block[i].style.width = 42;
				kSet.link_block[i].style.width = 164;
				kSet.text_block[i].style.display = "block";
			} else {
				kSet.left_block[i].style.width = 26;
				kSet.link_block[i].style.width = 148;
				kSet.text_block[i].style.display = "none";
			}
		}
		//kSet.left_block[i].innerHTML = top + "<br>" + bottom + "<br>" + right + "<br>" + kSet.mouse_x + "<br>" + kSet.mouse_y;
		//kSet.left_block[i].innerHTML = kSet.height_item + "<br>" + kSet.first_item + "<br>" + kSet.first_item * kSet.height_item + "<br>" + kSet.menu_display;
		//kSet.left_block[i].innerHTML = kSet.prev_top + "<br />"+ kSet.prev_bottom + "<br />" + kSet.prev_right + "<br />" + (kSet.mouse_y + 30 - kSet.height_item * kSet.first_item);
	}
}
function load_menu() {
	kSet.menu_block = $('menu');
	kSet.menu_item = getElementsByClass('item', kSet.menu_block, null);
	kSet.left_block = new Array();
	kSet.link_block = new Array();
	kSet.text_block = new Array();
	for( var i = 0; i < kSet.menu_item.length; i++ ) {
		kSet.left_bl = getElementsByClass('left', kSet.menu_item[i], 'div');
		kSet.left_block[i] = kSet.left_bl[0];
		kSet.child_item = kSet.menu_item[i].childNodes;
		kSet.text_bl = getElementsByClass('text', kSet.menu_item[i], 'div');
		kSet.text_block[i] = kSet.text_bl[0];
		for ( var j = 0; j < kSet.child_item.length; j++ ) {
			if (kSet.child_item[j].nodeName == "A") {
				kSet.link_block[i] = kSet.child_item[j];
			} 
		}
	}	
	all_block = $('all');
	all_block.onmousemove = new Function('all_out()'); 
}

// auxiliary function
function addEvent(elm, evType, fn, useCapture) {
        if (elm.addEventListener) {
                elm.addEventListener(evType, fn, useCapture);
        		return true;
        }
        else if (elm.attachEvent) {
                var r = elm.attachEvent('on' + evType, fn);
                return r;
        }
        else {
                elm['on' + evType] = fn;
        }
}


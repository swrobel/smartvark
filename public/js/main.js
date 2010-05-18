function initPopups()
{
	initPopup({
		openEvent:'click'
	});
}
if (window.addEventListener)
	window.addEventListener("load", initPopups, false);
else if (window.attachEvent)
	window.attachEvent("onload", initPopups);
	
function initPopup(_popup) {
	if (!_popup.popupHolderTag) _popup.popupHolderTag = 'div';
	if (!_popup.popupTag) _popup.popupTag = 'div';
	if (!_popup.popupHolderClass) _popup.popupHolderClass = 'popup-holder';
	if (!_popup.popupClass) _popup.popupClass = 'popup';
	if (!_popup.linkOpenClass) _popup.linkOpenClass = 'open';
	if (!_popup.linkCloseClass) _popup.linkCloseClass = 'close';
	if (!_popup.openClass) _popup.openClass = 'active';
	if (!_popup.openEvent) _popup.openEvent = 'hover';
	
	var timer = [];	
	var _popupHolderTag = document.getElementsByTagName(_popup.popupHolderTag);
	if (_popupHolderTag) {
		for (var i=0; i<_popupHolderTag.length; i++) {
			if (_popupHolderTag[i].className.indexOf(_popup.popupHolderClass) != -1) {
				var _popupLink = _popupHolderTag[i].getElementsByTagName('a');
				for (var j=0; j<_popupLink.length; j++) {
					_popupLink[j].parent = _popupHolderTag[i];
					if (_popupLink[j].className.indexOf(_popup.linkOpenClass) != -1) {
						if (_popup.openEvent == 'click') {
							_popupLink[j].onclick = function(){
								if (this.parent.className.indexOf(_popup.openClass) != -1) {
									this.parent.className = this.parent.className.replace(_popup.openClass,'');
								} else {
									this.parent.className += ' '+_popup.openClass;
								}
								return false;
							}
						} else {
							var _popupTag = _popupHolderTag[i].getElementsByTagName(_popup.popupTag);
							for (var k=0; k<_popupTag.length; k++) {
								if (_popupTag[k].className.indexOf(_popup.popupClass) != -1) {
									_popupTag[k].parent = _popupHolderTag[i];
									_popupTag[k].onmouseover = function(){
										if (timer[j]) clearTimeout(timer[j]);
										if (this.parent.className.indexOf(_popup.openClass) == -1) {
											this.parent.className += ' '+_popup.openClass;
										}
									}
									_popupTag[k].onmouseout = function(){
										var _this = this;
										timer[j] = setTimeout(function(){
											_this.parent.className = _this.parent.className.replace(_popup.openClass,'');
										},2);
									}	
								}
							}
							_popupLink[j].onmouseover = function(){
								if (timer[j]) clearTimeout(timer[j]);
								if (this.parent.className.indexOf(_popup.openClass) == -1) {
									this.parent.className += ' '+_popup.openClass;
								}
							}
							_popupLink[j].onmouseout = function(){
								var _this = this;
								timer[j] = setTimeout(function(){
									_this.parent.className = _this.parent.className.replace(_popup.openClass,'');
								},2);
							}
						}
					} else if (_popupLink[j].className.indexOf(_popup.linkCloseClass) != -1) {
						_popupLink[j].onclick = function(){
							if (this.parent.className.indexOf(_popup.openClass) != -1) {
								this.parent.className = this.parent.className.replace(_popup.openClass,'');
							} else {
								this.parent.className += ' '+_popup.openClass;
							}
							return false;
						}
					}
				}
			}		
		}
	}
}

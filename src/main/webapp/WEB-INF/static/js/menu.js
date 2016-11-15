Menu = function(menuSelector) {
	// 菜单ID
	this.menuSelector = menuSelector;
	// 菜单最高高度，窗口大小改变时改变
	this.maxHeight = 0;
	// 二级菜单最小高度
	this.minSecondHeight = 100;
	// 二级菜单最大高度
	this.maxSecondHeight = 0;
	// 单个一级菜单高度
	this.firstHeight = 0;
	// 一级菜单数量
	this.firstCount = 0;
	// 单个二级菜单高度
	this.secondHeight = 0;
	// 二级菜单数量
	this.secondCount = 0;
	// 菜单宽度
	this.width = 0;
};

Menu.prototype.getWidth = function() {
	if ($(this.menuSelector).length==0) {
//		Dialog.message("菜单不存在！");
	}
	this.width = $(this.menuSelector).outerWidth(true);
	return this.width;
};

Menu.prototype.setStyle = function(css) {
	$(this.menuSelector).css(css);
};

ULMenu = function(menuSelector) {
	Menu.call(this, menuSelector);
};

ULMenu.prototype = new Menu();

ULMenu.prototype.init = function() {
	var thisMenu = this;
	$(".category span").bind("click", function() {
		$(".category span").next("ul").slideUp();
		$(".category").removeClass("select");
		if ($(this).hasClass("arrowdown")) {
			$(this).next("ul").slideUp();
			$(this).removeClass("arrowdown");
			
		} else {
			$(this).next("ul").slideDown();
			$(".category span").removeClass("arrowdown");
			$(this).addClass("arrowdown");
			$(this).parent("li").addClass("select");
			thisMenu.resizeMenu();
		}
	});

	$(".sub a").bind("click", function() {
		$(".sub a").removeClass("current");
		$(this).addClass("current");
	});
};

ULMenu.prototype.getFirstHeight = function() {
	this.firstHeight = $(this.menuSelector + " li.category:eq(0)").outerHeight(true);
	return this.firstHeight;
};

ULMenu.prototype.getRealHeight = function() {
	this.firstCount = $(this.menuSelector + " li.category").length;
	return this.getFirstHeight() * this.firstCount;
};

ULMenu.prototype.resizeMenu = function(maxHeight) {
	var thisUl = $(".category span.arrowdown").next("ul");
	if (maxHeight) {
		this.maxHeight = maxHeight;
	}
	this.maxSecondHeight = this.maxHeight - this.getRealHeight();
	this.maxSecondHeight = this.maxSecondHeight > this.minSecondHeight ? this.maxSecondHeight : this.minSecondHeight;
	this.secondHeight = thisUl.children("div").children(":eq(0)").outerHeight(true);
	this.secondCount = thisUl.children("div").children().length;
	var totalSecondHeight = this.secondHeight * this.secondCount;
	var realSecondHeight = totalSecondHeight > this.minSecondHeight ? this.minSecondHeight : totalSecondHeight;
	$(this.menuSelector).height(this.maxHeight);
	// 二级菜单高度不足
	if ((this.getRealHeight() + realSecondHeight) > this.maxHeight) {
		thisUl.children("div").css("overflow-y", "no");
		thisUl.children("div").height(totalSecondHeight);
		$(this.menuSelector).css("overflow-y", "auto");
	} else if (thisUl.length == 1) {
		$(this.menuSelector).css("overflow-y", "no");
		if (totalSecondHeight > this.maxSecondHeight) {
			thisUl.children("div").css("overflow-y", "auto");
			thisUl.children("div").height(this.maxSecondHeight);
		} else {
			thisUl.next("div").css("overflow-y", "no");
			thisUl.children("div").height(totalSecondHeight);
		}
	}
};

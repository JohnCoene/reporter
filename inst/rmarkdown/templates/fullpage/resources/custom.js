
$(document).ready(function() {

  $('h1').each(function(){
      var $set = $(this).nextUntil("h1").andSelf();
      $set.wrapAll('<div class="section" />');
  });

  $('h1').attr("style", "font-size:0px;");

  $('h5').each(function(){
      var $set = $(this).nextUntil("h1").andSelf();
      $set.wrapAll('<div class="slide" />');
  });

  $('h5').attr("style", "font-size:0px;color:rgba(0,0,0,0);");

  $('ul:first').attr("id", "tocMenu");

  var mn = [];

  $("#tocMenu li").each(function()
  {
    var anch = $(this).text().replace(/[^\w\s]|_/g, "").split(' ').join('_');
    $(this).attr("data-menuanchor", anch);
    mn.push(anch);
  });

  var options =	{
      continuousVertical: continuousVertical,
      continuousHorizontal: continuousHorizontal,
	    lockAnchors: false,
	    css3: true,
	    anchors: mn,
	    menu: '#tocMenu',
      controlArrows: true,
		  verticalCentered: center,
		  animateAnchor: true,
		  navigation: navigation,
		  slidesNavigation: slidesNavigation,
		  navigationPosition: navigationPosition,
		  sectionsColor: col,
		  dragAndMove: true,
	  };


	$('#fullpage').fullpage(
	  options
	);
});

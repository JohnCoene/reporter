
$(document).ready(function() {

  $('h1').each(function(){
      var $set = $(this).nextUntil("h1").andSelf();
      $set.wrapAll('<div class="section" />');
  });

  $('pre').attr("class", "sourceCode r");
  $('code').attr("class", "sourceCode r");
  $('h1').attr("style", "font-size:0px;");

  $('h5').each(function(){
      var $set = $(this).nextUntil("h1").andSelf();
      $set.wrapAll('<div class="slide" />');
  });

  $('h5').attr("style", "font-size:0px;");

  $('ul:first').attr("id", "tocMenu");

  var mn = [];

  $("#tocMenu li").each(function()
  {
    var anch = $(this).text().replace(/[^\w\s]|_/g, "").split(' ').join('_');
    $(this).attr("data-menuanchor", anch);
    mn.push(anch);
  });

  function background(col){
   return col;
  }

  var options =	{
	    lockAnchors: false,
	    css3: true,
	    anchors: mn,
	    menu: '#tocMenu',
      controlArrows: true,
		  verticalCentered: true,
		  loopTop: false,
		  loopBottom: true,
		  animateAnchor: true,
		  navigation: navigation,
		  slidesNavigation: slidesNavigation,
		  navigationPosition: navigationPosition,
		  sectionsColor: background(col),
	  };

	$('#fullpage').fullpage(
	  options
	);
});

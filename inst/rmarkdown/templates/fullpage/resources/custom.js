
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
	    lockAnchors:true,
	    scrollOverflow:true,
	    css3: true,
	    anchors: mn,
	    menu: '#tocMenu',
      controlArrows: true,
		  verticalCentered: true,
		  loopTop: false,
		  loopBottom: true,
		  sectionsColor: background(col),
	  };

  console.log(options);

	$('#fullpage').fullpage(
	  options
	);
});


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

  console.log($('ul:first'));

  $('ul:first').attr("id", "tocMenu");

  var mn = [];

  $("#tocMenu li").each(function()
  {
    var anch = $(this).text().replace(/[^\w\s]|_/g, "").split(' ').join('_');
    $(this).attr("data-menuanchor", anch);
    mn.push(anch);
  });

  console.log(mn);

	$('#fullpage').fullpage(
	  {
	    lockAnchors:true,
	    scrollOverflow:true,
	    css3: false,
	    anchors: mn,
	    menu: '#tocMenu'
	  }
	);
});

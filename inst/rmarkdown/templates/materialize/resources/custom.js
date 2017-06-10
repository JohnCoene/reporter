function button(side){
 $('.button-collapse').sideNav({
      menuWidth: 300, // Default is 300
      edge: side, // Choose the horizontal origin
      closeOnClick: true, // Closes side-nav on <a> clicks, useful for Angular/Meteor
      draggable: true // Choose whether you can drag to open on touch screens
    }
  );
}

document.getElementById("slide-out").childNodes[3].className = "section table-of-contents";

$(document).ready(function () {
    $('h1').addClass('scrollspy');
});

$(document).ready(function(){
    $('.scrollspy').scrollSpy();
});

function banner(){
    $(document).ready(function(){
      $('.parallax').parallax();
    });
}

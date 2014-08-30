$(function () {
  if ($('#about').length > 0) { 
    $('#about').remove();
    $('.confidenceindex').append('<%= j render "about" %>');  
  } else {
    $('.confidenceindex').append('<%= j render "about" %>');
  }
});
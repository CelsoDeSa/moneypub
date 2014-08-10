$(function () {
  if ($('#search').length > 0) { 
    $('#search').remove();
    $('.results').append('<%= j render "search" %>');  
  } else {
    $('.results').append('<%= j render "search" %>');
  }
});
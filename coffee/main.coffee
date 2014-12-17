$(document).ready ->
  $('#str').keyup ->
    $('#result').val convert_gksdud $('#str').val()
  $('.menu-home').click ->
  	$('#container-home').css('display', 'block')
  	$('#container-about').css('display', 'none')
  	
  	$('.menu-home').addClass 'active'
  	$('.menu-about').removeClass 'active'
  $('.menu-about').click ->
  	$('#container-about').css('display', 'block')
  	$('#container-home').css('display', 'none')

  	$('.menu-about').addClass 'active'
  	$('.menu-home').removeClass 'active'
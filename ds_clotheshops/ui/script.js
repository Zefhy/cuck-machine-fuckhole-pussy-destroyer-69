$(document).ready(function(){
  // Listen for NUI Events
  window.addEventListener('message', function(event){
    // Open Skin Creator
    if(event.data.openskinClotheshop == true){
      $(".skinClotheshop").css("display","block");
	  $(".rotation").css("display","flex");
    }
    // Close Skin Creator
    if(event.data.openskinClotheshop == false){
      $(".skinClotheshop").fadeOut(400);
	  $(".rotation").css("display","none");
    }
	// Click
    if (event.data.type == "updateMaxVal") {
	  $('input.' + event.data.classname).prop('max',event.data.maxVal);
	  $('input.' + event.data.classname).val(event.data.defaultVal);
	  $('div[name=' + event.data.classname + ']').attr('data-legend', '/'+event.data.maxVal);
	  $('div[name=' + event.data.classname + ']').text(event.data.defaultVal + '/' + event.data.maxVal);
    }
  });

  // Form update
  $('input').change(function(){
    $.post('http:///ds_clotheshops/updateSkin', JSON.stringify({
      value: false,
      // Face
      hats: $('.chapeaux .active').attr('data'),
	  hats_texture: $('input[class=helmet_2]').val(),
      glasses: $('.lunettes .active').attr('data'),
	  glasses_texture: $('input[class=glasses_2]').val(),
      ears: $('.oreilles .active').attr('data'),
	  ears_texture: $('input[class=ears_2]').val(),
      tops: $('.hauts .active').attr('data'),
      pants: $('.pantalons .active').attr('data'),
      shoes: $('.chaussures .active').attr('data'),
      watches: $('.montre .active').attr('data'),
    }));
  });
  $('.arrow').on('click', function(e){
    e.preventDefault();
    $.post('http:///ds_clotheshops/updateSkin', JSON.stringify({
      value: false,
      hats: $('.chapeaux .active').attr('data'),
	  hats_texture: $('input[class=helmet_2]').val(),
      glasses: $('.lunettes .active').attr('data'),
	  glasses_texture: $('input[class=glasses_2]').val(),
      ears: $('.oreilles .active').attr('data'),
	  ears_texture: $('input[class=ears_2]').val(),
      tops: $('.hauts .active').attr('data'),
      pants: $('.pantalons .active').attr('data'),
      shoes: $('.chaussures .active').attr('data'),
      watches: $('.montre .active').attr('data'),
    }));
  });

  // Form submited
  $('.yes').on('click', function(e){
    e.preventDefault();
    $.post('http:///ds_clotheshops/updateSkin', JSON.stringify({
      value: true,
      hats: $('.chapeaux .active').attr('data'),
	  hats_texture: $('input[class=helmet_2]').val(),
      glasses: $('.lunettes .active').attr('data'),
	  glasses_texture: $('input[class=glasses_2]').val(),
      ears: $('.oreilles .active').attr('data'),
	  ears_texture: $('input[class=ears_2]').val(),
      tops: $('.hauts .active').attr('data'),
      pants: $('.pantalons .active').attr('data'),
      shoes: $('.chaussures .active').attr('data'),
      watches: $('.montre .active').attr('data'),
    }));
  }); 
  // Rotate player
  $(document).keypress(function(e) {
    if(e.which == 97){ // A pressed
      $.post('http:///ds_clotheshops/rotaterightheading', JSON.stringify({
        value: 10
      }));
    }
    if(e.which == 101){ // E pressed
      $.post('http:///ds_clotheshops/rotateleftheading', JSON.stringify({
        value: 10
      }));
    }
  });

  // Zoom out camera for clothes
  $('#tabs label').on('click', function(e){
    //e.preventDefault();
    $.post('http:///ds_clotheshops/zoom', JSON.stringify({
      zoom: $(this).attr('data-link')
    }));
  });
});

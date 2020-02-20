$(document).ready(function(){
  // Listen for NUI Events
  window.addEventListener('message', function(event){
    // Open Skin Creator
    if(event.data.openskinBarbershop == true){
      $(".skinBarbershop").css("display","block");
	  $(".rotation").css("display","flex");
    }
    // Close Skin Creator
    if(event.data.openskinBarbershop == false){
      $(".skinBarbershop").fadeOut(400);
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
    $.post('http:///ds_barbershops/updateSkin', JSON.stringify({
      value: false,
      // Face
      hair: $('.hair').val(),
      haircolor: $('input[name=haircolor]:checked', '#formSkinCreator').val(),
	  haircolor2: $('input[name=haircolor2]:checked', '#formSkinCreator').val(),
	  makeup: $('.makeup').val(),
      makeupcolor: $('input[name=makeupcolor]:checked', '#formSkinCreator').val(),
	  makeupcolor2: $('input[name=makeupcolor2]:checked', '#formSkinCreator').val(),
	  makeupopacity: $('.makeupthick').val(),
      eyebrow: $('.sourcils').val(),
      eyebrowopacity: $('.epaisseursourcils').val(),
      beard: $('.barbe').val(),
      beardopacity: $('.epaisseurbarbe').val(),
      beardcolor: $('input[name=barbecolor]:checked', '#formSkinCreator').val(),
    }));
  });
  $('.arrow').on('click', function(e){
    e.preventDefault();
    $.post('http:///ds_barbershops/updateSkin', JSON.stringify({
      value: false,
      hair: $('.hair').val(),
      haircolor: $('input[name=haircolor]:checked', '#formSkinCreator').val(),
	  haircolor2: $('input[name=haircolor2]:checked', '#formSkinCreator').val(),
	  makeup: $('.makeup').val(),
      makeupcolor: $('input[name=makeupcolor]:checked', '#formSkinCreator').val(),
	  makeupcolor2: $('input[name=makeupcolor2]:checked', '#formSkinCreator').val(),
	  makeupopacity: $('.makeupthick').val(),
      eyebrow: $('.sourcils').val(),
      eyebrowopacity: $('.epaisseursourcils').val(),
      beard: $('.barbe').val(),
      beardopacity: $('.epaisseurbarbe').val(),
      beardcolor: $('input[name=barbecolor]:checked', '#formSkinCreator').val(),
    }));
  });

  // Form submited
  $('.yes').on('click', function(e){
    e.preventDefault();
    $.post('http:///ds_barbershops/updateSkin', JSON.stringify({
      value: true,
      hair: $('.hair').val(),
      haircolor: $('input[name=haircolor]:checked', '#formSkinCreator').val(),
	  haircolor2: $('input[name=haircolor2]:checked', '#formSkinCreator').val(),
	  makeup: $('.makeup').val(),
      makeupcolor: $('input[name=makeupcolor]:checked', '#formSkinCreator').val(),
	  makeupcolor2: $('input[name=makeupcolor2]:checked', '#formSkinCreator').val(),
	  makeupopacity: $('.makeupthick').val(),
      eyebrow: $('.sourcils').val(),
      eyebrowopacity: $('.epaisseursourcils').val(),
      beard: $('.barbe').val(),
      beardopacity: $('.epaisseurbarbe').val(),
      beardcolor: $('input[name=barbecolor]:checked', '#formSkinCreator').val(),
    }));
  }); 
  // Rotate player
  $(document).keypress(function(e) {
    if(e.which == 97){ // A pressed
      $.post('http:///ds_barbershops/rotaterightheading', JSON.stringify({
        value: 10
      }));
    }
    if(e.which == 101){ // E pressed
      $.post('http:///ds_barbershops/rotateleftheading', JSON.stringify({
        value: 10
      }));
    }
  });

  // Zoom out camera for clothes
  $('#tabs label').on('click', function(e){
    //e.preventDefault();
    $.post('http:///ds_barbershops/zoom', JSON.stringify({
      zoom: $(this).attr('data-link')
    }));
  });
});

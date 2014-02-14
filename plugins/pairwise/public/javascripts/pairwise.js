 

 jQuery(document).ready(function($){
 	$('#suggestions_box span.close_button').click(function(){
 		$('#suggestions_box').fadeOut();
 	});

	$('#suggestions_box_show_link').click(function(){
 		$('#suggestions_box').fadeIn();
 	}); 	
 });
 

 jQuery(document).ready(function($){
 	$('#suggestions_box span.close_button').live('click', function(){
 		$('#suggestions_box').fadeOut();
 		$('#pairwise_main div.show_new_idea_box').show();
 	});

	$('#suggestions_box_show_link').live('click', function(){
 		$('#suggestions_box').fadeIn();
 		$('#pairwise_main div.show_new_idea_box').hide();
 	}); 	
 });
$(document).ready(function(){
	checkedForValid = false;
	$("#goodinEDSS").click(function(e){
		if(checkedForValid == true){
			checkedForValid = false;
		}else{
			e.preventDefault();
			$.ajax({
				url: "https://redcap.ucsf.edu/api/",
				type: "POST",
				data: {
					token: $("#goodinAPI").val(),
					content: "record",
					format: "json",
					type: "flat"
				},
				success: function(){
					jQuery.gritter.add({ image: '/assets/success.png', title: 'Success', text: 'Your download will begin shortly' });
					checkedForValid = true;
					$("#goodinEDSS").trigger('click');
				},
				error: function(){
					jQuery.gritter.add({ image: '/assets/error.png', title: 'Error', text: 'Please enter a valid API token' });
				}
			})
		}
	})


$("#boveEDSS").click(function(e){
	if(checkedForValid == true){
			checkedForValid = false;
	}else{
			e.preventDefault();
			$.ajax({
				url: "https://redcap.ucsf.edu/api/",
				type: "POST",
				data: {
					token: $("#boveAPI").val(),
					content: "record",
					format: "json",
					type: "flat"
				},
				success: function(){
					jQuery.gritter.add({ image: '/assets/success.png', title: 'Success', text: 'Your download will begin shortly' });
					checkedForValid = true;
					$("#boveEDSS").trigger('click');
				},
				error: function(){
					jQuery.gritter.add({ image: '/assets/error.png', title: 'Error', text: 'Please enter a valid API token' });
				}
			})
		}
	})	
})
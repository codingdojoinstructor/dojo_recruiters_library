function getRand(min,max){
	return Math.floor(Math.random() * (max - min + 1)) + min;
}

function changeStudent(){
	var students = new Array("Angie", "Ben2", "Casey2", "Cory2", "Dilys", "Eva", "Eylem2", "Ian2", "Jose2");
	var max = students.length - 1;
	var min = 0;
	var id = getRand(min, max);

	return students[id];
}

var student = changeStudent();
var prev_student = changeStudent();
var next_student = changeStudent();
var short_list = new Array();
$(document).ready(function(){
	$('#short_list_img').hide();
	$("#main_photo").attr('src', '/assets/profile_pictures/'+student+'.jpg');
	$('#prev_thumb').css('background-image','url(/assets/small_profile_pictures/'+prev_student+'.jpg)');
	$('#next_thumb').css('background-image','url(/assets/small_profile_pictures/'+next_student+'.jpg)');
	$("#short_list").submit(function(){
		$(this).children().each(function(){
			if($(this).attr('name') == 'id' && short_list.indexOf(student) < 0)
			{
				short_list.push(student);
				$('#short_list_img').append('<li><img class="short_thumb" alt="thumbnail profile picture" src="/assets/small_profile_pictures/'+student+'.jpg"></li>');
				$('#short_list_img').show();
				// $(".short_thumb").mouseover(function(){
				// 	rem_coords = $(this).offset();
				// 	$("#remove").text('Remove').offset({ top: rem_coords.top, left: rem_coords.left });
				// })
				// $(".short_thumb").mouseout(function(){
				// 	$("#remove").fadeOut();
				// })
			}	
		});
		return false;
	});
	$("#next_thumb").click(function(){
		prev_student = student;
		$('#prev_thumb').css('background-image','url(/assets/small_profile_pictures/'+prev_student+'.jpg)');
		student = next_student;
		$("#main_photo").attr('src', '/assets/profile_pictures/'+student+'.jpg');
		next_student = changeStudent();
		$('#next_thumb').css('background-image','url(/assets/small_profile_pictures/'+next_student+'.jpg)');
	})	
	$("#prev_thumb").click(function(){
		next_student = student;
		$('#next_thumb').css('background-image','url(/assets/small_profile_pictures/'+next_student+'.jpg)');
		student = prev_student;
		$("#main_photo").attr('src', '/assets/profile_pictures/'+prev_student+'.jpg');
		prev_student = changeStudent();
		$('#prev_thumb').css('background-image','url(/assets/small_profile_pictures/'+prev_student+'.jpg)');
	})
});
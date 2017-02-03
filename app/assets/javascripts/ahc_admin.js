// This does all work.  But I decided against Javascript star rating in the admin pages.
// Using simple radio buttons instead.
// Note that activeadmin doesn't use turbolinks so you use the simple document.ready()

$( document ).ready(function() {
	// console.log("JS is ready in activeadmin");
	edit_program = document.getElementById('edit_program');
	if (edit_program) {
		edit_program.onsubmit = validate;
		// console.log("This is admin");
	} else {
		// console.log("This is not admin");
	}



  // admin_data   = document.getElementById('admin-data')
  // if (!admin_data) {
  //   console.log("Not admin_data")
  //   return;
  // }
});


function validate(){
	program_id = document.getElementById('program_program_id');
	pid = program_id.value;
	console.log("I am validate: " + pid);
	console.log("callback: program " + pid );
	$.ajax({
		type: "PUT",
		url: "/programs/" + pid +  "/calculate_rating",
	});

	// This is where I'd like to recalculate the program's ranking.
}

// var ready;
// ready = function() {
// };

// $(document).ready(function(){ ready() }) 
// $(document).on('turbolinks:load', ready);

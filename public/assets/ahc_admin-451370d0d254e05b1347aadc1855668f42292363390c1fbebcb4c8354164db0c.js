function validate(){program_id=document.getElementById("program_program_id"),pid=program_id.value,console.log("I am validate: "+pid),console.log("callback: program "+pid),$.ajax({type:"PUT",url:"/programs/"+pid+"/calculate_rating"})}$(document).ready(function(){edit_program=document.getElementById("edit_program"),edit_program&&(edit_program.onsubmit=validate)});
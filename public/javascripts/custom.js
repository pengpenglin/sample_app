function checkLength(obj, maxlength) {
  if(obj.value.length > maxlength){
    obj.value = obj.value.substring(0,maxlength);
	document.getElementById('micropost_submit').disabled = "disabled"
  }else{
	document.getElementById('micropost_submit').disabled = ""
	document.getElementById('micropost_length').innerHTML = "You can input more " + 
	                       (maxlength-obj.value.length) + "   characters"
  }
}

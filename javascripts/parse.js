Parse.initialize("7GExJ8EPPiEb8oYZwbEsfIBXeCwK4XavXhOeJvqL", "ocAubh6BhhpGvGNgciSv5iOb5rs6lnRuerZyYVFj");

document.getElementById("signUp").addEventListener("click", function(){
  var inputValue = document.getElementById("emailInput").value

  var EmailObject = Parse.Object.extend("EmailObject");
  var emailObject = new EmailObject();
  emailObject.save({email: inputValue}).then(function(object) {
    document.getElementById("thankYouText").style.display = 'block'
  });

});
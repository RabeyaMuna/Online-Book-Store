document.addEventListener('turbolinks:load', () => {
  var check = document.getElementById('order_delivery_address');
  if (check !== null ){
    check.addEventListener('keyup', function(e)
    {
      const value = e.target.value;
      if (value.length > 0){
        document.getElementById('btn').disabled = false;
      }
      else {
        document.getElementById('btn').disabled = true;
      }
    });
  }
});

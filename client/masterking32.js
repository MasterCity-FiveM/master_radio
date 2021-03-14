MenuOpen = false;

function OpenRadio() {
	MenuOpen = true;
	$("#radioBox").removeClass("hide");
}

function Close() {
	MenuOpen = false;
	$("#radioBox").addClass("hide");
}

$(function() {
	window.addEventListener('message', function(event) {
		if (event.data.type == 'show'){
			OpenRadio();
		} else {
			Close();
		}
	});
});

$("#handle2").roundSlider({
    sliderType: "min-range",
    radius: 130,
    showTooltip: false,
    width: 16,
    value: 0,
	max: 999,
    handleSize: 0,
    handleShape: "square",
    circleShape: "half-top",
	change: function(event) {
        $('#channel').val(event.value)
    }
});

$('#channel').on('input',function(e){
  $("#handle2").roundSlider('setValue', $('#channel').val());
});

$('.submit_button').on('click',function(e){
    var Channel = $('#channel').val();
	var Power = false
	if ($('.radioPower').is(":checked"))
	{
		Power = true
	}
	
	$.post('http://master_radio/setdata', JSON.stringify({power: Power, channel: Channel}));
});
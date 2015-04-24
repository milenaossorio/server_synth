function jquery_open_ajax_dialog(dialog_id, url, dialog_title, height, width, relative_path){
	$('#'+escape(dialog_id)).remove();
				var dialog_window = $("<div></div>").attr('id', escape(dialog_id));
				
	dialog_window.dialog({
				modal: true,
				open: function ()
				{
						var obj = $(this);
						obj.html('<div id="loading_'+dialog_id+'" style="text-align:center;width:100%;"><img src="'+relative_path+'images/ajax-loader.gif" align="absbottom" style="background: none;" /></div> ');
						$.ajax({
							url: url,
							cache: false
						}).done(function( html ) {
							obj.html(html);
						});
				},         
				height: height,
				width: width,
				title: dialog_title
		});

}
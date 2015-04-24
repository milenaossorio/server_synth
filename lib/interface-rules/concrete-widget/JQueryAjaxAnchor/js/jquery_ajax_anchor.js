function jquery_ajax_anchor_get_data(url, result_id, relative_path){
    result_id = escape(result_id);
    $('#'+result_id).append('<div id="loading_'+result_id+'" style="text-align:center;width:100%;"><img src="'+relative_path+'images/ajax-loader.gif" align="absbottom" style="background: none;" /></div> ');		
    $.ajax({
            url: url,
            dataType: "html",
            success: function( data ) {
                $('#'+result_id).html(data);
            }
    });
	
}
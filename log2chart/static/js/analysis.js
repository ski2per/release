$(document).ready(function() {
    var is_selected = false;
    load_cache_data();

//================================================================
//                     ALL FUNCTIONS GO HERE
//================================================================

    function load_cache_data () {
        var url = window.location.pathname;
        url = url.substr(1)
        var arr = url.split("/");
        var ctype = arr[0]
        var ajaxURL = "cache_list/"+ctype;
        $.ajax({
            url:ajaxURL,
            type:"GET",
            dataType:"html",
            beforeSend: function(){},
            success: function(data) {
                $("#cacheList").html(data);
                single_selection();
                setup_analysis_menu();
                setup_delete();
            },
            error: function() {
                $("#cacheList").html("Loading data error :/");
            }
        });
    }

	function clean_selection() {
		is_selected = false;
		$(":checkbox").removeAttr('checked');
	}
	
	//### Make sure only one checkbox is checked ###
	function single_selection() {
		$(':checkbox').each(function(){
			$(this).click(function(){
				if( $(this).prop("checked") ) {
					$(":checkbox").removeAttr('checked');
					$(this).prop('checked','true');
					is_selected = true;
					filename = $(this).val();
				} else {
					is_selected = false;
				}
			});//:checkbox click
		});//each
	}
    

    //##### setup navigation for different data analysis ######
    function setup_analysis_menu() {
        $("#analysisMenu a").click(function(){
            if(is_selected) {
                var atype = $(this).attr("id");
                var url = "/render/"+atype+"/"+filename;
                location.href = url;
            } else {
                alert("Pick up 1 item :/");
            }
        });
    }// setup_analysis_menu()

    function setup_delete() {
        $(".cacheTable a").click(function(){
            link = $(this).attr("href");

            $.ajax({
                url: link,
                type: "GET",
                beforeSend: function(){},
                success: function() {
                    load_cache_data();
                },
                error: function(){}

            });//ajax

            return false;//disable link

        });//click
    }


});//document ready

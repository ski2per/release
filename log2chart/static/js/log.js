$(document).ready(function() {
    var is_selected = false;
    load_log();


//########################################
//######    ALL FUNCTIONS GO HERE   ######
//########################################
//
    function load_log() {
        $.ajax({
            url:"log_list",
            type:"GET",
            dataType:"html",
            beforeSend: function(){},
            success: function(data) {
                $("#logContent").html(data);
                single_selection();
                setup_extract_menu();
                setup_delete();
            },
            error: function() {
                $("#logContent").html("Loading data error :/");
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
                    $("#info").html("");
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
    
    function setup_delete() {
        $(".logTable a").click(function(){
            link = $(this).attr("href"); 

            $.ajax({
                url: link,
                type: "GET",
                beforeSend: function(){},
                success: function() {
                    load_log();
                },
                error: function() {
                }
                
            });//ajax

            return false;//disable link
        });//click
    }//setup_delete()


    //##### setup navigation for different log analysis ######
    function setup_extract_menu() {
        $("#extractMenu a").click(function(){
            if(is_selected) {
                var etype = $(this).attr("id")

                var ajax_url = "extract/"+etype+"/"+filename
                $.ajax({
                    url:ajax_url,
                    type:"GET",
                    dataType:"html",
                    beforeSend: function() {
                        var html_data = '<div class="alert alert-warning">Extracting ' + filename + '</div>'
                        $("#info").html(html_data)
                    },
                    success: function(data) {
                        var html_data = '<div class="alert alert-success">'+data+'</div>'
                        $("#info").html(html_data);
                        //single_selection();
                        //setup_menu();
                    },
                    error: function() {
                        $("#info").html('<div class="alert alert-danger">Extracting error :/</div>');
                    }
                });


                //var atype = $(this).attr("id");
                //var url = "/router/"+atype+"/"+filename;
                //location.href = url;
            } else {
                alert("Pick up 1 item :/");
            }
        });
    }// setup_menu()

});//document ready

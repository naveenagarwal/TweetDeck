$(document).ready(function() {

    // Profile List Drop Down

    $('.controls .list-open').click(function(e) {
        var that = $(this).siblings('.list');
        $(this).siblings('.list').toggleClass('active');
        setTimeout(function() {
            that.toggleClass('animate');
        }, 100);
        e.stopPropagation();
        $(this).parents().siblings().find('.list').removeClass('active animate');
    });

    $('.main-sidebar .list > li a').click(function(e) {
        var that = $(this);
        $(this).toggleClass('active');
        $(this).parent().children('.inner-list').toggleClass('active');
        setTimeout(function() {
            that.toggleClass('animate');
            // $(this).parent().children('.inner-list').toggleClass('animate');
        }, 400);
        $(this).parents('.list').siblings().find('a').removeClass('active animate');
        $(this).parents('.list').siblings().find('.inner-list').removeClass('active');
        e.stopPropagation();
    });



    $(".scheduler .schedule_post").flatpickr({
        enableTime: true,
        dateFormat: "d-m-y, h:i K",
        minDate: "today"
    });



    $('#import-csv').bind('change', function() {
        var _size = this.files[0].size;
        var fileSplit = this.files[0].name.split('.').pop();
        var fSExt = new Array('Bytes', 'KB', 'MB', 'GB'),
            i = 0;
        while (_size > 900) {
            _size /= 1024;
            i++;
        }
        $('#cImportMsg').text(this.files[0].name);
        $('#csvName').text(this.files[0].name);
        if (fileSplit == 'csv') {
            $(this).parents('.import-screen').removeClass('error');
            $(this).parents('.import-campaign-file').addClass('valid');
            $(this).parents('.import-campaign-file').removeClass('error');
            $('.import-campaign-file label').attr('data-tooltip', 'Click to change file');
            $('.off-canvas').addClass('show');
            setTimeout(function() {
                $('.off-canvas').addClass('animate');
            }, 100);
        }

        var exactSize = (Math.round(_size * 100) / 100) + ' ' + fSExt[i];
        if (fSExt[i] == 'GB' || (fSExt[i] == 'MB' && parseInt(exactSize) > 1) || fileSplit != 'csv') {
            this.value = "";
            $('#importCSVName').text('Oopss!!');
            $('#importMSG').text('Something went wrong.');
            $('#chooseCSV').text('Please choose CSV File');
            $(this).parents('.import-screen').addClass('error');
            $(this).parents('.import-screen').removeClass('valid');
            $(this).parents('.import-campaign-file').addClass('error');
            $(this).parents('.import-campaign-file').removeClass('valid');
            $('#cImportMsg').text('Please choose CSV File');
            $('.import-campaign-file label').attr('data-tooltip', 'Import valid CSV file');
            return false;
        }
    });

    $('.close').click(function() {
        $('.off-canvas').removeClass('show animate');
    });

    // url check and class add
    var urlGet = location.href;
    var urlArry = urlGet.split('/');

    var getPageName = urlArry[urlArry.length - 2];

    if (getPageName == 'my_tweets') {
        $('#my_tweets_link').siblings('ul').addClass('active');
        $('#my_tweets_link').addClass('active animate');
    }

    $('#my_tweets_link').click(function(e) {
        if (getPageName == 'my_tweets') {
            e.preventDefault();
        }
    })

    if (getPageName == 'import') {
        $('#import_link').siblings('ul').addClass('active');
        $('#import_link').addClass('active animate');
    }

    $('#import_link').click(function(e) {
        if (getPageName == 'import') {
            e.preventDefault();
        }
    })

    if (getPageName == 'logs') {
        $('#import_link').siblings('ul').addClass('active');
        $('#import_link').addClass('active animate');
    }

    $('#logs').click(function(e) {
        if (getPageName == 'logs') {
            e.preventDefault();
        }
    })




    //select all checkboxes
    $("#select_all").change(function() { //"select all" change
        var status = this.checked; // "select all" checked status
        $('.checkbox').each(function() { //iterate all listed checkbox items
            this.checked = status; //change ".checkbox" checked status
        });
    });

    $('.checkbox').change(function() { //".checkbox" change

        if ($('.checkbox:checked').length > 1) {
            $('.list-controls a').addClass('active'); //change "select all" checked status to true
            $('.list-controls a').prop("disabled", true);
        } else {
            $('.list-controls a').removeClass('active');
            $('.list-controls a').prop("disabled", false);
        }
        //uncheck "select all", if one of the listed checkbox item is unchecked
        if (this.checked == false) { //if this item is unchecked
            $("#select_all")[0].checked = false; //change "select all" checked status to false
        }

        //check "select all" if all checkbox items are checked
        if ($('.checkbox:checked').length == $('.checkbox').length) {
            $("#select_all")[0].checked = true; //change "select all" checked status to true
        }

    });



    $('a[href=#ready]').click(function() {
        $(this).parents('li').addClass('active');
        $(this).parents('li').siblings().removeClass('active');
        $('#ready').addClass('active');
        $('#ready').siblings().removeClass('active');
    });

    $('a[href=#drafts]').click(function() {
        $(this).parents('li').addClass('active');
        $(this).parents('li').siblings().removeClass('active');
        $('#drafts').addClass('active');
        $('#drafts').siblings().removeClass('active');
    });

    $('a[href=#tweeted]').click(function() {
        $(this).parents('li').addClass('active');
        $(this).parents('li').siblings().removeClass('active');
        $('#tweeted').addClass('active');
        $('#tweeted').siblings().removeClass('active');
    });

    $('a[href=#archived]').click(function() {
        $(this).parents('li').addClass('active');
        $(this).parents('li').siblings().removeClass('active');
        $('#archived').addClass('active');
        $('#archived').siblings().removeClass('active');
    });


    $.uploadPreview({
        input_field: "#media_upload1", // Default: .image-upload
        preview_box: "#image-preview", // Default: .image-preview
        label_field: "#image-label", // Default: .image-label
        label_default: "Choose File", // Default: Choose File
        label_selected: "Change File", // Default: Change File
        no_label: false // Default: false
    });


    $('.t-data li.message').each(function() {
        $(this).text().replace(/#[a-z0-1A-Z]+/g, '<span style="color: blue;">$&</span>');
    });



    $(document).click(function(e) {
        e.stopPropagation();
        $(this).find('.controls').find('.list').removeClass('active animate');
    });






    // InView Plugin Code
    if ($(window).width() > 1024) {

        $('.feature-section').on('inview', function(event, isInView) {
            if (isInView) {
                $(this).addClass("inview");
            }
            // else {
            //   $(this).removeClass("inview");
            // }
        });
    }

    if ($("#draft_now, #post_now").length > 0) {
        $("#draft_now, #post_now").on("click", function (event) {
            if ($(this).attr("id") === "post_now") {
                $("#post_state").val("ready");
                $("#post_tweet_now").val("on");
            }else {
                $("#post_state").val("drafted");
                $("#post_tweet_now").val(null);
            }
        });
    }
});

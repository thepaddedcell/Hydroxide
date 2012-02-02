$(window).bind('hashchange', function() {
    var hash = location.hash.replace("#", "");
    $("#title").html(hash);
    
    $('#content').children().each(function () {
        $(this).css("display", "none");
    });
    
    $("#" + hash).css("display", "block");
});

function native(command)
{
    window.location = "native://" + command;
}

function popup(msg)
{
    alert(msg);
}
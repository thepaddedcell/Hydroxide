$(window).bind('hashchange', function() {
    var hash = location.hash.replace("#", "");
    $("#title").html(hash);
});

function native(command)
{
    window.location = "native://" + command;
}

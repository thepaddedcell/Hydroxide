$(window).bind('hashchange', function() {
    var hash = location.hash.replace("#", "");
    $("#section").html(hash);
});

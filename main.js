var activePage = 1,
    offsetIndex = [];

function init() {
    bindPageSwitch();
    bindVerdict();
    bindGroups();

    buildGroups();
}

function buildGroups() {
    var groups = $("#groups");

    $(".group").each(function(i, e) {
        var elem = $(e);

        elem
            .append("" +
                "<div><img src='http://placehold.it/100x100' style='margin-left: 5px; margin-top: 5px; cursor: pointer;' />" +
                "<div style='text-align: center;' class='coolText'>" +
                "Group" + i +
                "</div>" +
                "</div>")
            .addClass('groupContainer')
            .click(function() {
                $("#group_edit")
                    .css('z-index', 1000)
                    .css('opacity', 1);
            });

    });

    $(".group_new").each(function(i, e) {
        var elem = $(e);

        elem
            .append("" +
                "<div style='font-size: 100px; text-align: center; color: #393939; cursor: pointer;'>" +
                "+" +
                "</div>")
            .addClass('groupContainer')
            .click(function() {
                $("#group_edit")
                    .css('z-index', 1000)
                    .css('opacity', 1);
            });

    });

    $(".cat_dyn").each(function(i, e) {
        var elem = $(e);

        offsetIndex[i] = elem.position().top;
    });

    for (var i = offsetIndex.length - 1; i >= 0; i--) {
        offsetIndex[i] -= offsetIndex[0];
    }

    groups.scroll(function(e) {
        updateScroll();
    });

    updateScroll();
}

function updateScroll() {
    var groups = $("#groups");

    $(".cat_dyn").each(function(i, e) {
        var elem = $(e),
            offset = groups.scrollTop();

        if(offsetIndex[i] - i * 30 < offset) {
            $("#cat_top" + (i + 1)).css('display', 'block');

        } else {
            $("#cat_top" + (i + 1)).css('display', 'none');
        }

        if(offsetIndex[i] + (3 - i) * 30 + 50 > offset + 570) {
            $("#cat_bot" + (i + 1)).css('display', 'block');

        } else {
            $("#cat_bot" + (i + 1)).css('display', 'none');
        }
    });
}

function bindGroups() {
    var groups = $("#groups");

    $('#cat_bot1').click(function() { groups.scrollTop(offsetIndex[0] )});
    $('#cat_bot2').click(function() { groups.scrollTop(offsetIndex[1] )});
    $('#cat_bot3').click(function() { groups.scrollTop(offsetIndex[2] )});
    $('#cat_bot4').click(function() { groups.scrollTop(offsetIndex[3] )});

    $('#cat_top1').click(function() { groups.scrollTop(offsetIndex[0] )});
    $('#cat_top2').click(function() { groups.scrollTop(offsetIndex[1] )});
    $('#cat_top3').click(function() { groups.scrollTop(offsetIndex[2] )});
    $('#cat_top4').click(function() { groups.scrollTop(offsetIndex[3] )});

    $("#group_add").click(function () {
        $("#group_info_form").toggleClass("group_info_form_expanded");
    });
}

function bindVerdict() {
    function hideGroupEdit() {
        $("#group_edit")
            .css('z-index', -1)
            .css('opacity', 0);
    }

    $("#scanner").click(function() {
        $("#verdict")
            .css('opacity', 1)
            .css('z-index', 1);
    });

    $(".ingr").click(function(e) {
        var elem = $(this),
            inf = elem.find('.ingr_info');

        if (inf.height() > 0) {
            inf.css('height', 0);
            inf.css('padding', 0);
        } else {
            inf.css('height', 60);
            inf.css('padding', 5);
        }

    });

    $("#scanNew").click(function() {
        $("#verdict")
            .css('opacity', 0)
            .css('z-index', -1);
    });

    $("#viewMore").click(function(e) {
        $("#ingredients").toggleClass('ingredients_expanded');
    });

    $("#group_back").click(hideGroupEdit);
    $("#group_save").click(hideGroupEdit);
}

function bindPageSwitch() {
    $(document.body).click(function (e) {
        if(e.clientX / $(document.body).width() < 0.25) {
            prevPage();
        }

        if(e.clientX / $(document.body).width() > 0.75) {
            nextPage();
        }
    });
}

function nextPage() {
    $("#pageContainer").removeClass('page' + activePage);
    activePage = Math.min(3, activePage + 1);
    $("#pageContainer").addClass('page' + activePage);
}

function prevPage() {
    $("#pageContainer").removeClass('page' + activePage);
    activePage = Math.max(1, activePage - 1);
    $("#pageContainer").addClass('page' + activePage);
}
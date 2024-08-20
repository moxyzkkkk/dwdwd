var type = "player";
var disabled = false;
var disabledFunction = null;
var inventoryOpen = false;

function money(n, c, d, t) {
    var c = isNaN(c = Math.abs(c)) ? 2 : c, d = d == undefined ? "." : d, t = t == undefined ? "," : t, s = n < 0 ? "-" : "", i = String(parseInt(n = Math.abs(Number(n) || 0).toFixed(c))), j = (j = i.length) > 3 ? j % 3 : 0;
    return s + (j ? i.substr(0, j) + t : "") + i.substr(j).replace(/(\d{3})(?=\d)/g, "$1" + t);
};

function itemCount(item) {
    count = item.count

    if (item.limit > 0) { count = item.count + " / " + item.limit; }
    if (item.type === "item_weapon") { if (count == 0) { count = ""; } else { count = '<img src="img/bullet.png" class="ammoIcon"> ' + item.count; }; }
    if (item.type === "item_account" || item.type === "item_money") { count = money(item.count); }

    return count;
};

function setupPlayer(items) {
    $("#player").html("");
    $.each(items, function (index, item) {
        $("#player").append('<div class="slot"><div id="item-' + index + '" class="item" style = "background-image: url(\'img/' + item.name + '.png\')"> <div class="item-count">' + itemCount(item) + '</div><div class="item-name">' + item.label + '</div></div></div>');
        $('#item-' + index).data('item', item);
        $('#item-' + index).data('inventory', "main");
    });
}

function setupOther(items) {
    $("#other").html("");
    $.each(items, function (index, item) {
        $("#other").append('<div class="slot"><div id="itemOther-' + index + '" class="item" style = "background-image: url(\'img/' + item.name + '.png\')"> <div class="item-count">' + itemCount(item) + '</div><div class="item-name">' + item.label + '</div></div></div>');
        $('#itemOther-' + index).data('item', item);
        $('#itemOther-' + index).data('inventory', "second");
    });
}

function Interval(time) {
    var timer = false;
    this.start = function () { if (this.isRunning()) { clearInterval(timer); timer = false; } timer = setInterval(function () { disabled = false; }, time); };
    this.stop = function () { clearInterval(timer); timer = false; };
    this.isRunning = function () { return timer !== false; };
}

function disable(ms) {
    disabled = true;
    if (disabledFunction === null) { disabledFunction = new Interval(ms); disabledFunction.start(); } else { if (disabledFunction.isRunning()) { disabledFunction.stop(); } disabledFunction.start(); }
}

window.addEventListener("message", function (event) {
    var v = event.data;

    if (v.action == "display") {
        type = v.type; disabled = false; inventoryOpen = true;
        if (type === "normal") { 
            $(".otherInv").hide() 
        } else { 
            $(".otherInv").show() 
            $("#type2").html(v.text)
        }
        $(".ui").fadeIn();
        
    } else if (v.action == "hide") {
        $(".ui").fadeOut(); 
        $(".item").remove();
        inventoryOpen = false;

    } else if (v.action == 'avatar') {
        $("#avatar").css("background-image", "url("+v.avatar+")")

    } else if (v.action == "setPlayerItems") {
        setupPlayer(v.playerItems);

        $('.item').draggable({ helper: 'clone', appendTo: 'body', zIndex: 99999, revert: 'invalid',
            start: function (event, ui) {
                if (disabled) { $(this).stop(); return; }

                $(this).css('background-image', 'none');
                itemData = $(this).data("item");
                itemInventory = $(this).data("inventory");
            },
            stop: function () {
                itemData = $(this).data("item");

                if (itemData !== undefined && itemData.name !== undefined) {
                    $(this).css('background-image', 'url(\'img/' + itemData.name + '.png\'');
                }
            }
        }); 
    } else if (v.action == "setOtherItems") {
        setupOther(v.otherItems);
    }
});

$(document).ready(function () {
    $("#amount").focus(function () { $(this).val(""); }).blur(function () { if ($(this).val() == "") { $(this).val("1") } });

    $('#use').droppable({
        hoverClass: 'hoverControl',
        drop: function (event, ui) {
            itemData = ui.draggable.data("item");
            if (itemData == undefined || itemData.usable == undefined) { return; }
            itemInventory = ui.draggable.data("inventory");
            if (itemInventory == undefined || itemInventory == "second") { return; }
            if (itemData.usable) {
                disable(300);
                $.post("https://inventory/UseItem", JSON.stringify({ item: itemData }));
            }
        }
    });

    $('#player').on('dblclick', '.item', function () {
        itemData = $(this).data("item");

        if (itemData == undefined || itemData.usable == undefined) { return; }
        itemInventory = $(this).data("inventory");
        if (itemInventory == undefined || itemInventory == "second") { return; }
        if (itemData.usable) {
            disable(300);
            $.post("https://inventory/UseItem", JSON.stringify({ item: itemData }));
        }
    });

    $('#give').droppable({
        hoverClass: 'hoverControl',
        drop: function (event, ui) {
            itemData = ui.draggable.data("item");
            if (itemData == undefined || itemData.canRemove == undefined) { return; }
            itemInventory = ui.draggable.data("inventory");
            if (itemInventory == undefined || itemInventory == "second") { return; }
            if (itemData.canRemove) {
                disable(300);
                $.post("https://inventory/GiveItem", JSON.stringify({ item: itemData, number: parseInt($("#amount").val()) }));
            }
        }
    });

    $('#drop').droppable({
        hoverClass: 'hoverControl',
        drop: function(event, ui) {
            itemData = ui.draggable.data("item");
            if (itemData == undefined || itemData.canRemove == undefined) { return; }
            itemInventory = ui.draggable.data("inventory");
            if (itemInventory == undefined || itemInventory == "second") { return; }

            if (itemData.canRemove) {
                disable(300);
                $.post("https://inventory/DropItem", JSON.stringify({ item: itemData, number: parseInt($("#amount").val()) }));
            }
        }
    });

    $('#player').droppable({
        drop: function (event, ui) {
            itemData = ui.draggable.data("item");
            itemInventory = ui.draggable.data("inventory");

            if (type === "trunk" && itemInventory === "second") {
                disable(500); $.post("https://inventory/TakeFromTrunk", JSON.stringify({ item: itemData, number: parseInt($("#amount").val()) }));
                disable(500); $.post("https://inventory/TakeFromStorage", JSON.stringify({ item: itemData, number: parseInt($("#amount").val()) }));
            }
        }
    });

    $('#other').droppable({
        drop: function (event, ui) {
            itemData = ui.draggable.data("item");
            itemInventory = ui.draggable.data("inventory");

            if (type === "trunk" && itemInventory === "main") {
                disable(500); $.post("https://inventory/PutIntoTrunk", JSON.stringify({ item: itemData, number: parseInt($("#amount").val()) }));
            }
        }
    });

    $("#amount").on("keypress keyup blur", function (event) {
        $(this).val($(this).val().replace(/[^\d].+/, ""));
        if ((event.which < 48 || event.which > 57)) { event.preventDefault(); }
    });
});

$.widget('ui.dialog', $.ui.dialog, {
    options: { clickOutside: false, clickOutsideTrigger: '' },
    open: function () {
        var clickOutsideTriggerEl = $(this.options.clickOutsideTrigger), that = this;
        if (this.options.clickOutside) {
            $(document).on('click.ui.dialogClickOutside' + that.eventNamespace, function (event) {
                var $target = $(event.target);
                if ($target.closest($(clickOutsideTriggerEl)).length === 0 && $target.closest($(that.uiDialog)).length === 0) { that.close(); }
            });
        }
        this._super();
    },
    close: function () { $(document).off('click.ui.dialogClickOutside' + this.eventNamespace); this._super(); },
});
$(document).keyup((e) => {
    if (e.key === 'Escape' && inventoryOpen === true) {
        $.post("https://inventory/closeInventory", JSON.stringify({ type: type }));
    };
});
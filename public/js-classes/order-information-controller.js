function OrderInformationController () {
    this.init = function() {
        var deferred = $.Deferred();
        $('#nav-container').append(NavBar.createMarkup());
        $('#order-items-panel').append(PanelOrderItems.createMarkup());
        $('#order-items-panel-sm').append(PanelOrderItemsSmall.createMarkup());
        $('#main').append(ModalDelivery.createMarkup('modal-delivery', 'HOW WOULD YOU LIKE YOUR ORDER?','NO'));
        OrderItems.buildYourOrder(); 
        $("#email_address").val($.session.get("email")); 
        $("#confirm_email_address").val($.session.get("email"));
        $("#first_name").val($.session.get("firstName"));
        $("#last_name").val($.session.get("lastName"));
        $("#address").val($.session.get("addressLine1"));
        $("#city").val($.session.get("city"));
        $("#state").val($.session.get("state"));
        $("#zipCode").val($.session.get("zip"));
    }

    buildItemForGridPanel = function(name,detail) {
        html = "<div id=\"grid-block\" class=\"col-md-5\">";
        html += "<table id=\"grid-table\"><tr><td><img src=\"/img/pizza-background.jpg\" width=\"100\" height=\"100\"></td>";
        html += "<td><table><tr><td colspan=2>";
        html += "<p class=\"header\">" + name + "</p>";
        html += "</td></tr><tr><td colspan=2>";
        html += "<p class=\"body\">" + detail + "</p>";
        html += "</td><tr><td><button class=\"red-gradient-button\" onClick=\"$('#modify-item-modal').modal()\">ORDER NOW</button></td><td><button class=\"red-gradient-button\">SEE DETAILS</button></td></tr></table></td></tr></table></div>";
        return html;
    }
}

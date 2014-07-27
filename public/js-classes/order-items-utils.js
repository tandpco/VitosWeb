function ModalModifyPizzaItem() {}
ModalModifyPizzaItem.createMarkup = function () {
    var html = "";
    //html += '<div class="modal fade" id="modal-modify-item">';
    html += '    <div class="modal-dialog modal-lg">';
    html += '        <div class="modal-content">';
    html += '            <div class="modal-header">';
    html += '                <img onclick="pageController.cancel()" src=';
    html += '                "/img/closebutton.png" data-dismiss="modal"';
    html += '                aria-hidden="true">';
    html += '';
    html += '                <ul class="nav nav-tabs">';
    html += '                    <li class="active"><a class="white-no-shadow"';
    html += '                    href="#size-and-crust" data-toggle="tab">SIZE';
    html += '                    &amp; TYPE</a></li>';
    html += '';
    html += '                    <li><a class="white-no-shadow" href=';
    html += '                    "#cheese-and-sauce" data-toggle="tab">SAUCE</a></li>';
    html += '';
    html += '                    <li><a class="white-no-shadow" href="#toppings"';
    html += '                    data-toggle="tab">TOPPINGS</a></li>';
    html += '                </ul>';
    html += '            </div>';
    html += '';
    html += '            <div class="modal-body">';
    html += '                <div class="tab-content">';
    html += '                    <div class="tab-pane fade active in" id=';
    html += '                    "size-and-crust">';
    html += '                        <table>';
    html += '                            <tr>';
    html += '                                <td valign="top">';
    html += '                                    <ul class="left-column" style=';
    html += '                                    "margin:0px;padding:0px;list-style-type:none">';
    html += '                                    </ul>';
    html += '                                </td>';
    html += '';
    html += '                                <td valign="top">';
    html += '                                    <ul class="right-column" style=';
    html += '                                    "margin:0px;padding:0px;list-style-type:none;"></ul>';
    html += '                                </td>';
    html += '                            </tr>';
    html += '                        </table>';
    html += '                    </div>';
    html += '';
    html += '                    <div class="tab-pane fade" id=';
    html += '                    "cheese-and-sauce">';
    html += '                        <table>';
    html += '                            <tr>';
    html += '                                <td valign="top">';
    html += '                                    <ul class="left-column" style=';
    html += '                                    "margin:0px;padding:0px;list-style-type:none">';
    html += '                                    </ul>';
    html += '                                </td>';
    html += '';
    html += '                                <td valign="top">';
    html += '                                    <ul class="right-column" style=';
    html += '                                    "margin:0px;padding:0px;list-style-type:none;">';
    html += '                                    </ul>';
    html += '                                </td>';
    html += '                            </tr>';
    html += '                        </table>';
    html += '                    </div>';
    html += '';
    html += '                    <div class="tab-pane fade" id="toppings">';
    html += '                        <table>';
    html += '                            <tr>';
    html += '                                <td valign="top">';
    html += '                                    <ul class="left-column" style=';
    html += '                                    "margin:0px;padding:0px;list-style-type:none">';
    html += '                                    </ul>';
    html += '                                </td>';
    html += '                            </tr>';
    html += '                        </table>';
    html += '                    </div>';
    html += '                </div>';
    html += '';
    html += '                <div>';
    html += '<span  style="font-weight:bold">Quantity :</li></ul>';
    html += '                                    <input id="quantity" type=';
    html += '                                    "text" readonly style=';
    html += '                                    "margin-top:20px; " class="col-md-8">';
    html += '                                    <script type=';
    html += '                                    "text/javascript">';
    html += '';
    html += '                                    $("#quantity").TouchSpin({';
    html += '                                    min: 1,';
    html += '                                    max: 10,';
    html += '                                    stepinterval: 1,';
    html += '                                    maxboostedstep: 2,';
    html += '                                    initval:1';
    html += '                                    });';
    html += '                                    </script>';

    html += '                    <button onclick=';
    html += '                    "pageController.updateQuantity(' + '\'#quantity\'' + ');pageController.order()" type=';
    html += '                    "button" class="red-gradient-button">ORDER ';
    html += '                    NOW</button> <button id=';
    html += '                    "modify-items-close-button" onclick=';
    html += '                    "pageController.cancel()" type="button" class=';
    html += '                    "red-gradient-button" data-dismiss=';
    html += '                    "modal">CANCEL</button>';
    html += '                </div>';
    html += '            </div>';
    html += '        </div>';
    html += '    </div>';
    //html += '</div>';
    return html;
}

function ModalModifyOrderItem() {}
ModalModifyOrderItem.createMarkup = function () {
    var html = "";
    html += '    <div class="modal-dialog modal-lg">';
    html += '        <div class="modal-content">';
    html += '            <div class="modal-header">';
    html += '                <img onclick="pageController.cancel()" src=';
    html += '                "/img/closebutton.png" data-dismiss="modal"';
    html += '                aria-hidden="true">';
    html += '';
    html += '                <ul class="nav nav-tabs">';
    html += '                    <li class="active"><a class="white-no-shadow"';
    html += '                    href="#size-and-crust1" data-toggle="tab">SIZE';
    html += '                    &amp; TYPE</a></li>';
    html += '';
    html += '                    <li><a class="white-no-shadow" href=';
    html += '                    "#cheese-and-sauce1" data-toggle="tab">SAUCE</a></li>';
    html += '';
    html += '                    <li><a class="white-no-shadow" href="#toppings1"';
    html += '                    data-toggle="tab">TOPPINGS</a></li>';
    html += '                </ul>';
    html += '            </div>';
    html += '';
    html += '            <div class="modal-body">';
    html += '                <div class="tab-content">';
    html += '                    <div class="tab-pane fade active in" id=';
    html += '                    "size-and-crust1">';
    html += '                        <table>';
    html += '                            <tr>';
    html += '                                <td valign="top">';
    html += '                                    <ul class="left-column" style=';
    html += '                                    "margin:0px;padding:0px;list-style-type:none">';
    html += '                                    </ul>';
    html += '                                </td>';
    html += '';
    html += '                                <td valign="top">';
    html += '                                    <ul class="right-column" style=';
    html += '                                    "margin:0px;padding:0px;list-style-type:none;"></ul>';
    html += '                                </td>';
    html += '                            </tr>';
    html += '                        </table>';
    html += '                    </div>';
    html += '';
    html += '                    <div class="tab-pane fade" id=';
    html += '                    "cheese-and-sauce1">';
    html += '                        <table>';
    html += '                            <tr>';
    html += '                                <td valign="top">';
    html += '                                    <ul class="left-column" style=';
    html += '                                    "margin:0px;padding:0px;list-style-type:none">';
    html += '                                    </ul>';
    html += '                                </td>';
    html += '';
    html += '                                <td valign="top">';
    html += '                                    <ul class="right-column" style=';
    html += '                                    "margin:0px;padding:0px;list-style-type:none;">';
    html += '                                    </ul>';
    html += '                                </td>';
    html += '                            </tr>';
    html += '                        </table>';
    html += '                    </div>';
    html += '';
    html += '                    <div class="tab-pane fade" id="toppings1">';
    html += '                        <table>';
    html += '                            <tr>';
    html += '                                <td valign="top">';
    html += '                                    <ul class="left-column" style=';
    html += '                                    "margin:0px;padding:0px;list-style-type:none">';
    html += '                                    </ul>';
    html += '                                </td>';
    html += '                            </tr>';
    html += '                        </table>';
    html += '                    </div>';
    html += '                </div>';
    html += '';
    html += '                <div>';
    html += '<span  style="font-weight:bold" id="qntyHolder"></span>';
    html += '                                    <input id="quantity1" type=';
    html += '                                    "text" readonly style=';
    html += '                                    "margin-top:20px; " class="col-md-8">';
    html += '                                    <script type=';
    html += '                                    "text/javascript">';
    html += '';
    html += '                                    $("#quantity1").TouchSpin({';
    html += '                                    min: 1,';
    html += '                                    max: 10,';
    html += '                                    stepinterval: 1,';
    html += '                                    maxboostedstep: 2,';
    html += '                                    initval:1';
    html += '                                    });';
    html += '                                    </script>';
    html += '                    <button onclick=';
    html += '                    "pageController.updateQuantity(' + '\'#quantity1\'' + ');OrderItems.UpdateOrderItem()" type=';
    html += '                    "button" class="red-gradient-button">UPDATE';
    html += '                    </button> <button id=';
    html += '                    "modify-items-close-button" onclick=';
    html += '                    "pageController.cancel()" type="button" class=';
    html += '                    "red-gradient-button" data-dismiss=';
    html += '                    "modal">CANCEL</button>';
    html += '                </div>';
    html += '            </div>';
    html += '        </div>';
    html += '    </div>';
    //html += '</div>';
    return html;
}


function PanelOrderItemsSmall() {}
PanelOrderItemsSmall.createMarkup = function () {
    var html = "";
    var curr_loc = window.location.pathname;

    html += '<div class="panel-group" id="main-accordion">';
    html += '    <div class="panel panel-default">';
    html += '        <div class="panel-heading" style="background-color:#A49670">';
    html += '            <h4 class="panel-title">';
    html += '                 <a data-toggle="collapse" data-parent="#main-accordion" style="color:#fff;"  href="#childacc">';
    html += '                    <span class="itemSize">YOUR ORDER</span>';
    html += '                    <i class="glyphicon glyphicon-chevron-right" style="float:right"/>';
    html += '                 </a>';
    html += '            </h4>';
    html += '        </div>';
    html += '';
    html += '        <div id="childacc" class="panel-collapse collapse">';
    html += '            <div class="panel-body" id="childacc-container">';
    html += '                <table id="order-table-sm" cellspacing="10">';
    html += '                    <tbody></tbody>';
    html += '                </table>';
    html += '<br>';
    if (curr_loc.indexOf("confirmation") == -1) {
        html += '                <div width="100%" style="background-color:#A49685">';
        html += '                    <table id="promo" width="100%">';
        html += '                            <tr> ';
        html += '                                <td style="width:50%;text-align:center"> Enter your promo code </td>';
        html += '                                    <td><div class="col-lg-6" style="width:100%" >';
        html += '                                        <div class="input-group" style="margin-left:-10%">';
        html += '                                            <input type="text" class="form-control" id="promoCode-sm">';
        html += '                                                <span class="input-group-btn">';
        html += '                                                    <button class="btn btn-default" type="button" onclick="pageController.updatePromo()">Apply</button>';
        html += '                                                </span>';
        html += '                                           </input>';
        html += '                                        </div>';
        html += '                                    </div>';
        html += '                                </td>';
        html += '                            </tr>';
        html += '                    </table>';
        html += '                </div>';
    }
    html += '                <table id="order-totals-table-sm" cellspacing="10" width="100%" style="background-color:#BDAFA0">';
    html += '                    <thead>';
    html += '                        <tr>';
    html += '                            <th colspan="2">Order Total</th>';
    html += '                        </tr>';
    html += '                    </thead>';
    html += '                    <tbody></tbody>';
    html += '                </table>';
    html += '                <br><br>';
    html += '            </div>';
    html += '        </div>';
    html += '    </div>';
    html += '</div>';
    html += '<script  type="text/javascript"> $(function () { $("#main-accordion").click(function (e) { ';
    html += '$(e.target).siblings("i").toggleClass("glyphicon-chevron-right glyphicon-chevron-down");';
    html += '});';
    html += '});</script>';
    return html;
}

function PanelOrderItems() {}
PanelOrderItems.createMarkup = function () {
    var html = "";
    var curr_loc = window.location.pathname;

    html += '<table id="order-table-right" cellspacing="10" width="90%">';
    html += '    <thead>';
    html += '        <tr>';
    html += '            <th colspan="2">YOUR ORDER</td>';
    html += '        </tr>';
    html += '    </thead>';
    html += '    <tbody></tbody>';
    html += '</table>';
    html += '<br>';
    if (curr_loc.indexOf("confirmation") == -1) {
        html += '<div width="100%" style="background-color:#A49685">';
        html += '    <table id="promo" width="100%">';
        html += '        <tr>';
        html += '           <td style="width:50%;text-align:center"> Enter your promo code </td>';
        html += '                <td>';
        html += '                  <div class="col-lg-6" style="width:100%" >';
        html += '                     <div class="input-group" style="margin-left:-10%">';
        html += '                        <input type="text" class="form-control" id="promoCode-lg">';
        html += '                        <span class="input-group-btn">';
        html += '                            <button class="btn btn-default" type="button" onclick="pageController.updatePromo()">Apply</button>';
        html += '                        </span>';
        html += '                      </div>';
        html += '                    </div>';
        html += '                 </td>';
        html += '             </tr>';
        html += '    </table>';
        html += '</div>';
    }
    html += '<table id="order-totals-table-right" cellspacing="10" width="100%" style="background-color:#BDAFA0">';
    html += '    <thead>';
    html += '        <tr>';
    html += '            <th colspan="2">Order Total</th>';
    html += '        </tr>';
    html += '    </thead>';
    html += '    <tbody></tbody>';
    html += '</table>';
    html += '<br><br>';
    return html;
}

function OrderItems() {}
OrderItems.buildYourOrder = function () {
    var orderDivArray = new Array();
    orderDivArray.push('right', 'sm');


    // Process all divs that need order data
    for (var orderDivIndex = 0; orderDivIndex < orderDivArray.length; orderDivIndex++) {

        var divName = orderDivArray[orderDivIndex];

        // Totals
        var orderSubTotal = Number(0.00);

        var html = "";
        html = "<tr>";
        html += '    <td>' + $.session.get('email') + ' (<a id="delivery-mode" style="font-size:80%;cursor: pointer; cursor: hand;color:#000;text-decoration:underline" onClick="+$(\'#modal-delivery\').modal()">' + $.session.get('mode') + '</a>) (<a href="#" onclick="CommonUtils.chooseStore()">' + $.session.get('storeAddress') + ')</a></td>';
        html += "</tr>";

        // Process all order items
        var orderItems = JSON.parse($.session.get('orderItems'));
        var curr_loc = window.location.pathname;

        var userPromos = JSON.parse($.session.get('userPromoCodes'));
        var promoCost = 0.0;

        for (var j = 0; j < userPromos.length; j++) {
            promoCost += Number(userPromos[j]['cost']);
        }

        for (var i = 0; i < orderItems.length; i++) {
            var orderItem = orderItems[i];
            //console.log(orderItem);

            var cost = Number(orderItem['cost']);
            orderSubTotal += (cost * Number(orderItem['quantity']));
            var orderCost = (cost * Number(orderItem['quantity']));

            html += '<tr>';
            html += '    <td>';
            html += '        <div class="panel-group" id="accordion-' + divName + '-' + orderItem['id'] + '">'
            html += '            <div class="panel panel-default">'
            html += '                <div style="height: 38px; background-color:#A49685;">'
            html += '                    <h3 class="panel-title">'
            html += '                       <div class="col-xs-9"> '
            html += '                         <a class="accordion-toggle" data-toggle="collapse" style="color:#fff;font-size:14px" data-parent="#accordion-' + divName + '-' + orderItem['id'] + '" href="#order-item-detail-' + divName + '-' + orderItem['id'] + '">'
            if (orderItem['orderType'] == "PIZZA") {
                html += '       <span class="itemSize">' + orderItem['size']['description'] + '</span> '
            }
            html += '<span class="itemDescription">' + orderItem['item']['name'] + '(' + orderItem['quantity'] + ')';
            if (curr_loc.indexOf("confirmation") == -1) {
                // html += '<br> <span class="badge"><a style="font-size:80%;cursor: pointer; cursor: hand;text-decoration:underline;color:#000" onClick="pageController.updateOrder(' + orderItem['id'] + ');">Edit</a></span>&nbsp;&nbsp;';
                html += '<a style="font-size:80%;cursor: pointer; cursor: hand;text-decoration:underline;color:#000" onClick="OrderItems.cancelOrder(' + orderItem['id'] + ');">Remove</a>';
            }
            html += '</div></span><div style="height:38px;font-size:15px;float:right;" class="col-sm-2"> <div class="row" style="float:right"><br>$ ' + orderCost.toFixed(2) + '</div></div>'
            html += '                         </a>'
            html += '                    </div></h3>'
            html += '                </div>'
            html += '                <div id="order-item-detail-' + divName + '-' + orderItem['id'] + '" class="panel-collapse collapse">'
            html += '                    <div class="panel-body">'
            if (orderItem['orderType'] == "PIZZA") {
                html += '                        <p>Sauce: ' + orderItem['sauce']['description'] + '</p>'
            }
            html += '                        <p>Sauce Options: ' + orderItem['sauceModifier']['description'] + '</p>'
            html += '                        <p>Toppings: <br>'
            // Toppings
            var toppings = orderItem['toppings']
            if(toppings) {
                for (var toppingIndex = 0; toppingIndex < toppings.length; toppingIndex++) {
                    var topping = toppings[toppingIndex];
                    html += topping['description'] + ' - ' + topping['portion'] + "<br>";
                }
            }
            html += '                        </p>'
            html += '                    </div>'
            html += '                </div>'
            html += '            </div>'
            html += '        </div>'
            html += '    </td>';
            html += "</tr>";
        }

        html += buildPromoAccordion(promoCost, userPromos, divName);
        $('#order-table-' + divName + ' > tbody').html(html);

        // Order Totals
        var orderTaxes = 0;
        var orderTip = 0;
        var orderDeliveryCharge = 0;
        var orderDriverMoney = 0;
        var orderTotal = 0;

        if ($.session.get('orderTax')) {
            orderTaxes = Number($.session.get('orderTax'));
        }

        if ($.session.get('orderTax2')) {
            orderTaxes2 = Number($.session.get('orderTax2'));
            orderTaxes  += orderTaxes2;
        }
        orderTip = Number($.session.get('orderTip'));
        orderDeliveryCharge = Number($.session.get('orderDeliveryCharge'));
        orderDriverMoney = Number($.session.get('orderDriverMoney'));
        orderTotal = orderSubTotal + orderTaxes + orderTip - promoCost; //Subtracting promocode price    

        html = "";

        html += '<tr>';
        html += '    <td>SUB TOTAL</td>';
        html += '    <td align="right">$ ' + orderSubTotal.toFixed(2) + '</th>';
        html += '</tr>';
        html += '<tr>';
        html += '    <td>TAXES</td>';
        html += '    <td align="right">$ ' + orderTaxes.toFixed(2) + '</span></th>';
        html += '</tr>';
        html += '<tr>';
        html += '    <td>TIP</td>';
        html += '    <td align="right"> $ ';
 
        if (curr_loc.indexOf("confirmation") != -1) {
            html += orderTip.toFixed(2);
        } else {
            html += '<input type="text" class="ordrTip" value="' + orderTip + '" maxlength="4" size="4" style="text-align:right" onchange="OrderItems.clearField(this.value)"/>';
        }
        html += '</td>';
        html += '</tr>';
        if (curr_loc.indexOf("confirmation") == -1) {
            html += ' <tr><td align="right" colspan="2"> <a style="font-size:80%;cursor: pointer; cursor: hand;text-decoration:underline;color:#000" onclick="OrderItems.UpdateTip()">Apply</a></td>';
            html += '</tr>';
        }

        html += '<tr>';
        html += '    <th colspan="2"><hr></th>';
        html += '</tr>';
        html += '<tr>';
        html += '    <td>TOTAL</td>';
        html += '    <td align="right" id="total">$ ' + orderTotal.toFixed(2) + '</td>';
        html += '</tr>';
        html += '<tr>';
        if (curr_loc.indexOf("information") == -1 && curr_loc.indexOf("confirmation") == -1) {
            if (orderItems.length > 0)
                html += '    <th colspan="2"><hr> <button onclick="window.location.href=\'/order-information\'" type="button" class="red-gradient-button">SUBMIT ORDER</button></td>';
        }
        html += '</tr>';

        $('#order-totals-table-' + divName + ' > tbody').html(html);

    }


    // this method helps to cancel the order. It cancels one order at a time.
    OrderItems.cancelOrder = function (id) {
        var json = {
            "OrderLineID": id
        }

        //An ajax call to cancel the order in the back end
        $.ajax({
            url: "/rest/view/tblorderlines/delete-tblorderlines",
            type: "POST",
            data: JSON.stringify(json),
            success: function (data) {

                //It updates the orderItems resides in session after deletion
                var orderItems = JSON.parse($.session.get('orderItems'));
                var updatedOrderItems = new Array();

                for (var i = 0; i < orderItems.length; i++) {
                    var orderItem = orderItems[i];
                    if (orderItem['id'] != id) {
                        updatedOrderItems.push(orderItem);
                    }
                }

                $.session.set('orderItems', JSON.stringify(updatedOrderItems));

                //It rebuilds the accordion after deletion
                OrderItems.buildYourOrder();
            }
        });
    }

    OrderItems.clearField = function (val) {
        $.session.set('currentTip', val);
    }

    OrderItems.UpdateTip = function () {
        var tip = $.session.get('currentTip');

        if (tip == null || tip == undefined || isNaN(parseFloat(tip)))
            tip = 0;
        $.session.set('orderTip', tip);

        OrderItems.buildYourOrder();
    }
    OrderItems.UpdateOrderItem = function () {
        $('#modal-modify-item1').modal('hide');
        $('#modal-please-wait').modal('show');
        var orderLineId = $.session.get('selectedOrderLineId');
        if (orderLineId) {
            var orderItems = JSON.parse($.session.get('orderItems'));
            var selectedOrderItem;

            for (var i = 0; i < orderItems.length; i++) {
                var orderItem = orderItems[i];
                if (orderItem['id'] == orderLineId) {
                    selectedOrderItem = orderItem;
                }
            }

            if (selectedOrderItem) {
                selectedOrderItem['quantity'] = $.session.get('quantity');
                //size

                var sizeId = $.session.get('sizeId');
                var sizeInSsn = JSON.parse($.session.get(selectedOrderItem['orderType'] + '_SIZES'));
                for (var i = 0; i < sizeInSsn.length; i++) {
                    if (sizeId == sizeInSsn[i]['id']) {
                        selectedOrderItem['size'] = sizeInSsn[i];
                    }
                }

                //style

                var styleId = $.session.get('styleId');
                var styleInSsn = JSON.parse($.session.get(selectedOrderItem['orderType'] + '_STYLES'));
                for (var i = 0; i < styleInSsn.length; i++) {
                    if (styleId == styleInSsn[i]['id']) {
                        selectedOrderItem['style'] = styleInSsn[i];
                    }
                }

                // Get sauce
                var sauceId = $.session.get('sauceId');
                var sauceInSsn = JSON.parse($.session.get(selectedOrderItem['orderType'] + '_SAUCES'));
                for (var i = 0; i < sauceInSsn.length; i++) {
                    if (sauceId == sauceInSsn[i]['id']) {
                        selectedOrderItem['sauce'] = sauceInSsn[i];
                    }
                }

                // Get sauce modifier
                var sauceModifierId = $.session.get('sauceModifierId');
                if (sauceModifierId) {
                    var sauceModInSsn = JSON.parse($.session.get(selectedOrderItem['orderType'] + '_SAUCEMODIFIERS'));
                    for (var i = 0; i < sauceModInSsn.length; i++) {
                        if (sauceModifierId == sauceModInSsn[i]['id']) {
                            selectedOrderItem['sauceModifier'] = sauceModInSsn[i];
                        }
                    }
                } else {
                    selectedOrderItem['sauceModifier'] = {
                        id: "NULL",
                        description: ""
                    };
                }
                //topper

                selectedOrderItem['toppers'] = new Array();
                var selectedToppers = JSON.parse($.session.get('ToppersInEdit'));
                var topperInSsn = JSON.parse($.session.get(selectedOrderItem['orderType'] + '_TOPPERS'));

                for (var i = 0; i < selectedToppers.length; i++) {
                    var topperId = selectedToppers[i];
                    for (var j = 0; j < topperInSsn.length; j++) {
                        if (topperId == topperInSsn[j]['id']) {
                            selectedOrderItem['toppers'].push(topperInSsn[j]);
                        }
                    }
                }
                //topping

                var toppingsString = $.session.get('toppings');
                var toppings = toppingsString.split(',');

                selectedOrderItem['toppings'] = new Array();

                for (var i = 0; i < toppings.length; i++) {
                    var item = toppings[i];
                    var elements = item.split('-');

                    var itemId = elements[0];

                    var portion = elements[1].split('+')[0];
                    var topping = {};
                    topping['id'] = itemId;
                    topping['portion'] = portion;
                    topping['description'] = elements[1].split('+')[1];
                    selectedOrderItem['toppings'].push(topping);
                }

                $.session.set('orderItems', JSON.stringify(orderItems));
                $('#modal-please-wait').modal('hide');
                OrderItems.buildYourOrder();
            }
        }
    }
}

function buildPromoAccordion(promoCost, userPromos, divName) {
    var html = '';


    if (userPromos.length > 0) {
        html += '<tr>';
        html += '    <td>';
        html += '        <div class="panel-group" id="accordion-promo-' + divName + '">'
        html += '            <div class="panel panel-default">'
        html += '                <div style="background-color:#A49685;height:38px">'
        html += '                    <h3 class="panel-title">'
        html += '                         <div class="col-xs-9"> <a data-toggle="collapse" style="color:#fff;font-size:14px" data-parent="#accordion-promo-' + divName + '" href="#promo-detail-' + divName + '">'
        html += '<span style="font-size:14px;">Promo</span></a></div>';
        html += '<div class="col-sm-2" style="height:38px;font-size:15px;float:right;"><div style="float:right" class="row">$ -' + promoCost.toFixed(2);
        html += '                         </div></div>'
        html += '                    </h3>'
        html += '                </div>'
        html += '                <div id="promo-detail-' + divName + '" class="panel-collapse collapse ">'
        html += '                    <div class="panel-body" style="font-size:12px;background-color:#BDAFA0">' //A49670">'
        html += ' <div style="height:76px;width:25%;margin-top:-27px;margin-left:-25px" class="row titleimage"></div> ';
        for (var i = 0; i < userPromos.length; i++) {
            var userPromo = userPromos[i];
            html += '                        <p>Code : ' + userPromo['code'] + '</p>'
            html += '                        <p>Description : ' + userPromo['description'] + '</p>'
            html += '                        <p>Cost : $' + Number(userPromo['cost']).toFixed(2) + '</p>'
            if (i < userPromos.length - 1)
                html += '<hr>';
        }
        html += '                    </div>'
        html += '                </div>'
        html += '            </div>'
        html += '        </div>'
        html += '    </td>';
        html += '</tr>';
    }
    return html;
}

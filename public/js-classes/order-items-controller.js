function OrderItemsController () {
    this.items           = new Array();
    this.toppers         = new Array();
    this.sizes           = new Array();
    this.sauces          = new Array();
    this.styles          = new Array();
    this.sauceModifiers  = new Array();
    this.toppings        = new Array();
    this.buttonType = '';
    
    this.init = function() {
        var customerId = $.session.get("customerId");
        var email      = $.session.get("email");
        
        if(!email) {
            $.session.clear();
            window.location.href = "/sign-in";
        }
        
        $('#nav-container').append(NavBar.createMarkup());

        $('#main').append(ModalPleaseWait.createMarkup('modal-please-wait', 'Please wait'));
        $('#main').append(ModalInvalidPromo.createMarkup('modal-invalid-promo', 'Invalid promo code'));
        $('#main').append(ModalDelivery.createMarkup('modal-delivery', 'HOW WOULD YOU LIKE YOUR ORDER?','NO'));

        $('#modal-modify-item').append(ModalModifyPizzaItem.createMarkup());
        $('#modal-modify-item1').append(FakeModalModifyPizzaItem.createMarkup());
        
        $('#order-items-panel-sm').append(PanelOrderItemsSmall.createMarkup());
        $('#order-items-panel').append(PanelOrderItems.createMarkup());
        
        $.when(
            //OrderItems.buildYourOrder(),
            this.listSpecialties()
            //this.listSpecialties(),
            //this.listToppers(),
            //this.listSizes(),
            //this.listSauces(),
            //this.listStyles(),
            //this.listSauceModifiers(),
            //this.listToppings()
            
        ).then(function() {
            $('#modal-please-wait').modal('hide');
            console.log('Got all the data');
      
        });
    
        Session.set('selectedToppers', JSON.stringify(new Array()));
        Session.set('ToppersInEdit', JSON.stringify(new Array()));
       
       
    }  
    
    this.order = function() {
        $('#modal-modify-item').modal('hide');
        $('#modal-please-wait').modal('show');
        var orderId = $.session.get("orderId");
        // Check to see if this is the first time
        if(orderId) {
            this.createOrderItem();
        }
        else {
            this.createOrder();
        }
    }

    this.cancel = function() {
        $.session.set('toppings', "");
        $.session.set('sauceId', "");
        $.session.set('sauceModifierId', "");
        $.session.set('sizeId', "");
        $.session.set('styleId', "");
        $.session.set('topperId', "");
        $.session.set('quantity', "");
        $.session.set('selectedOrderLineId',"");
    }

    this.getSpecialtyItems = function(specialtyId, styleId, sauceId) {
        $.session.set('specialtyId', specialtyId);

        var json = {
            "storeId":$.session.get("storeId"),
            "specialtyId":specialtyId,
            "unitId":UNIT_ID
        }
        $.ajax({
            url:  this.getURL("get-specialty-items"),
            type: "POST",
            data: JSON.stringify(json),
            success: function(data) {
                pageController.showModifyItemModal();
                if(styleId) {
                    $('#style-' + styleId).attr('checked', true).trigger('click');
                    $.session.set('styleId', styleId);
                }
                if(sauceId) {
                    $('#sauce-' + sauceId).attr('checked', true).trigger('click');
                    $.session.set('sauceId', sauceId);
                }

                $('#size-9').attr('checked', true).trigger('click');
                $('#style-7').attr('checked', true).trigger('click');

                // Uncheck everything
                var toppingItemsString  = $.session.get('toppingItems');
                var currentToppingItems = toppingItemsString.split(',');
                for(var i = 0; i < currentToppingItems.length; i++) {
                    var currentToppingItemId = currentToppingItems[i];
                    $("#topping-" + currentToppingItemId + "-whole").attr("src", "/img/checkbox_unchecked.jpg");
                    $("#topping-" + currentToppingItemId + "-left").attr("src", "/img/checkbox_unchecked.jpg");
                    $("#topping-" + currentToppingItemId + "-right").attr("src", "/img/checkbox_unchecked.jpg");
                    $("#topping-" + currentToppingItemId + "-2x").attr("src", "/img/checkbox_unchecked.jpg");
                }

                var toppings = new Array();

                $.each(data, function( index ) {
                    specialty = data[index];
                    itemId = specialty['ItemID'];
                    var item = itemId + "-" + "whole" + "+"+specialty['ItemDescription'];
                    toppings.push(item);
                    $("#topping-" + itemId + '-whole').attr('src', '/img/checkbox_checked.jpeg' );
                });

                $.session.set('toppings', toppings);
                
                $("#quantity").val(1);    
                
            }
        });
    }

    this.listOrder = function() {
        var deferred = $.Deferred();
        var json = {
            "orderId"       : $.session.get('orderId'),
        }
        $.ajax({
            url:  this.getURL("list-order"),
            type: "POST",
            data: JSON.stringify(json),
            success: function(data) {
                $.session.set('orderTax', data[0]['Tax']);
                $.session.set('orderTax2', data[0]['Tax2']);
                $.session.set('orderTip', data[0]['Tip']);
                $.session.set('orderDriverMoney', data[0]['DriverMoney']);
                $.session.set('orderDeliveryCharge', data[0]['DeliveryCharge']);

                $('#modal-please-wait').modal('hide');
                $("#modify-items-close-button").click();
                OrderItems.buildYourOrder();
            }
        });
        return deferred;
    }

    this.createOrder = function() {
        var json = {
            "pSessionId"       : "0",
            "pIpAddress"       : "0.0.0.0",
            "pRefId"           : "0",
            "pTransactionDate" : "2014-04-01 23:18:58.1030000",
            "pStoreId"         : $.session.get("storeId"),
            "pCustomerId"      : "6063",
            "pCustomerName"    : "Vito''s Fan",
            "pCustomerPhone"   : "1111111111",
            "pAddressId"       : "116423",
            "pOrderTypeId"     : "1",
            "pDeliveryCharge"  : "2.0",
            "pDriverMoney"     : "0.75",
            "pOrderNotes"      : ""
        }
        $.ajax({
            url:  this.getURL("create-order"),
            type: "POST",
            data: JSON.stringify(json),
            success: function(data) {
                console.log('Created Order Id: ' + data[0]['OrderID']);
                $.session.set('orderId', data[0]['OrderID']);
                pageController.createOrderItem();
            }
        });
    }

    this.updatePrice = function() {
        var userPromos = JSON.parse($.session.get('userPromoCodes'));
        var couponIds = ""
        for(var i = 0; i < userPromos.length; i++) {
            var userPromo = userPromos[i];
            var couponId = userPromo['code'];
            if(i == 0) {
                couponIds = couponId;
            }
            else {
                couponIds += "," + couponId;
            }
        }

        var json = {
            "pStoreId"       : $.session.get('storeId'),
            "pOrderId"       : $.session.get('orderId'),
            "pPromos"        : couponIds,
            "pPromoCodes"    : ""
        }
        $.ajax({
            url:  this.getURL("update-price"),
            type: "POST",
            data: JSON.stringify(json),
            success: function(data) {
                pageController.listOrderItems();
            }
        });
    }

    this.createOrderItem = function() {

        var orderItem = {};

        // Get specialty
        var specialtyId    = $.session.get('specialtyId');
        console.log("speciality id"+specialtyId);
        console.log(""+this.items);
        for(var i = 0; i < this.items.length; i++) {
            if(specialtyId == this.items[i]['id']) {
                orderItem['items'] = this.items[i];
                console.log("items--"+orderItem['Items']);
            }
        }

        // Get size
        var sizeId    = $.session.get('sizeId');
        for(var i = 0; i < this.sizes.length; i++) {
            if(sizeId == this.sizes[i]['id']) {
                orderItem['size'] = this.sizes[i];
            }
        }

        // Get style
        var styleId    = $.session.get('styleId');
        for(var i = 0; i < this.styles.length; i++) {
            if(styleId == this.styles[i]['id']) {
                orderItem['style'] = this.styles[i];
            }
        }

        // Get sauce
        var sauceId    = $.session.get('sauceId');
        for(var i = 0; i < this.sauces.length; i++) {
            if(sauceId == this.sauces[i]['id']) {
                orderItem['sauce'] = this.sauces[i];
            }
        }

        // Get sauce modifier
        var sauceModifierId    = $.session.get('sauceModifierId');
        if(sauceModifierId) {
            for(var i = 0; i < this.sauceModifiers.length; i++) {
                if(sauceModifierId == this.sauceModifiers[i]['id']) {
                    orderItem['sauceModifier'] = this.sauceModifiers[i];
                }
            }
        }
        else {
            orderItem['sauceModifier'] = {id: "NULL", description: ""};
        }

        orderItem['toppers'] = new Array();
        var selectedToppers  = JSON.parse($.session.get('selectedToppers'));

        for(var i = 0; i < selectedToppers.length; i++) {
            var topperId = selectedToppers[i];
            for(var j = 0; j < this.toppers.length; j++) {
                if(topperId == this.toppers[j]['id']) {
                    orderItem['toppers'].push(this.toppers[j]);
                }
            }
        }

     var toppingsString  = $.session.get('toppings');
        var toppings        = toppingsString.split(',');

        orderItem['toppings'] = new Array();

        for(var i = 0; i < toppings.length; i++) {
            var item     = toppings[i];
            var elements = item.split('-');
            var itemId   = elements[0];
            var portion  = elements[1].split('+')[0];
            var description = elements[1].split('+')[1];
            var topping={};
            topping['portion'] = portion;
            topping['id'] = itemId;
            topping['description'] = description;
            orderItem['toppings'].push(topping);
        }
        
        //added quantity in session
        orderItem['quantity']=$.session.get("quantity");
        
        orderItem['orderType'] =CURRENT_ORDER_LOC;

        //this.orderItems.push(orderItem);
        var orderId = $.session.get("orderId");
        
        var json = {
            "pOrderId"       : orderId,
            "pUnitId"          : UNIT_ID,
            "pSpecialtyId"     : orderItem['items']['id'],
            "pSizeId"          : (orderItem['size']!=undefined && orderItem['size']!=null)? orderItem['size']['id']:'NULL',
            "pStyleId"         : (orderItem['style']!=undefined && orderItem['style']!=null)? orderItem['style']['id']:'NULL',
            "pSauceId"         : (orderItem['sauce']!=undefined && orderItem['sauce']!=null)? orderItem['sauce']['id']:'NULL',
            "pSauceModifierId" : orderItem['sauceModifier']['id'],
            "pNotes"           : orderItem['items']['detail'],
            "pDescription"     : orderItem['items']['detail'],
            "pQuantity"        : orderItem['quantity']//passing quantity in json    
        }
        $.ajax({
            url:  this.getURL("create-order-item"),
            type: "POST",
            data: JSON.stringify(json),
            success: function(data) {
                var orderItemId = data[0]['OrderLineID'];
                orderItem['id'] = orderItemId;

                var orderItems       = JSON.parse($.session.get('orderItems'));

                orderItems.push(orderItem);

                $.session.set('orderItems', JSON.stringify(orderItems));

                pageController.updatePrice();
            }
        });
    }

    this.listOrderItems = function() {
        var orderId = $.session.get("orderId");
        var json = {
            "orderId"       : orderId,
        }
        $.ajax({
            url:  this.getURL("list-order-items"),
            type: "POST",
            data: JSON.stringify(json),
            success: function(data) {
                $.each(data, function( index ) {
                    var orderItem = data[index];
                    var updatedOrderItems = new Array();
                    var orderItems        = JSON.parse($.session.get('orderItems'));

                    // Loop through orderItems from the backend
                    for(var i = 0; i < orderItems.length; i++) {
                        var sessionOrderItem = orderItems[i];

                        // Match up backend orderItem to sessionOrderItem
                        if(sessionOrderItem['id'] == orderItem['OrderLineID']) {
                            // Update cost
                            sessionOrderItem['cost'] = orderItem['Cost'];
                        }
                        updatedOrderItems.push(sessionOrderItem);

                    }
                         $.session.set('orderItems', JSON.stringify(updatedOrderItems));
                });

                pageController.listOrder();
            }
        });
    }

    this.listSpecialties = function() {
        var json = {
            Specialty: {
                filters: [
                    {
                        name: "product_type_id",
                        value: "1"
                    }
                ],
                pagination: {
                    page: "1",
                    limit: "1000"
                }
            }
        }

        $.ajax({
            url:  "/rest/model/specialties/filter",
            type: "POST",
            data: JSON.stringify(json),
            success: function(data) {
                // Yay! It worked!
                j = 0;
                html = "";
                var specialties = data['specialties'];
              
                for(var i = 0; i < specialties.length; i++) {
                    if(j == 0) {
                        html += "<div class=\"row\">";
                    }
                    html += pageController.buildSpecialtyList(specialties[i]["name"], specialties[i]["description"], specialties[i]["id"]);
                    j++;
                    if(j == 2) {
                        html += "</div>";
                        j = 0;
                    }
                }
                $("#items-grid-panel").html(html);
                $('.btn-group').button();
            }
        });
    }
    
    this.buildSpecialtyList = function(name,detail,specialtyId) {
    
       var html="";
       var imgUrl="";
       var item={};
        item['id']     = specialtyId;
        item['name']   = name;
        item['detail'] = detail;
        pageController.items.push(item);
        
        imgUrl =  (CURRENT_ORDER_LOC=="PIZZA")?"pizza-background.jpg":((CURRENT_ORDER_LOC=="SUBS")?"subs-background.jpg":"salads-background.jpg");
      
      
        html  = "<div class=\"col-md-5\">";
        html += "    <table id=\"grid-table\">";
        html += "        <tr>";
        html += "            <td><img src=\"/img/"+imgUrl+"\" width=\"100\" height=\"100\"></td>";
        html += "            <td valign=\"top\">";
        html += "                <table>";
        html += "                    <tr>";
        html += "                        <td colspan=2>";
        html += "                            <p class=\"header\">" + name + "</p>";
        html += "                        </td>";
        html += "                    </tr>";
        html += "                    <tr>";
        html += "                        <td colspan=2>";
        html += "                            <p class=\"body\">" + detail + "</p>";
        html += "                        </td>";
        html += "                    <tr>";
        html += "                        <td>";
        html += '                            <button class="red-gradient-button" onClick="pageController.getSpecialtyItems(' + specialtyId + ')">ORDER NOW</button>';
        html += '                        </td>';
        html += '                        <td>';
        html += '                            <button class="red-gradient-button" onClick="pageController.getSpecialtyItems(' + specialtyId + ')">SEE DETAILS</button>';
        html += "                        </td>";
        html += "                    </tr>";
        html += "                </table>";
        html += "            </td>";
        html += "        </tr>";
        html += "    </table>";
        html += "</div>";
        return html;
      
    }

    this.getURL = function(pathname) { 
     var URL=$.session.get('baseurl');        
        if(CURRENT_ORDER_LOC=="PIZZA") {
           URL+="/rest/order-pizza/"+pathname;
        }else if(CURRENT_ORDER_LOC=="SUBS") {
           URL+="/rest/order-subs/"+pathname;
        }else if(CURRENT_ORDER_LOC=="SALADS") {
          URL+="/rest/order-salads/"+pathname;
        }      
      return URL;    
    }
    
    this.listToppings = function() {
        var json = {
            "storeId":$.session.get("storeId"),
            "unitId":UNIT_ID
        }
        
        
        $.ajax({
            url:  this.getURL("list-toppings"),
            type: "POST",
            data: JSON.stringify(json),
            success: function(data) {
                // Yay! It worked!
                html  = '<table class="table table-colored table-condensed">';
                html += '    <tbody>';
                html += '       <tr>'
                html += '           <td  class="tan-highlight">&nbsp;</td>'
                html += '           <td  class="tan-highlight" align="right">';
                html += '               <img src="/img/topping-whole.png">';
                html += '           </td>';
                html += '           <td  class="tan-highlight">';
                html += '               <img src="/img/topping-left.png">';
                html += '           </td>';
                html += '           <td  class="tan-highlight">';
                html += '               <img src="/img/topping-right.png">';
                html += '           </td>';
                html += '           <td  class="tan-highlight">';
                html += '               <img src="/img/topping-2x.png">';
                html += '           </td>';
                html += '       </tr>';
 
                
                var toppingItems = new Array();
                for(var i = 0; i < data.length; i++) {
                    var itemId      = data[i]['ItemID'];
                    var description = data[i]['ItemDescription'];
                    toppingItems.push(itemId);
                    html += pageController.buildToppingItem(itemId,description,data.length);
                }

                $.session.set('toppingItems', toppingItems);

                html += '       <tr>'
                html += '           <td  class="tan-highlight">&nbsp;</td>'
                html += '           <td  class="tan-highlight" align="right">';
                html += '               <img src="/img/topping-whole.png">';
                html += '           </td>';
                html += '           <td  class="tan-highlight">';
                html += '               <img src="/img/topping-left.png">';
                html += '           </td>';
                html += '           <td  class="tan-highlight">';
                html += '               <img src="/img/topping-right.png">';
                html += '           </td>';
                html += '           <td  class="tan-highlight">';
                html += '               <img src="/img/topping-2x.png">';
                html += '           </td>';
                html += '       </tr>';

    
                html += '</tbody>';
                html += "</table>";
                $("#toppings .left-column").append(html);
            }
        });
    }

    this.buildToppingItem = function(id,description,contentLength) {
        // Add topping to pageController for later retrieval
        var topping = {};
        topping['id']          = id;
        topping['description'] = description;
        pageController.toppings.push(topping);

        var toppingsArr = JSON.parse(Session.get(CURRENT_ORDER_LOC+'_TOPPINGS'));
        
        if(toppingsArr.length < contentLength) {
           toppingsArr.push(topping);
           Session.set(CURRENT_ORDER_LOC+'_TOPPINGS',JSON.stringify(toppingsArr));
        }
        
        var html;
        html  = '       <tr>'
        html += '           <td class="tan-highlight">' + description + '</td>'
        html += '           <td align="right">';
        html += '                                    <a href="#" onclick="pageController.selectTopping(\'' + id + '\', \'whole\',\'#topping-\',\''+description+'\')"><img id="topping-' + id + '-whole" src="/img/checkbox_unchecked.jpg"></a>';
        html += '           </td>';
        html += '           <td>';
        html += '                                    <a href="#" onclick="pageController.selectTopping(\'' + id + '\', \'left\',\'#topping-\',\''+description+'\')"><img  id="topping-' + id + '-left" src="/img/checkbox_unchecked.jpg"></a>';
        html += '           </td>';
        html += '           <td>';
        html += '                                    <a href="#" onclick="pageController.selectTopping(\'' + id + '\', \'right\',\'#topping-\',\''+description+'\')"><img id="topping-' + id + '-right" src="/img/checkbox_unchecked.jpg"></a>';
        html += '           </td>';
        html += '           <td>';
        html += '                                    <a href="#" onclick="pageController.selectTopping(\'' + id + '\', \'2x\',\'#topping-\',\''+description+'\')"><img id="topping-' + id + '-2x" src="/img/checkbox_unchecked.jpg"></a>';
        html += '           </td>';
        html += '       </tr>';
        return html;
    }

    this.selectTopping = function(itemId, portion,checkbxId,description) {
        var toppingsString  = $.session.get('toppings');
                    
        var currentToppings = toppingsString.split(',');
       // alert("chckbxid "+checkbxId + "itemId "+ itemId + "prtn "+portion);
        // Uncheck item's row
        $(checkbxId + itemId + "-whole").attr("src", "/img/checkbox_unchecked.jpg");
        $(checkbxId + itemId + "-left").attr("src", "/img/checkbox_unchecked.jpg");
        $(checkbxId + itemId + "-right").attr("src", "/img/checkbox_unchecked.jpg");
        $(checkbxId + itemId + "-2x").attr("src", "/img/checkbox_unchecked.jpg");

        var toppings = new Array();

        var select = true;
        for(var i = 0; i < currentToppings.length; i++) {
            var currentItem    = currentToppings[i];

            var elements       = currentItem.split('-');
            var currentItemId  = elements[0];

            var currentPortion = elements[1].split('+')[0];
            var currentDesc = elements[1].split('+')[1];
            
            if(currentItemId == itemId && currentPortion == portion) {
                select = false;
                // $(checkbxId + itemId + "-" + portion ).attr("src", "/img/checkbox_unchecked.jpg");
            }
            else {
                if(currentItemId != itemId) {
                    item = currentItemId + "-" + currentPortion + "+"+currentDesc;
                    toppings.push(item);
                    $(checkbxId + itemId + '-' + portion).attr('src', '/img/checkbox_checked.jpeg' );
                }
            }
        }

        if(select == true) {
            item = itemId + "-" + portion+"+"+description;
            toppings.push(item);
            $(checkbxId + itemId + '-' + portion).attr('src', '/img/checkbox_checked.jpeg' );
        }
        else {
            $(checkbxId + itemId + "-" + portion ).attr("src", "/img/checkbox_unchecked.jpg");
        }

        $.session.set('toppings', toppings);
        //alert($.session.get('toppings'));

    }

    this.listToppers = function() {
    
        var json = {
            "storeId":$.session.get("storeId"),
            "unitId":UNIT_ID
        }
          
        $.ajax({
            url:  this.getURL("list-toppers"),
            type: "POST",
            data: JSON.stringify(json),
            success: function(data) {
                // Yay! It worked!
                
                for(var i = 0; i < data.length; i++) {
                    html = "";
                    if(i == 0) {
                        html += "<li class=\"header\">Crust Flavors:</li>";
                    } 
                    html += pageController.buildTopperRadioItem(data[i]['TopperID'],data[i]['TopperDescription'],data.length);
                    $("#size-and-crust .right-column").append(html);
                    
                }
            }
        });
    }
    
    this.buildTopperRadioItem = function(id,description,contentLength) {
        // Add topper to pageController for later retrieval
        var topper = {};
        topper['id']          = id;
        topper['description'] = description;
        var topprs = JSON.parse(Session.get(CURRENT_ORDER_LOC+'_TOPPERS')); 
        if(topprs.length < contentLength) {
        topprs.push(topper);
        Session.set(CURRENT_ORDER_LOC+'_TOPPERS',JSON.stringify(topprs));
        }
        pageController.toppers.push(topper);
        
        html = '';
        html += '<li class="item">';
        html += '<input onclick="pageController.selectTopper(' + id+','+'\'selectedToppers\'' +')" type="checkbox" name="topper" value="topper-' + id + '" id="topper-' + id + '"/>';
        html += '<label for="topper-' + id + '">' + description + '</label>';
        html += '</li>';
        return html;
    }

    this.selectTopper = function(topperId, sessionKey) {
        var sessionToppers  = JSON.parse($.session.get(sessionKey));
        var selectedToppers = new Array();
        var topperDeleted = false;

        for(var i = 0; i < sessionToppers.length; i++) {
            var sessionTopperId = sessionToppers[i];
            if(sessionTopperId == topperId) {
                topperDeleted = true; 
            }
            else {
                selectedToppers.push(sessionTopperId);
            }
        }
        if(topperDeleted == false) {
            selectedToppers.push(topperId);
        }

        $.session.set(sessionKey, JSON.stringify(selectedToppers));
        
    }

    this.listSizes = function() {
        var json = {
            "storeId":$.session.get("storeId"),
            "unitId":UNIT_ID
        }

        $.ajax({
            url:  this.getURL("list-sizes"),
            type: "POST",
            data: JSON.stringify(json),
            success: function(data) {
                // Yay! It worked!
                
                for(var i = 0; i < data.length; i++) {
                    html = "";
                    if(i == 0) {
                        html += "<li class=\"header\">Sizes:</li>";
                    } 
                    html += pageController.buildSizeRadioItem(data[i]['SizeID'],data[i]['SizeDescription'],data.length);
                    $("#size-and-crust .left-column").append(html);
                }
            }
        });
    }

    this.buildSizeRadioItem = function(id, description,contentLength) {
        // Add size to pageController for later retrieval
        var size = {};
        size['id']          = id;
        size['description'] = description;
        pageController.sizes.push(size);
       
        var sizesArr = JSON.parse(Session.get(CURRENT_ORDER_LOC+'_SIZES'));
        if(sizesArr.length < contentLength) {
           sizesArr.push(size);
           Session.set(CURRENT_ORDER_LOC+'_SIZES',JSON.stringify(sizesArr));
        }

        html = "";
        html += '<li class="item">';
        html += '<input onclick="pageController.selectSize(' + id + ')" type="radio" name="size" value="size-' + id + '" id="size-' + id + '"/>';
        html += '<label for="size-' + id + '">' + description + '</label>';
        html += "</li>";
        return html;
    }

    this.selectSize = function(sizeId) {
        
        if(sizeId == 39 || sizeId == 40) {
            // Disable style
            $("#styles").hide("slow");
            $("#styles1").hide("slow");
        }
        else {
            $("#styles").show("slow");
            $("#styles1").show("slow");
        }

        $.session.set('sizeId', sizeId);
    }

    this.listStyles = function() {
        var json = {
            "storeId":$.session.get("storeId"),
            "unitId":UNIT_ID,
            "sizeId":"9"
        }
        
        $.ajax({
            url:  this.getURL("list-styles"),
            type: "POST",
            data: JSON.stringify(json),
            success: function(data) {
                // Yay! It worked!
                 
                html  = "<div id='styles'>";
                html += "<li class=\"header\">Crust Options:</li>";
                for(var i = 0; i < data.length; i++) {
                    html += pageController.buildStyleRadioItem(data[i]['StyleID'],data[i]['StyleDescription'],data.length);
                }
                html += "</div>";
                $("#size-and-crust .left-column").append(html);
            }
        });
    }

    this.buildStyleRadioItem = function(id, description,contentLength) {
        // Add style to pageController for later retrieval
        var style = {};
        style['id']          = id;
        style['description'] = description;
        pageController.styles.push(style);
        
        var styleArr = JSON.parse(Session.get(CURRENT_ORDER_LOC+'_STYLES'));
        if(styleArr.length < contentLength) {
           styleArr.push(style);
           Session.set(CURRENT_ORDER_LOC+'_STYLES',JSON.stringify(styleArr));
        }
        html = "";
        html += '<li class="item">';
        html += '<input onclick="pageController.selectStyle(' + id + ')" type="radio" name="crust" value="style-' + id + '" id="style-' + id + '"/>';
        html += '<label for="style-' + id + '">' + description + '</label>';
        html += "</li>";
        return html;
    }

    this.selectStyle = function(styleId) {
        $.session.set('styleId', styleId);
    }

    // This method updates the quantity in session
    this.updateQuantity = function(qntyId) {
        $.session.set('quantity', $(qntyId).val());
    }
    

    this.updatePromo = function() {
        var promoCode = ""
        var promoCode_sm = $("#promoCode-sm").val();
        var promoCode_lg = $("#promoCode-lg").val();

        if(promoCode_sm.length > 0) {
            promoCode = promoCode_sm; 
        }
        else if(promoCode_lg.length > 0) {
            promoCode = promoCode_lg; 
        }

        console.log("promoCode_sm: " + promoCode_sm);
        console.log("promoCode_lg: " + promoCode_lg);
        console.log("promoCode: " + promoCode);

        var json = {
            "storeId": $.session.get("storeId"),
            "promoCode": promoCode
        }

        $.ajax({
            url:  this.getURL("validate-promo"),
            type: "POST",
            data: JSON.stringify(json),
            success: function(data) {
                // Yay! It worked!
                console.log(data);
                if(data.length > 0) {
                    var description = data[0]['Description'];
                    var couponId = data[0]['CouponID'];
                    console.log(description);

                    var checkPoint = 0;

                    var userPromos = JSON.parse($.session.get('userPromoCodes'));
                    for(var i = 0; i < userPromos.length; i++) {
                        var userPromo = userPromos[i];
                        if(userPromo['code'] == couponId) {
                            checkPoint++;
                        }
                    }
                    
                    if(checkPoint>0 && userPromos.length>0) {
                        $('#modal-invalid-promo').modal('show');
                    }
                    else {
                        userPromos.push({code:couponId, description:description, cost:0});
                        $.session.set('userPromoCodes', JSON.stringify(userPromos));
    
                        OrderItems.buildYourOrder();
                    }
                }
                else {
                    $('#modal-invalid-promo').modal('show');
                }

                $('#promoCode-sm').val("");
                $('#promoCode-lg').val("");
            }
        });

    }

    this.listSauces = function() {
        var json = {
            "storeId":$.session.get("storeId"),
            "unitId":UNIT_ID
        }
        
        $.ajax({
            url:  this.getURL("list-sauces"),
            type: "POST",
            data: JSON.stringify(json),
            success: function(data) {
                // Yay! It worked!
                
                var html = "<li class=\"header\">Sauces:</li>";
                var noSauceHtml = "";
                for(var i = 0; i < data.length; i++) {
                   
                    var sauceId = data[i]['SauceID'];
                    var sauceDescription = data[i]['SauceDescription'];
                    if(sauceDescription == 'No Sauce') {
                        noSauceHtml = pageController.buildSauceRadioItem(sauceId,sauceDescription,data.length);
                    }
                    else {
                        html += pageController.buildSauceRadioItem(sauceId,sauceDescription,data.length);
                    }

                }

                $("#cheese-and-sauce .left-column").append(html);
                $("#cheese-and-sauce .left-column").append(noSauceHtml);
            }
        });
    }

    this.buildSauceRadioItem = function(id,description,contentLength) {
        // Add suace to pageController for later retrieval
        var sauce = {};
        sauce['id']          = id;
        sauce['description'] = description;
        pageController.sauces.push(sauce);
        
        var saucesArr = JSON.parse(Session.get(CURRENT_ORDER_LOC+'_SAUCES'));
        if(saucesArr.length < contentLength) {
           saucesArr.push(sauce);
           Session.set(CURRENT_ORDER_LOC+'_SAUCES', JSON.stringify(saucesArr));
        }

        html = "";
        html += '<li class="item">';
        html += '<input onclick="pageController.selectSauce(' + id + ')" type="radio" name="sauce" value="sauce-' + id + '" id="sauce-' + id + '"/>';
        html += '<label for="sauce-' + id + '">' + description + '</label>';
        html += "</li>";
        return html;
    }

    this.selectSauce = function(sauceId) {
        $.session.set('sauceId', sauceId);
    }

    this.listSauceModifiers = function() {
        var json = {
            "storeId":$.session.get("storeId")
        }
        
        $.ajax({
            url:  this.getURL("list-sauce-modifiers"),
            type: "POST",
            data: JSON.stringify(json),
            success: function(data) {
                // Yay! It worked!
                
                for(var i = 0; i < data.length; i++) {
                    html = "";
                    if(i == 0) {
                        html += "<li class=\"header\">Sauce Options:</li>";
                    } 
                    html += pageController.buildSauceModifierRadioItem(data[i]['SauceModifierID'],data[i]['SauceModifierDescription'],data.length);
                    $("#cheese-and-sauce .right-column").append(html);
                }
            }
        });
    }
    
   // this method helps to update the order. It updates one order at a time.
    this.updateOrder = function(id) {
       
        var orderItems        = JSON.parse($.session.get('orderItems'));
        var selectedOrderItem;
        var orderType ='';
               
        for(var i = 0; i < orderItems.length; i++) {
            var orderItem = orderItems[i];
            if(orderItem['id'] == id) {
                selectedOrderItem = orderItem;
            }
        }  
        $.session.set('selectedOrderLineId',id);
        pageController.buildModifyModalItem(selectedOrderItem['orderType']);
        pageController.prePopulateSelectedValues(selectedOrderItem);
        $('#modal-modify-item1').modal();
   }

  this.prePopulateSelectedValues = function(orderItemToUpdate) {
   console.log("orderItemToUpdate  ",orderItemToUpdate);
   
   var size = orderItemToUpdate['size'];
   if(size) {
      $('#size--'+size['id']).attr('checked', true).trigger('click');
   }
   
   var style = orderItemToUpdate['style'];
   if(style) {
      $('#style--'+style['id']).attr('checked', true).trigger('click');
   }
   
   var sauce = orderItemToUpdate['sauce'];
   if(sauce) {
      $('#sauce--'+sauce['id']).attr('checked', true).trigger('click');
   }
   
   var sauceModifier = orderItemToUpdate['sauceModifier'];
   if(sauceModifier && sauceModifier['id']!="NULL") {
      $('#sauce-modifier--'+sauceModifier['id']).attr('checked', true).trigger('click');
   } 

   var toppers = orderItemToUpdate['toppers'];
   if(toppers) {
     for(var i=0; i<toppers.length;i++) {
        $('#topper--'+toppers[i]['id']).trigger('click');
        $('#topper--'+toppers[i]['id']).attr('checked', true);
     }
   }
   
   
        var toppingsSession = new Array();
        var data = orderItemToUpdate['toppings'];
        $.each(data, function( index ) {
            specialty = data[index];
            itemId = specialty['id'];
            var item = itemId + "-" + specialty['portion'] + "+"+specialty['description'];
            toppingsSession.push(item);
            $("#topping--" + specialty['id'] +'-'+ specialty['portion']).attr("src", "/img/checkbox_checked.jpeg");
        });
        $.session.set('toppings', toppingsSession);   
   
   $("#quantity1").val(Number(orderItemToUpdate['quantity']));
   
  }  
this.buildModifyModalItem = function(orderType) {

  var data = JSON.parse(Session.get(orderType+'_TOPPERS'));

  var html = "";
 
  if(data.length >0) {  
    html += "<li class=\"header\">Crust Flavors:</li>";
  }    
   for(var i = 0; i < data.length; i++) {
    
      var id = data[i]['id'];
      var description = data[i]['description'];          
      html += '<li class="item">';
      html += '<input onclick="pageController.selectTopper(' + id +','+'\'ToppersInEdit\'' +')" type="checkbox" name="topper" value="topper--' + id + '" id="topper--' + id + '"/>';
      html += '<label for="topper--' + id + '">' + description + '</label>';
      html += '</li>';
        
     }
  
     $("#size-and-crust1 .right-column").html(html);
   
   var data = JSON.parse(Session.get(orderType+'_SIZES'));
   
   html = "";
   if(data.length >0) { 
     html += "<li class=\"header\">Sizes:</li>";
   }                  
   for(var i = 0; i < data.length; i++) {
     
      html += '<li class="item">';
      html += '<input onclick="pageController.selectSize(' + data[i]['id'] + ')" type="radio" name="size" value="size--' + data[i]['id'] + '" id="size--' + data[i]['id'] + '"/>';
      html += '<label for="size--' + data[i]['id'] + '">' + data[i]['description'] + '</label>';
      html += "</li>";
    
   } 
   
   $("#size-and-crust1 .left-column").html(html);
   
   var data = JSON.parse(Session.get(orderType+'_SAUCES'));
   html ="";
   html = "<li class=\"header\">Sauces:</li>";
   var noSauceHtml = "";
   for(var i = 0; i < data.length; i++) {
       var id = data[i]['id'];
       var description = data[i]['description'];
       if(description == 'No Sauce') { 
          noSauceHtml += '<li class="item">';
          noSauceHtml += '<input onclick="pageController.selectSauce(' + id + ')" type="radio" name="sauce" value="sauce--' + id + '" id="sauce--' + id + '"/>';
          noSauceHtml += '<label for="sauce--' + id + '">' + description + '</label>';
          noSauceHtml += "</li>";
       }
       else {
          html += '<li class="item">';
          html += '<input onclick="pageController.selectSauce(' + id + ')" type="radio" name="sauce" value="sauce--' + id + '" id="sauce--' + id + '"/>';
          html += '<label for="sauce--' + id + '">' + description + '</label>';
          html += "</li>";   
       }
   }
   $("#cheese-and-sauce1 .left-column").html(html);
   $("#cheese-and-sauce1 .left-column").append(noSauceHtml);
            
   
   var data = JSON.parse(Session.get(orderType+'_STYLES'));
   html  = "<div id='styles1'>";
   html += "<li class=\"header\">Crust Options:</li>";
   for(var i = 0; i < data.length; i++) {
        var id = data[i]['id'];
        var description = data[i]['description'];
        html += '<li class="item">';
        html += '<input onclick="pageController.selectStyle(' + id + ')" type="radio" name="crust" value="style--' + id + '" id="style--' + id + '"/>';
        html += '<label for="style--' + id + '">' + description + '</label>';
        html += "</li>";
        
   }
   html += "</div>";
   $("#size-and-crust1 .left-column").append(html);
   
   var data = JSON.parse(Session.get(orderType+'_SAUCEMODIFIERS'));
    html = "<li class=\"header\">Sauce Options:</li>";
                   
   for(var i = 0; i < data.length; i++) {
        html += '<li class="item">';
        html += '<input onclick="pageController.selectSauceModifier(' + data[i]['id'] + ','+'\'#sauce-modifier--\''+')" type="radio" name="sauce-modifier" value="sauce-modifier--' + data[i]['id'] + '" id="sauce-modifier--' + data[i]['id'] + '"/>';
        html += '<label for="sauce-modifier--' + data[i]['id'] + '">' + data[i]['description'] + '</label>';
        html += '</li>';
   }
   
   $("#cheese-and-sauce1 .right-column").html(html);
   
   var data = JSON.parse(Session.get(orderType+'_TOPPINGS'));
   html  = '<table class="table table-colored table-condensed">';
   html += '    <tbody>';
   html += '       <tr>'
   html += '           <td  class="tan-highlight">&nbsp;</td>'
   html += '           <td  class="tan-highlight" align="right">';
   html += '               <img src="/img/topping-whole.png">';
   html += '           </td>';
   html += '           <td  class="tan-highlight">';
   html += '               <img src="/img/topping-left.png">';
   html += '           </td>';
   html += '           <td  class="tan-highlight">';
   html += '               <img src="/img/topping-right.png">';
   html += '           </td>';
   html += '           <td  class="tan-highlight">';
   html += '               <img src="/img/topping-2x.png">';
   html += '           </td>';
   html += '       </tr>';
 
   for(var i = 0; i < data.length; i++) {
        var id = data[i]['id'];
        var description = data[i]['description'];
       
        html += '       <tr>';
        html += '           <td class="tan-highlight">' + description + '</td>';
        html += '           <td align="right">';
        html += '                                    <a href="#" onclick="pageController.selectTopping(\'' + id + '\', \'whole\',\'#topping--\''+',\''+description+'\')"><img id="topping--' + id + '-whole" src="/img/checkbox_unchecked.jpg"></a>';
        html += '           </td>';
        html += '           <td>';
        html += '                                    <a href="#" onclick="pageController.selectTopping(\'' + id + '\', \'left\',\'#topping--\''+',\''+description+'\')"><img  id="topping--' + id + '-left" src="/img/checkbox_unchecked.jpg"></a>';
        html += '           </td>';
        html += '           <td>';
        html += '                                    <a href="#" onclick="pageController.selectTopping(\'' + id + '\', \'right\',\'#topping--\''+',\''+description+'\')"><img id="topping--' + id + '-right" src="/img/checkbox_unchecked.jpg"></a>';
        html += '           </td>';
        html += '           <td>';
        html += '                                    <a href="#" onclick="pageController.selectTopping(\'' + id + '\', \'2x\',\'#topping--\''+',\''+description+'\')"><img id="topping--' + id + '-2x" src="/img/checkbox_unchecked.jpg"></a>';
        html += '           </td>';
        html += '       </tr>';
            
   }
   html += '       <tr>'
   html += '           <td  class="tan-highlight">&nbsp;</td>'
   html += '           <td  class="tan-highlight" align="right">';
   html += '               <img src="/img/topping-whole.png">';
   html += '           </td>';
   html += '           <td  class="tan-highlight">';
   html += '               <img src="/img/topping-left.png">';
   html += '           </td>';
   html += '           <td  class="tan-highlight">';
   html += '               <img src="/img/topping-right.png">';
   html += '           </td>';
   html += '           <td  class="tan-highlight">';
   html += '               <img src="/img/topping-2x.png">';
   html += '           </td>';
   html += '       </tr>';
   html += '</tbody>';
   html += "</table>";
   
   $("#toppings1 .left-column").html(html);
                                                          
}

    this.buildSauceModifierRadioItem = function(id,description,contentLength) {
        // Add suace modifiers to pageController for later retrieval
        var sauceModifier = {};
        sauceModifier['id']          = id;
        sauceModifier['description'] = description;
        pageController.sauceModifiers.push(sauceModifier);
        var sauceModfrArr =  JSON.parse(Session.get(CURRENT_ORDER_LOC+'_SAUCEMODIFIERS'));
        if(sauceModfrArr.length < contentLength) {
         sauceModfrArr.push(sauceModifier);
         Session.set(CURRENT_ORDER_LOC+'_SAUCEMODIFIERS',JSON.stringify(sauceModfrArr));
        }
        html = '';
        html += '<li class="item">';
        html += '<input onclick="pageController.selectSauceModifier(' + id + ','+'\'#sauce-modifier-\''+')" type="radio" name="sauce-modifier" value="sauce-modifier-' + id + '" id="sauce-modifier-' + id + '"/>';
        html += '<label for="sauce-modifier-' + id + '">' + description + '</label>';
        html += '</li>';
        return html;
    }

    this.selectSauceModifier = function(sauceModifierId,chckboxId) {
        var currentSauceModifierId = $.session.get('sauceModifierId');
        if(currentSauceModifierId == sauceModifierId) {
            $(chckboxId + sauceModifierId).attr("checked", false);
            $.session.set('sauceModifierId', "");
        }
        else {
            $.session.set('sauceModifierId', sauceModifierId);
        }
    }

    this.showModifyItemModal = function() {
        $('#modal-modify-item').modal();
    }

    this.showItemDetailModal = function() {
        $('#modal-modify-item').modal();
    }

    this.modifyItemModal = function() {
        $("#modal-modify-item").modal();
    }
    
    buildItemForModifyItemModal = function(id,description) {
        html = "";
        html += "<li class=\"item\">";
        html += "<input type=\"checkbox\" id=\"" + id + description + "\"/>";
        html += "<label for=\"" + id + description + "\">" + description + "</label>";
        html += "</li>";
        return html;
    }
    buildItemForGridPanel = function(name,detail) {
        html = "<div id=\"grid-block\" class=\"col-md-5\">";
        html += "<table id=\"grid-table\"><tr><td><img src=\"/img/pizza-background.jpg\" width=\"100\" height=\"100\"></td>";
        html += "<td><table><tr><td colspan=2>";
        html += "<p class=\"header\">" + name + "</p>";
        html += "</td></tr><tr><td colspan=2>";
        html += "<p class=\"body\">" + detail + "</p>";
        html += "</td><tr><td><button class=\"red-gradient-button\" onClick=\"$('#modal-modify-item').modal()\">ORDER NOW</button></td><td><button class=\"red-gradient-button\">SEE DETAILS</button></td></tr></table></td></tr></table></div>";
        return html;
    }
}
function OrderItems () {}
OrderItems.buildYourOrder = function() {
    var orderDivArray = new Array();
    orderDivArray.push('right', 'sm');

    // Process all divs that need order data
    for(var orderDivIndex = 0; orderDivIndex < orderDivArray.length; orderDivIndex++) {

        var divName = orderDivArray[orderDivIndex];

        // Totals
        var orderSubTotal = Number(0.00);

        var html  = "";
        html  = "<tr>";
        html += '    <td>' + $.session.get('email') + ' (<a id="delivery-mode" style="font-size:80%;cursor: pointer; cursor: hand;color:#000;text-decoration:underline" onClick="+$(\'#modal-delivery\').modal()">'+ $.session.get('mode') +"</a>)</td>";
        html += "</tr>";

        // Process all order items
        var orderItems       = JSON.parse($.session.get('orderItems'));
        var curr_loc= window.location.pathname;
        var userPromos = JSON.parse($.session.get('userPromoCodes'));
        var promoCost = 0.0;
    
        for(var j = 0; j < userPromos.length; j++) {
            promoCost+=Number(userPromos[j]['cost']);
        }
        
        for(var i = 0; i < orderItems.length; i++) {
            var orderItem = orderItems[i];
              
            var cost =  Number(orderItem['cost']);
            orderSubTotal += (cost*Number(orderItem['quantity']));
            var orderCost = (cost*Number(orderItem['quantity']));

            html += '<tr>';
            html += '    <td>';
            html += '        <div class="panel-group" id="accordion-' + divName + '-' + orderItem['id'] + '">'
            html += '            <div class="panel panel-default">'
            html += '                <div style="height: 38px; background-color:#A49685;">'
            html += '                    <h3 class="panel-title">'
            html += '                       <div class="col-xs-9"> '
            html += '                         <a class="accordion-toggle" data-toggle="collapse" style="color:#fff;font-size:14px" data-parent="#accordion-' + divName + '-' + orderItem['id'] + '" href="#order-item-detail-' + divName + '-' + orderItem['id'] + '">'
            if(orderItem['orderType']=="PIZZA") {
                html += '       <span class="itemSize">' + orderItem['size']['description'] + '</span> '
            }   
            html +=                           '<span class="itemDescription">' + orderItem['items']['name'] +'('+orderItem['quantity'] +')';
            if(curr_loc.indexOf("confirmation")==-1) {
                html +=                           '<br> <span class="badge"><a style="font-size:80%;cursor: pointer; cursor: hand;text-decoration:underline;color:#000" onClick="pageController.updateOrder('+orderItem['id']+');">Edit</a></span>&nbsp;&nbsp;'; 
                html +=                           '<a style="font-size:80%;cursor: pointer; cursor: hand;text-decoration:underline;color:#000" onClick="OrderItems.cancelOrder('+orderItem['id']+');">Remove</a>';
            }
            html +=                           '</div></span><div style="height:38px;font-size:15px;float:right;" class="col-sm-2"> <div class="row" style="float:right"><br>$ ' + orderCost.toFixed(2) +'</div></div>'
            html += '                         </a>'
            html += '                    </div></h3>'
            html += '                </div>'
            html += '                <div id="order-item-detail-' + divName + '-' + orderItem['id'] + '" class="panel-collapse collapse">'
            html += '                    <div class="panel-body">'
            if(orderItem['orderType']=="PIZZA") {
                html += '                        <p>Sauce: ' + orderItem['sauce']['description'] + '</p>'
            }
            html += '                        <p>Sauce Options: ' + orderItem['sauceModifier']['description'] + '</p>'
            html += '                        <p>Toppings: <br>'
            // Toppings
            var toppings = orderItem['toppings']
            for(var toppingIndex = 0; toppingIndex < toppings.length; toppingIndex++) {
                var topping = toppings[toppingIndex];
                html += topping['description'] + ' - ' + topping['portion'] + "<br>";
            }
            html += '                        </p>'
            html += '                    </div>'
            html += '                </div>'
            html += '            </div>'
            html += '        </div>'
            html += '    </td>';
            html += "</tr>";
        }

        html += OrderItems.buildPromoAccordion(promoCost,userPromos,divName);
        $('#order-table-' + divName + ' > tbody').html(html);

        // Order Totals
        var orderTaxes          = 0;
        var orderTip            = 0;
        var orderDeliveryCharge = 0;
        var orderDriverMoney    = 0;
        var orderTotal          = 0;
       
        
        if($.session.get('orderTax')) {
            orderTaxes          = Number($.session.get('orderTax') + $.session.get('orderTax2'));
            orderTip            = Number($.session.get('orderTip'));
            orderDeliveryCharge = Number($.session.get('orderDeliveryCharge'));
            orderDriverMoney    = Number($.session.get('orderDriverMoney'));
            orderTotal          = orderSubTotal + orderTaxes + orderTip - promoCost; //Subtracting promocode price    
        }

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
        if(curr_loc.indexOf("confirmation")!=-1) {
            html +=  orderTip.toFixed(2) ;
        }
        else{
            html += '<input type="text" class="ordrTip" value="'+orderTip + '" maxlength="4" size="4" style="text-align:right" onchange="OrderItems.clearField(this.value)"/>';
        }
        html += '</td>';
        html += '</tr>';
        if(curr_loc.indexOf("confirmation")==-1) {
            html +=' <tr><td align="right" colspan="2"> <a style="font-size:80%;cursor: pointer; cursor: hand;text-decoration:underline;color:#000" onclick="OrderItems.UpdateTip()">Apply</a></td>'; 
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
        if(curr_loc.indexOf("information")==-1 && curr_loc.indexOf("confirmation")==-1) {
            if(orderItems.length>0)
                html += '    <th colspan="2"><hr> <button onclick="window.location.href=\'/order-information\'" type="button" class="red-gradient-button">SUBMIT ORDER</button></td>';
            }
            html += '</tr>';

            $('#order-totals-table-' + divName + ' > tbody').html(html);
        }
    
    
        // this method helps to cancel the order. It cancels one order at a time.
        OrderItems.cancelOrder = function(id) {
            var json = {
                "pOrderItemId"       : id //Inputs an id as json
            }
     
            //An ajax call to cancel the order in the back end
            $.ajax({
                url:  $.session.get('baseurl')+"/rest/order-pizza/delete-order-item",
                type: "POST",
                data: JSON.stringify(json),
                success: function(data) {

                    //It updates the orderItems resides in session after deletion
                    var orderItems        = JSON.parse($.session.get('orderItems'));
                    var updatedOrderItems = new Array();
               
                    for(var i = 0; i < orderItems.length; i++) {
                        var orderItem = orderItems[i];
                        if(orderItem['id'] != id) {
                            updatedOrderItems.push(orderItem);
                        }
                    }
                  
                    $.session.set('orderItems', JSON.stringify(updatedOrderItems));
          
                    //It rebuilds the accordion after deletion
                    OrderItems.buildYourOrder();
                }
            });
        }
    
        OrderItems.clearField = function(val) {
            $.session.set('currentTip',val);
        }
    
        OrderItems.UpdateTip = function() {
            var tip =  $.session.get('currentTip');
                  
            if(tip==null || tip==undefined || isNaN(parseFloat(tip)))
                tip = 0;
            $.session.set('orderTip',tip);
      
            OrderItems.buildYourOrder();
        }
        OrderItems.UpdateOrderItem = function() {
        $('#modal-modify-item1').modal('hide');
        $('#modal-please-wait').modal('show');
        var orderLineId = $.session.get('selectedOrderLineId');
        if(orderLineId) {
            var orderItems        = JSON.parse($.session.get('orderItems'));
            var selectedOrderItem;
         
            for(var i = 0; i < orderItems.length; i++) {
                var orderItem = orderItems[i];
                if(orderItem['id'] == orderLineId) {
                    selectedOrderItem = orderItem;
                }
            }  

            if(selectedOrderItem) {
                selectedOrderItem['quantity'] = $.session.get('quantity');
                //size
          
                var sizeId    = $.session.get('sizeId');
                var sizeInSsn = JSON.parse($.session.get(selectedOrderItem['orderType']+'_SIZES'));
                for(var i = 0; i < sizeInSsn.length; i++) {
                    if(sizeId == sizeInSsn[i]['id']) {
                        selectedOrderItem['size'] = sizeInSsn[i];
                    }
                }
           
                //style
          
                var styleId    = $.session.get('styleId');
                var styleInSsn = JSON.parse($.session.get(selectedOrderItem['orderType']+'_STYLES'));
                for(var i = 0; i < styleInSsn.length; i++) {
                    if(styleId == styleInSsn[i]['id']) {
                        selectedOrderItem['style'] = styleInSsn[i];
                    }
                }
         
                // Get sauce
                var sauceId    = $.session.get('sauceId');
                var sauceInSsn = JSON.parse($.session.get(selectedOrderItem['orderType']+'_SAUCES'));
                for(var i = 0; i < sauceInSsn.length; i++) {
                    if(sauceId == sauceInSsn[i]['id']) {
                        selectedOrderItem['sauce'] = sauceInSsn[i];
                    }
                }

                // Get sauce modifier
                var sauceModifierId    = $.session.get('sauceModifierId');
                if(sauceModifierId) {
                    var sauceModInSsn = JSON.parse($.session.get(selectedOrderItem['orderType']+'_SAUCEMODIFIERS'));
                    for(var i = 0; i < sauceModInSsn.length; i++) {
                        if(sauceModifierId == sauceModInSsn[i]['id']) {
                            selectedOrderItem['sauceModifier'] = sauceModInSsn[i];
                        }
                    }
                }
                else {
                    selectedOrderItem['sauceModifier'] = {id: "NULL", description: ""};
                }
                //topper
          
                selectedOrderItem['toppers'] = new Array();
                var selectedToppers  = JSON.parse($.session.get('ToppersInEdit'));
                var topperInSsn = JSON.parse($.session.get(selectedOrderItem['orderType']+'_TOPPERS'));
        
                for(var i = 0; i < selectedToppers.length; i++) {
                    var topperId = selectedToppers[i];
                    for(var j = 0; j < topperInSsn.length; j++) {
                        if(topperId == topperInSsn[j]['id']) {
                            selectedOrderItem['toppers'].push(topperInSsn[j]);
                        }
                    }
                }
                //topping

                var toppingsString  =  $.session.get('toppings');
                var toppings        = toppingsString.split(',');

                selectedOrderItem['toppings'] = new Array();

                for(var i = 0; i < toppings.length; i++) {
                    var item     = toppings[i];
                    var elements = item.split('-');
                    var itemId   = elements[0];
                    var portion  = elements[1].split('+')[0];
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

OrderItems.buildPromoAccordion = function(promoCost,userPromos,divName) {
    var html='';        
  
    if(userPromos.length>0) {
        html += '<tr>';
        html += '    <td>';
        html += '        <div class="panel-group" id="accordion-promo-'+divName+'">'
        html += '            <div class="panel panel-default">'
        html += '                <div style="background-color:#A49685;height:38px">'
        html += '                    <h3 class="panel-title">'
        html += '                         <div class="col-xs-9"> <a data-toggle="collapse" style="color:#fff;font-size:14px" data-parent="#accordion-promo-'+divName+'" href="#promo-detail-'+divName+'">'  
        html +=                           '<span style="font-size:14px;">Promo</span></a></div>';
        html +=                           '<div class="col-sm-2" style="height:38px;font-size:15px;float:right;"><div style="float:right" class="row">$ -' + promoCost.toFixed(2);
        html += '                         </div></div>'
        html += '                    </h3>'
        html += '                </div>'
        html += '                <div id="promo-detail-'+divName+'" class="panel-collapse collapse ">'
        html += '                    <div class="panel-body" style="font-size:12px;background-color:#BDAFA0">'//A49670">'
        html += ' <div style="height:76px;width:25%;margin-top:-27px;margin-left:-25px" class="row titleimage"></div> ';
        for(var i = 0; i < userPromos.length; i++) {
            var userPromo = userPromos[i];
            html += '                        <p>Code : '+userPromo['code']+'</p>'
            html += '                        <p>Description : ' + userPromo['description'] + '</p>'
            html += '                        <p>Cost : $'+ Number(userPromo['cost']).toFixed(2)+'</p>'
            if(i<userPromos.length-1)
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


function OrderItemsController () {
    this.items           = new Array();
    this.toppers         = new Array();
    this.sizes           = new Array();
    this.sauces          = new Array();
    this.styles          = new Array();
    this.sauceModifiers  = new Array();
    this.toppings        = new Array();
    
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
        $('#modal-modify-item1').append(ModalModifyOrderItem.createMarkup());
        
        $('#order-items-panel-sm').append(PanelOrderItemsSmall.createMarkup());
        $('#order-items-panel').append(PanelOrderItems.createMarkup());
        
        $.when(
            OrderItems.buildYourOrder(),
            this.listSpecialties(),
            this.listToppers(),
            this.listSizes(),
            this.listSauces(),
            this.listStyles(),
            this.listSauceModifiers(),
            this.listToppings()
            
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
            "StoreID":$.session.get("storeId"),
            "SpecialtyID":specialtyId,
            "UnitID":UNIT_ID,
            "SPECIALTY_ITEMS":"TRUE",
        }

        var URL = "/rest/view/tblitems/get-tblitems";

        $.ajax({
            url: URL,
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
                
                if(pageController.toppers!=undefined && pageController.toppers){
                  
                for(var i = 0; i < pageController.toppers.length; i++) {
                    var currentTopperItemId = pageController.toppers[i]['id'];
                    $("#topper-" + currentTopperItemId).attr('checked', false);
     
                }
                }
                $.session.set('toppings', toppings);
                
                $("#quantity").val(1);    
                
            }
        });
    }

    this.listOrder = function() {
        var deferred = $.Deferred();
        var json = {
            "Tblorders": {
                "filters": [
                    {
                        "name": "OrderID",
                        "value": $.session.get('orderId')
                    }
                ],
                "pagination": {
                    "page": "1",
                    "limit": "1"
                }
            }
        }

        var URL = "/rest/model/tblorders/filter";

        $.ajax({
            url: URL,
            type: "POST",
            data: JSON.stringify(json),
            success: function(data) {
                var order = data['tblorders'][0]
                $.session.set('orderTax', order['Tax']);
                $.session.set('orderTax2', order['Tax2']);
                $.session.set('orderTip', order['Tip']);
                $.session.set('orderDriverMoney', order['DriverMoney']);
                $.session.set('orderDeliveryCharge', order['DeliveryCharge']);

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

        var URL = "/rest/view/tblorders/create-tblorders";

        $.ajax({
            url: URL,
            type: "POST",
            data: JSON.stringify(json),
            success: function(data) {
                console.log('Created Order Id: ' + data[0]['newid']);
                $.session.set('orderId', data[0]['newid']);
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

        var URL = "/rest/view/tblorders/update-price-tblorders";

        $.ajax({
            url:  URL,
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
            "pOrderID"         : orderId,
            "pUnitID"          : UNIT_ID,
            "pSpecialtyID"     : orderItem['items']['id'],
            "pSizeID"          : (orderItem['size']!=undefined && orderItem['size']!=null)? orderItem['size']['id']:'NULL',
            "pStyleID"         : (orderItem['style']!=undefined && orderItem['style']!=null)? orderItem['style']['id']:'NULL',
            "pHalf1SauceID"         : (orderItem['sauce']!=undefined && orderItem['sauce']!=null)? orderItem['sauce']['id']:'NULL',
            "pHalf2SauceID"         : (orderItem['sauce']!=undefined && orderItem['sauce']!=null)? orderItem['sauce']['id']:'NULL',
            "pHalf1SauceModifierID" : orderItem['sauceModifier']['id'],
            "pHalf2SauceModifierID" : orderItem['sauceModifier']['id'],
            "pOrderLineNotes"           : orderItem['items']['detail'],
            "pInternetDescription"     : orderItem['items']['detail'],
            "pQuantity"        : orderItem['quantity']//passing quantity in json    
        }

        var URL = "/rest/view/tblorderlines/create-tblorderlines";

        $.ajax({
            url:  URL,
            type: "POST",
            data: JSON.stringify(json),
            success: function(data) {
                var orderItemId = data[0]['newid'];
                orderItem['id'] = orderItemId;

                var orderItems       = JSON.parse($.session.get('orderItems'));

                orderItems.push(orderItem);

                $.session.set('orderItems', JSON.stringify(orderItems));

                //pageController.updatePrice();

                // REMOVE THIS WHEN updatePrice works
                pageController.listOrderItems();
            }
        });
    }

    this.listOrderItems = function() {
        var orderId = $.session.get("orderId");
        var json = {
            "OrderID"       : orderId,
        }

        var URL = "/rest/view/tblorderlines/get-tblorderlines";

        $.ajax({
            url: URL,
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
            "StoreID": $.session.get("storeId"),
            "UnitID": UNIT_ID
        }

        firstName  = $.session.get("firstName");
        lastName   = $.session.get("lastName");
         
        var URL = "/rest/view/tblspecialty/get-tblspecialties";
        
        $.ajax({
            url:  URL,
            type: "POST",
            data: JSON.stringify(json),
            success: function(data) {
                // Yay! It worked!
                j = 0;
                html = "";
              
                var items = data
                for(var i = 0; i < items.length; i++) {
                    if(j == 0) {
                        html += "<div class=\"row\">";
                    }
                    html += pageController.buildItemList(items[i]["SpecialtyDescription"], items[i]["InternetDescription"],items[i]["SpecialtyID"],items[i]["StyleID"],items[i]["SauceID"]);
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
    
    this.buildItemList = function(name,detail,specialtyId,styleId,sauceId) {
        var specialtyImages = {
            "5"  : "Supreme300x300.jpg",
            "6"  : "TheWorks300x300.jpg",
            "7"  : "PepperoniPleas300x300.jpg",
            "8"  : "CHEESEBURGER3000x300.jpg",
            "9"  : "Hawaiian3000x300.jpg",
            "10" : "Taco3000x300.jpg",
            "11" : "Veggie300x300.jpg",
            "12" : "BLT3000x300.jpg",
            "13" : "BBQ3000x300.jpg",
            "14" : "Mediterranean3000x300.jpg",
            "16" : "ChickenBaconRanch3000x300.jpg",
            "19" : "ChickenChipotle3000x300.jpg",
            "22" : "TheWorks300x300.jpg",
            "94" : "TonyPackos300x300.jpg",
            "59" : "ItalianFoldoverSub300x300.jpg",
            "60" : "ItalianFoldoverSub300x300.jpg",
            "61" : "ItalianFoldoverSub300x300.jpg",
            "62" : "BBQChickenSub300x300.jpg",
            "64" : "ItalianFoldoverSub300x300.jpg",
            "65" : "ItalianFoldoverSub300x300.jpg",
            "68" : "ItalianFoldoverSub300x300.jpg",
            "69" : "ItalianFoldoverSub300x300.jpg",
            "88" : "ItalianFoldoverSub300x300.jpg",
            "91" : "ItalianFoldoverSub300x300.jpg",
            "38" : "ChickenSalad3000x300.jpg",
            "39" : "ItalianSalad3000x300.jpg",
            "40" : "ItalianSalad3000x300.jpg",
            "41" : "ItalianSalad3000x300.jpg",
            "42" : "ItalianSalad3000x300.jpg",
            "8002" : "VitoBread300x300.jpg",
            "8004" : "VitoBread300x300.jpg",
            "8005" : "CinnamonBread300x300.jpg",
            "8007" : "VitoBread300x300.jpg",
            "80015" : "CokeEtc300x300.jpg"
        };
    
       var html="";
       var imgUrl="";
       var item={};
        item['id']     = specialtyId;
        item['name']   = name;
        item['detail'] = detail;
        pageController.items.push(item);
        
        imgUrl =  specialtyImages[specialtyId];
      
      
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
        html += '                            <button class="red-gradient-button" onClick="pageController.getSpecialtyItems(' + specialtyId + ', ' + styleId + ', ' + sauceId + ')">ORDER NOW</button>';
        html += '                        </td>';
        html += '                        <td>';
        html += '                            <button class="red-gradient-button" onClick="pageController.getSpecialtyItems(' + specialtyId + ', ' + styleId + ', ' + sauceId + ')">SEE DETAILS</button>';
        html += "                        </td>";
        html += "                    </tr>";
        html += "                </table>";
        html += "            </td>";
        html += "        </tr>";
        html += "    </table>";
        html += "</div>";
        return html;
      
    }

    this.getURL = function(pathname){ 
     var URL=""
        if(CURRENT_ORDER_LOC == undefined )
          var CURRENT_ORDER_LOC="PIZZA";       
        if(CURRENT_ORDER_LOC=="PIZZA"){
           URL+="/rest/order-pizza/"+pathname;
        }else if(CURRENT_ORDER_LOC=="SUBS"){
           URL+="/rest/order-subs/"+pathname;
        }else if(CURRENT_ORDER_LOC=="SALADS"){
          URL+="/rest/order-salads/"+pathname;
        }      
      return URL;    
    }
    
    this.listToppings = function() {
        var json = {
            "StoreID":$.session.get("storeId"),
            "UnitID":UNIT_ID
        }
        
        var URL = "/rest/view/tblitems/get-tblitems";
        
        $.ajax({
            url: URL,
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
        
        if(toppingsArr.length < contentLength){
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
            "StoreID": $.session.get("storeId"),
            "UnitID": UNIT_ID
        }
 
        $.ajax({
            url: "/rest/view/tbltopper/get-tbltoppers" ,
            type: "POST",
            data: JSON.stringify(json),
            success: function(data) {
                // Yay! It worked!
                
                for(var i = 0; i < data.length; i++) {
                    html = "";
                    if(i == 0){
                        html += "<li class=\"header\">Type Flavors:</li>";
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
        if(topprs.length < contentLength){
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
          console.log("before--"+topperId + " "+ sessionKey+" "+Session.get(sessionKey));
        
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
        console.log("after.."+topperId+" "+sessionKey+" "+Session.get(sessionKey));
    }

    this.listSizes = function() {
        var json = {
            "StoreID":$.session.get("storeId"),
            "UnitID":UNIT_ID
        }

        var URL = "/rest/view/tblsizes/get-tblsizes";

        $.ajax({
            url: URL,
            type: "POST",
            data: JSON.stringify(json),
            success: function(data) {
                // Yay! It worked!
                
                for(var i = 0; i < data.length; i++) {
                    html = "";
                    if(i == 0){
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
        if(sizesArr.length < contentLength){
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
            "StoreID":$.session.get("storeId"),
            "UnitID":UNIT_ID,
            "SizeID":"9"
        }

        var URL = "/rest/view/tblstyles/get-tblstyles";
        
        $.ajax({
            url: URL,
            type: "POST",
            data: JSON.stringify(json),
            success: function(data) {
                // Yay! It worked!
                 
                html  = "<div id='styles'>";
                html += "<li class=\"header\">Type Options:</li>";
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
        if(styleArr.length < contentLength){
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
            "StoreID":$.session.get("storeId"),
            "UnitID":UNIT_ID
        }
        
        var URL = "/rest/view/tblsauce/get-tblsauces";

        $.ajax({
            url: URL,
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
        if(saucesArr.length < contentLength){
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
            "StoreID":$.session.get("storeId")
        }

        var URL = "/rest/view/tblsaucemodifier/get-tblsaucemodifiers";
        
        $.ajax({
            url: URL,
            type: "POST",
            data: JSON.stringify(json),
            success: function(data) {
                // Yay! It worked!
                
                for(var i = 0; i < data.length; i++) {
                    html = "";
                    if(i == 0){
                        html += "<li class=\"header\">Sauce Options:</li>";
                    } 
                    html += pageController.buildSauceModifierRadioItem(data[i]['SauceModifierID'],data[i]['SauceModifierDescription'],data.length);
                    $("#cheese-and-sauce .right-column").append(html);
                }
            }
        });
    }
    
   // this method helps to update the order. It updates one order at a time.
    this.updateOrder = function(id){
       
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

  this.prePopulateSelectedValues = function(orderItemToUpdate){
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
   if(sauce){
      $('#sauce--'+sauce['id']).attr('checked', true).trigger('click');
   }
   
   var sauceModifier = orderItemToUpdate['sauceModifier'];
   if(sauceModifier && sauceModifier['id']!="NULL"){
      $('#sauce-modifier--'+sauceModifier['id']).attr('checked', true).trigger('click');
   } 

   var toppers = orderItemToUpdate['toppers'];
   if(toppers){
    Session.set('ToppersInEdit', JSON.stringify(new Array()));
       
     for(var i=0; i<toppers.length;i++){
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
this.buildModifyModalItem = function(orderType){

  var data = JSON.parse(Session.get(orderType+'_TOPPERS'));

  var html = "";
 
  $("#qntyHolder").html(orderType=="PIZZA"? "Quantity of Pizzas :":(orderType=="SUBS")?"Quantity of Subs :":"Quantity of Salads :");
        
  if(data.length >0){  
    html += "<li class=\"header\">Type Flavors:</li>";
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
   if(data.length >0){ 
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
   html += "<li class=\"header\">Type Options:</li>";
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
        if(sauceModfrArr.length < contentLength){
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

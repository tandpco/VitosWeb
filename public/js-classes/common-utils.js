function Session () {}
Session.set = function(name, value) {
    $.session.set(name, value);
}
Session.get = function(name) {
    return($.session.get(name));
}

function NavBar () {}
NavBar.createMarkup = function() {
    var html = "";
    html += '<nav class="navbar-default main-navbar" role="navigation">';
    html += '    <div class="container">';
    html += '        <!-- Brand and toggle get grouped for better mobile display -->';
    html += '        <div class="navbar-header">';
    html += '            <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse" id="collapse-button">';
    html += '                <span class="sr-only">Toggle navigation</span>';
    html += '                <span class="icon-bar"></span>';
    html += '                <span class="icon-bar"></span>';
    html += '                <span class="icon-bar"></span>';
    html += '            </button>';
    html += '        </div>';
    html += '';
    html += '        <!-- Collect the nav links, forms, and other content for toggling -->';
    html += '        <div class="collapse navbar-collapse">';
    html += '            <ul class="nav navbar-nav navbar-right">';
     var curr_loc= window.location.pathname;
    html += '                <li><a href="/order-pizza" class="white-shadow"'+(curr_loc.indexOf("pizza")!=-1?'style="background-color:#006122"':'')+'>PIZZAS</a></li>';
    html += '                <li><a href="/order-subs" class="white-shadow"'+(curr_loc.indexOf("subs")!=-1?'style="background-color:#006122"':'')+'>SUBS</a></li>';
    html += '                <li><a href="/order-salads" class="white-shadow"'+(curr_loc.indexOf("salads")!=-1?'style="background-color:#006122"':'')+'>SALADS</a></li>';
    html += '                <li><a href="/order-sides" class="white-shadow"'+(curr_loc.indexOf("sides")!=-1?'style="background-color:#006122"':'')+'>SIDES</a></li>';
    html += '                <li><a href="/sign-in" onclick="$.session.clear()" class="white-shadow">Sign Out</a></li>';
    html += '            </ul>';
    html += '        </div>';
    html += '    </div>';
    html += '</nav>';
    return html;
}

function ModalPleaseWait () {}
ModalPleaseWait.createMarkup = function(name, message) {
    var html = "";
    html += '<div class="modal fade" data-backdrop="static" data-keyboard="false" id="' + name + '">';
    html += '    <div class="modal-dialog">';
    html += '        <div class="modal-content">';
    html += '            <div class="modal-body">';
    html += '                <h4 class="modal-title">' + message + '</h4>';
    html += '                <img src="/img/loading.gif"></img>';
    html += '            </div>';
    html += '        </div><!-- /.modal-content -->';
    html += '    </div><!-- /.modal-dialog -->';
    html += '</div><!-- /.modal -->';
    return html;
}

function ModalDelivery () {}
ModalDelivery.createMarkup = function(name, message, isRedirect) {
    var html = "";
    html += '<div class="modal fade" data-backdrop="static" data-keyboard="false" id="' + name + '">';
    html += '    <div class="modal-dialog">';
    html += '        <div class="modal-content">';
    html += '            <div class="modal-body">';
    html += '                <h5 class="modal-title">' + message + '</h4>';
    html += '                <a style="cursor:pointer; cursor:hand;" id="modeDelivery" onclick="SetDelivery.chooseDelivery(\''+isRedirect+'\')">';
    html += '                    <img src="/img/mode-delivery.png"/>';
    html += '                </a>';
    html += '                <a style="cursor:pointer; cursor:hand;" id="modePickup" onclick="SetPickup.choosePickup(\''+isRedirect+'\')">';
    html += '                    <img src="/img/mode-pickup.png"/>';
    html += '                </a>';
    html += '            </div>';
    html += '        </div><!-- /.modal-content -->';
    html += '    </div><!-- /.modal-dialog -->';
    html += '</div><!-- /.modal -->';
    return html;
}

function ModalInvalidLogin () {}
ModalInvalidLogin.createMarkup = function(name, message) {
    var html = "";
    html += '<div class="modal fade" data-backdrop="static" data-keyboard="false" id="' + name + '">';
    html += '    <div class="modal-dialog">';
    html += '        <div class="modal-content">';
    html += '            <div class="modal-body">';
    html += '                <div class="row">';
    html += '                    <h4 class="modal-title">Invalid e-mail address or password.</h4>';
    html += '                </div>';
    html += '                <div class="row">';
    html += '                    <button class="red-gradient-button" onclick="$(\'#invalidLogin\').modal(\'hide\');">' + message + '</button>';
    html += '                </div>';
    html += '            </div>';
    html += '        </div><!-- /.modal-content -->';
    html += '    </div><!-- /.modal-dialog -->';
    html += '</div><!-- /.modal -->';
    return html;
}


function ModalInvalidPromo () {}
ModalInvalidPromo.createMarkup = function(name, message) {
    var html = "";
    html += '<div id="' + name + '" class="modal fade" data-backdrop="static" data-keyboard="false">';
    html += '    <div class="modal-dialog" style="width:25%">';
    html += '        <div class="modal-content">';
    html += '            <div class="modal-body">';
    html += '                <div class="row">';
    html += '                    <h4 class="modal-title">' + message + '</h4><br>';
    html += '                </div>';
    html += '                <div class="row">';
    html += '                    <button class="red-gradient-button" onclick="$(\'#modal-invalid-promo\').modal(\'hide\');" style="width:30%">Ok</button>';
    html += '                </div>';
    html += '            </div>';
    html += '        </div><!-- /.modal-content -->';
    html += '    </div><!-- /.modal-dialog -->';
    html += '</div><!-- /.modal -->';
    return html;
}

function ModalLocation () {}
ModalLocation.createMarkup = function(name, message) {
    var html = "";
    html += '<div class="modal fade" data-backdrop="static" data-keyboard="false" id="' + name + '">';
    html += '    <div class="modal-dialog">';
    html += '        <div class="modal-content">';
    html += '            <div class="modal-body">';
    html += '                <div class="row">';
    html += '                    <h4 class="modal-title">' + message + '</h4>';
    html += '                </div>';
    html += '                <div class="row">';
    html += '                    <div id="storeInfo">';
    html += '                    </div>';
    html += '                </div>';
    html += '                <div class="row">';
    html += '                    <button class="red-gradient-button" onclick="pageController.chooseMode()">CHANGE LOCATION</button>';
    html += '                </div>';
    html += '                <div class="row">';
    html += '                    <button class="green-gradient-button" onclick="pageController.chooseMode()">CONTINUE</button>';
    html += '                </div>';
    html += '            </div>';
    html += '        </div><!-- /.modal-content -->';
    html += '    </div><!-- /.modal-dialog -->';
    html += '</div><!-- /.modal -->';
    return html;
}

function SetDelivery (){}
SetDelivery.chooseDelivery = function(isRedirect) {
        $.session.set('mode', 'Delivery');
        $('#modal-delivery').modal('hide');
        $('.modal-backdrop').remove();
        if(isRedirect =="YES"){
           window.location.href = "/order-pizza";
        }
        else if(isRedirect =="NO"){
           OrderItems.buildYourOrder();
        }
    }

function SetPickup (){}
    SetPickup.choosePickup = function(isRedirect) {
        $.session.set('mode', 'Pickup');
        $('#modal-delivery').modal('hide');
        $('.modal-backdrop').remove();
         if(isRedirect =="YES"){
           window.location.href = "/order-pizza";
        }
        else if(isRedirect =="NO"){
           OrderItems.buildYourOrder();
        }
    }
  
function OrderItems (){}
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
                if(orderItem['orderType']=="PIZZA"){
                   html += '       <span class="itemSize">' + orderItem['size']['description'] + '</span> '
               }   
                html +=                           '<span class="itemDescription">' + orderItem['item']['name'] +'('+orderItem['quantity'] +')';
                if(curr_loc.indexOf("confirmation")==-1){
                  html +=                           '<br> <span class="badge"><a style="font-size:80%;cursor: pointer; cursor: hand;text-decoration:underline;color:#000" onClick="pageController.updateOrder('+orderItem['id']+');">Edit</a></span>&nbsp;&nbsp;'; 
                  html +=                           '<a style="font-size:80%;cursor: pointer; cursor: hand;text-decoration:underline;color:#000" onClick="OrderItems.cancelOrder('+orderItem['id']+');">Remove</a>';
                }
                html +=                           '</div></span><div style="height:38px;font-size:15px;float:right;" class="col-sm-2"> <div class="row" style="float:right"><br>$ ' + orderCost.toFixed(2) +'</div></div>'
                html += '                         </a>'
                html += '                    </div></h3>'
                html += '                </div>'
                html += '                <div id="order-item-detail-' + divName + '-' + orderItem['id'] + '" class="panel-collapse collapse">'
                html += '                    <div class="panel-body">'
                if(orderItem['orderType']=="PIZZA"){
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

            html += buildPromoAccordion(promoCost,userPromos,divName);
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
            if(curr_loc.indexOf("confirmation")!=-1){
                html +=  orderTip.toFixed(2) ;
            }
            else{
                html += '<input type="text" class="ordrTip" value="'+orderTip + '" maxlength="4" size="4" style="text-align:right" onchange="OrderItems.clearField(this.value)"/>';
            }
            html += '</td>';
            html += '</tr>';
            if(curr_loc.indexOf("confirmation")==-1){
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
            if(curr_loc.indexOf("information")==-1 && curr_loc.indexOf("confirmation")==-1){
            if(orderItems.length>0)
            html += '    <th colspan="2"><hr> <button onclick="window.location.href=\'/order-information\'" type="button" class="red-gradient-button">SUBMIT ORDER</button></td>';
            }
            html += '</tr>';

            $('#order-totals-table-' + divName + ' > tbody').html(html);

        }
        
        
    // this method helps to cancel the order. It cancels one order at a time.
    OrderItems.cancelOrder = function(id){
         var json = {
                "pOrderItemId"       : id //Inputs an id as json
         }
         
         //An ajax call to cancel the order in the back end
         $.ajax({
                url: "/rest/order-pizza/delete-order-item",
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
        
        OrderItems.clearField = function(val){
          $.session.set('currentTip',val);
        }
        
        OrderItems.UpdateTip = function(){
          var tip =  $.session.get('currentTip');
                      
          if(tip==null || tip==undefined || isNaN(parseFloat(tip)))
            tip = 0;
          $.session.set('orderTip',tip);
          
          OrderItems.buildYourOrder();
        }
        OrderItems.UpdateOrderItem = function(){
           $('#modal-modify-item1').modal('hide');
           $('#modal-please-wait').modal('show');
           var orderLineId = $.session.get('selectedOrderLineId');
           if(orderLineId){
            var orderItems        = JSON.parse($.session.get('orderItems'));
            var selectedOrderItem;
             
            for(var i = 0; i < orderItems.length; i++) {
              var orderItem = orderItems[i];
              if(orderItem['id'] == orderLineId) {
                 selectedOrderItem = orderItem;
              }
            }  
            
            if(selectedOrderItem){
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
    
    function buildPromoAccordion(promoCost,userPromos,divName){
       var html='';        
      

     if(userPromos.length>0){
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

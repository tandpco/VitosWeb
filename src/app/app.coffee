$app = angular.module('app', ['ngRoute','ui.router','restangular'])

$app.config ($stateProvider, $urlRouterProvider,RestangularProvider)->
  RestangularProvider.setBaseUrl('/api')
  # $urlRouterProvider.otherwise("/state1")
  $stateProvider
    .state('detail', {
      url: "/detail/:unitId/:specialtyId",
      templateUrl: "app/partials/detail.html",
      resolve:
        $specialty: (Restangular,$stateParams)->
          Restangular.one('item').get
            "StoreID": "7"
            "UnitID":  $stateParams.unitId
            "SpecialtyID":  $stateParams.specialtyId
            "SizeID":  "null"
      controller: ($scope,$specialty,$stateParams,Restangular)->
        $scope.$sp = $specialty
        $scope.onMeat = true
        $scope.tab = 'size'
        $scope.$line = {SauceID:$specialty.specialty.SauceID,SizeID:null,Sides:[],Toppings:[],StyleID:$specialty.specialty.StyleID,Toppers:[],notes:''}
        $scope.$selectedSides = {}
        $scope.$selectedToppings = {}
        $scope.$selectedToppers = {}
        $scope.styleSurcharge = ()->
          for x in $scope.$sp.sizes
            if $scope.$line.SizeID == x.SizeID and x.StyleSurcharge > 0
              return x.StyleSurcharge
          return 0

        verifySelectedSize = (sizes)->
          sel = false
          for x in sizes
            if x.SizeID is $scope.$line.SizeID
              sel = true
          if sel is false
            $scope.$line.SizeID = sizes[0].SizeID

        # request that the database be upgraded to flag these items rather than hard code them
        $scope.filterCheese = (i)->
          return true if [10,12,13,49,52,53,59,60,84,104].indexOf(i.ItemID) isnt -1
          return false
        $scope.filterMeat = (i)->
          return false if [10,12,13,49,52,53,59,60,84,104].indexOf(i.ItemID) isnt -1
          return true if $scope.onMeat and [11,14,19,21,27,28,33,35,43,44,45,46,50,51,55,56,97,105].indexOf(i.ItemID) isnt -1
          return true if not $scope.onMeat and [11,14,19,21,27,28,33,35,43,44,45,46,50,51,55,56,97,105].indexOf(i.ItemID) is -1
          return false


        $scope.orderItem = ()->
          # orderId = Session.get("orderId")
          orderItemJson =
            # pOrderID: orderId
            pUnitID: $stateParams.unitId
            # speciality Id shouldn't be required
            pSpecialtyID: $stateParams.specialtyId
            pSizeID: $scope.$line.SizeID
            pStyleID: $scope.$line.StyleID
            pHalf1SauceID:$scope.$line.SauceID
            pHalf2SauceID: $scope.$line.SauceID
            pHalf1SauceModifierID: $scope.$line.sauceModifierID
            pHalf2SauceModifierID: $scope.$line.sauceModifierID
            # allow for notes on order line
            pOrderLineNotes: $scope.$line.notes
            # pInternetDescription: ((if not (orderItem["item"])? then "NULL" else orderItem["item"]["detail"]))
            pQuantity: $scope.$line.Quantity || 1

          # toppingsJson = $scope.$line.Toppings
          

          mode = Session.get("mode")
          deliveryMode = if mode is "Delivery" then "1" else "2"

          orderJson =
            pCustomerID: "6063" #deprecate
            pCustomerName: "Vito''s Fan" #deprecate
            pCustomerPhone: "1111111111" #deprecate
            pAddressID: "1" #deprecate
            pOrderTypeID: deliveryMode
            pDeliveryCharge: Session.get("deliveryCharge") # seems wrong
            pDriverMoney: Session.get("driverMoney") # tip??
            pOrderNotes: "" # should be updated seperately
          toppingsJson = []
          for x in $scope.$line.Toppings
            toppingsJson.push
              id: x['ItemID']
              portion: x['Portion']
          json =
            order: orderJson
            orderItem: orderItemJson
            # updatePrice: updatePriceJson
            orderItemToppings: toppingsJson
            orderItemToppers: $scope.$line.Toppers
            orderItemSides: $scope.$line.Sides

          URL = "/rest/view/order/create-order"
          $.ajax
            url: URL
            type: "POST"
            data: JSON.stringify(json)
            success: (data) ->
              console.log data
              $scope.$root.updateOrder()
              # unless orderId?
              #   console.log "Created Order Id: " + data["order"][0]["newid"]
              #   Session.set "orderId", data["order"][0]["newid"]
              # orderItemId = data["orderItem"][0]["newid"]
              # orderItem["id"] = orderItemId
              # orderItems = JSON.parse(Session.get("orderItems"))
              # orderItems.push orderItem
              # Session.set "orderItems", JSON.stringify(orderItems)
              # pageController.listOrderItems()
              # return

        $scope.setSide = (side,value)->
          $scope.$selectedSides[side.SideID] = value
          $v ={already:false,remove:false}
          _.each $scope.$line.Sides,(val,key)->
            if val.SideID is side.SideID
              if value is false
                $v.remove = key
              else
                val.Quantity = parseInt value
              $v.already = true
          console.log side,value
          if $v.remove isnt false
            $scope.$line.Sides.splice($v.remove,1)
            console.log 'removed'
          if not $v.already
            $scope.$line.Sides.push {SideID:side.SideID,Quantity:parseInt value}
        $scope.setTopping = (topping,value,side)->
          if value
            $scope.$selectedToppings[topping.ItemID] = side
          else
            $scope.$selectedToppings[topping.ItemID] = false
          $v ={already:false,remove:false}
          _.each $scope.$line.Toppings,(val,key)->
            if val.ItemID is topping.ItemID
              if value is false
                $v.remove = key
              val.Portion = side
              $v.already = true

          console.log topping,value,$scope.$line.Toppings
          if $v.remove isnt false
            $scope.$line.Toppings.splice($v.remove,1)
            console.log 'removed'
          if not $v.already
            $scope.$line.Toppings.push {ItemID:topping.ItemID,Portion:side}

        $scope.setTopper = (topper,value)->
          $scope.$selectedToppers[topper.TopperID] = value && true || false
          exists = $scope.$line.Toppers.indexOf(topper.TopperID) != -1
          if not value and exists
            $scope.$line.Toppers.splice($scope.$line.Toppers.indexOf(topper.TopperID),1)
          if value and not exists
            $scope.$line.Toppers.push(topper.TopperID)


        if _.isArray $scope.$sp.defaults
          for x in $scope.$sp.defaults
            $scope.setTopping x,true,'whole'
        if not $specialty.NoBaseCheese
          for x in $specialty.toppings
            if x.IsBaseCheese
              $scope.setTopping x,true,'whole'

        # $scope.$watchCollection "$line.Sides",(v)->
        #   console.log 'chosen sides',v
        # $scope.$watchCollection "$line.Toppings",(v)->
        #   console.log 'chosen toppings',v
        $scope.$watch "$line.StyleID",(v)->
          if v
            $scope.checkingSizes = true
            Restangular.all("item-sizes").getList(
              "StoreID": "7"
              "UnitID":  $stateParams.unitId
              "SpecialtyID":  $stateParams.specialtyId
              "StyleID":  v
            ).then (v)->
              $scope.checkingSizes = false
              verifySelectedSize(v)
              $scope.$sp.sizes = v
    })

$app.run ($state,$rootScope,Restangular)->
  window.__itemDetail = (unitId,specialtyId)->
    $state.go('detail',{unitId:unitId,specialtyId:specialtyId})
  window.updateOrder = ()->
    $rootScope.updateOrder()
  $rootScope.halfPretty = (half)->
    half = parseInt half
    halfs = ['Whole','Left','Right','2x']
    return halfs[half]
  $rootScope.updateOrder = ()->
    $rootScope.$lines = []
    Restangular.one("order").get().then (v)->
      $rootScope.$order = v
    Restangular.one("order").all("lines").getList().then (v)->
      console.log v
      $rootScope.$lines = v
  $rootScope.updateOrder()

  return
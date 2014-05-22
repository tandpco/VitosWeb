<%
option explicit
Response.buffer = TRUE

If UCase(Request.ServerVariables("HTTPS")) <> "ON" Then
	Response.Redirect("https://www.vitos.com/orderdev/Default.asp")
End If

If (Request("ACTION") = "ADD") And (Len(Request("UNITNUM")) = 0 Or Len(Request("UNITNAME")) = 0) Then
	Response.Redirect("deals.asp")
End If

If (Request("ACTION") = "REMOVE") And (Len(Request("ORDERITEMID")) = 0 Or (Not IsNumeric(Request("ORDERITEMID"))) Or Request("ORDERITEMID") = 0) Then
	Response.Redirect("deals.asp")
End If
%>
<!-- #Include File="include/adovbs.asp" -->
<!-- #Include File="include/app-settings.asp" -->
<!-- #Include File="include/app-database.asp" -->
<!-- #Include File="include/app-ordering.asp" -->
<%
Dim nStore, sName, sAddress1, sAddress2, sCity, sState, sPostalCode, sPhone, sFax, sHours, sDisplayAddress, nTempStore, nDelivery, nDrMoney
Dim saUnitName(), naUnitNum(), saUnitDesc(), saCustomDesc(), i, oFS, sFileName
Dim nOrderID, dDelivery, dDrMoney, dTax, dTip, anOrderItemID(), anQty(), asDescription(), adPrice(), dSubtotal, dTotal, dDeliveryMin, naPromos, naPromoCodes
Dim saCurrentPromoCodes, naCurrentPromos, sPromoCodeError
Dim bFoundPromo, bSubPromoValid
Dim sAddress, sApt
Dim nAddressID

sPromoCodeError = ""

If Request("SWITCHSYS") = "YES" Then
	' Strip all non-numeric from zip and phone
	sPostalCode = ""
	For i = 1 to Len(Trim(Request("SWITCHSYS-ZIPCODE")))
		If IsNumeric(Mid(Trim(Request("SWITCHSYS-ZIPCODE")), i, 1)) Then
			sPostalCode = sPostalCode + Mid(Trim(Request("SWITCHSYS-ZIPCODE")), i, 1)
		End If
	Next
	If Len(sPostalCode) > 5 Then
		sPostalCode = Left(sPostalCode, 5)
	End If
	
	sAddress = Request("SWITCHSYS-ADDRESS")
	If Len(Request("SWITCHSYS-APT")) > 0 Then
		sAddress = sAddress & " #" & Request("SWITCHSYS-APT")
	End If
	nStore = LocateStoreByAddress(sPostalCode, sAddress, sApt, sCity, sState, nDelivery, nDrMoney)
	
	Session("RefID") = Request("SWITCHSYS-RefID")
	Session("EMAIL") = Request("SWITCHSYS-EMAIL")
	Session("FIRSTNAME") = "Vito's"
	Session("LASTNAME") = "Fan"
	Session("PHONE") = ""
	Session("CUSTOMERID") = 1
	Session("SPECINST") = ""
	
	nAddressID = GetAddressID(sPostalCode, sAddress, sApt, sCity, sState)
	If nAddressID = 0 Then
		nAddressID = AddAddress(nStore, sAddress, sApt, sCity, sState, sPostalCode)
	End If
	
	Session("ADDRESSID") = nAddressID
	
	Session("ORDERID") = 0
	Session("NUMITEMS") = 0
	Session("ADDRESS") = sAddress
	Session("APT") = sApt
	Session("CITY") = sCity
	Session("STATE") = sState
	Session("ZIPCODE") = sPostalCode
	Session("DMA") = 1
	Session("STORE") = nStore
	Session("MODE") = "DELIVERY"
	Session("DELIVERY") = CDbl(nDelivery)
	Session("DRMONEY") = CDbl(nDrMoney)
	
	Session("ACTIVITYID") = LogActivity(Session("EMAIL"), sAddress, sApt, sCity, sState, sPostalCode, nStore)
End If

If (Request("ACTION") = "DELIVERY" Or Request("ACTION") = "PICKUP") Then
	If Request("ACTION") = "DELIVERY" Then
		nStore = LocateStoreByAddress(Session("ZIPCODE"), Session("ADDRESS"), Session("APT"), Session("CITY"), Session("STATE"), nDelivery, nDrMoney)
		
		If nStore = 0 Then
			Response.Redirect("pickup.asp?ACTION=PICKUP")
		End If
		
		If nStore < 17 And nStore > 2 And nStore <> 5 And nStore <> 15 And nStore <> 13 Then
			Response.Redirect("switchsys.asp?store=" & nStore)
		End If
	Else
		nStore = Request.Form("STORE")
	End If
	
	If GetStoreInfo(nStore, sName, sAddress1, sAddress2, sCity, sState, sPostalCode, sPhone, sFax, sHours) Then
		Session("STORE") = nStore
		
		If Request.Form("ACTION") = "DELIVERY" Then
			UpdateActivityStore Session("ACTIVITYID"), nStore, 1
		Else
			UpdateActivityStore Session("ACTIVITYID"), nStore, 2
		End If
		
		If Session("ORDERID") > 0 Then
			If Request("ACTION") = "DELIVERY" Then
				If SetOrderType(Session("ORDERID"), nStore, 1, nDelivery, nDrMoney) Then
					Session("MODE") = "DELIVERY"
					Session("DELIVERY") = nDelivery
					Session("DRMONEY") = nDrMoney
					
					If CInt(Session("NUMITEMS")) > 0 Then
						GetPricing Session("STORE"), Session("ORDERID"), Session("PROMOCODES"), Session("PROMOS")
					End If
				Else
					Response.Redirect("Default.asp")
				End If
			Else
				If SetOrderType(Session("ORDERID"), nStore, 2, 0.00, 0.00) Then
					Session("MODE") = "PICKUP"
					Session("DELIVERY") = CDbl(0.00)
					Session("DRMONEY") = CDbl(0.00)
					
					If CInt(Session("NUMITEMS")) > 0 Then
						GetPricing Session("STORE"), Session("ORDERID"), Session("PROMOCODES"), Session("PROMOS")
					End If
				Else
					Response.Redirect("Default.asp")
				End If
			End If
		Else
			If Request("ACTION") = "DELIVERY" Then
				Session("MODE") = "DELIVERY"
				Session("DELIVERY") = nDelivery
				Session("DRMONEY") = nDrMoney
			Else
				Session("MODE") = "PICKUP"
				Session("DELIVERY") = CDbl(0.00)
				Session("DRMONEY") = CDbl(0.00)
			End If
		End If
	Else
		Response.Redirect("Default.asp")
	End If
End If

If Len(Session("ADDRESS")) = 0 Or Len(Session("ZIPCODE")) = 0 Or Len(Session("STORE")) = 0 Then
	Response.Redirect("Default.asp")
End If

If Not IsStoreEnabled(Session("STORE")) Then
	Response.Redirect("maintenance.asp")
End If

If (Request("ACTION") = "PROMOCODE") Or (Request("ACTION") = "PICKUP" And Request("PROMOCODE").Count > 0) Then
	If Len(Trim(Request("PROMOCODE"))) > 0 Then
		If IsPromoCodeFreeSaladAndBread(Session("DMA"), Trim(Request("PROMOCODE"))) Then
			If CInt(Session("NUMITEMS")) > 0 Then
				If ValidateFreeSaladAndBread(Session("ORDERID"), Trim(Request("PROMOCODE"))) Then
					If Len(Session("PROMOCODES")) = 0 Then
						Session("PROMOCODES") = UCase(Trim(Request("PROMOCODE")))
						
						GetPricing Session("STORE"), Session("ORDERID"), Session("PROMOCODES"), Session("PROMOS")
					Else
						bFoundPromo = FALSE
						saCurrentPromoCodes = Split(Session("PROMOCODES"), ",")
						
						For i = 0 To UBound(saCurrentPromoCodes)
							If UCase(saCurrentPromoCodes(i)) = UCase(Trim(Request("PROMOCODE"))) Then
								bFoundPromo = TRUE
							End If
						Next
						
						If bFoundPromo Then
							If UCase(Trim(Request("PROMOCODE"))) = "FREESB" Then
								sPromoCodeError = "<b><i>That promo code has already been entered. Please ensure you have added to your order a small salad, small cheezy breadsticks and a pizza.</i></b>"
							Else
								If UCase(Trim(Request("PROMOCODE"))) = "FREESB2" Then
									sPromoCodeError = "<b><i>That promo code has already been entered. Please ensure you have added to your order a small salad, small cheezy breadsticks, 2 liter and a pizza.</i></b>"
								Else
									sPromoCodeError = "<b><i>That promo code has already been entered. Please ensure you have added to your order a small salad, small cheezy breadsticks, and either a pizza or a sub.</i></b>"
								End If
							End If
						Else
							Session("PROMOCODES") = Session("PROMOCODES") & "," & UCase(Trim(Request("PROMOCODE")))
							
							GetPricing Session("STORE"), Session("ORDERID"), Session("PROMOCODES"), Session("PROMOS")
						End If
					End If
				Else
					If UCase(Trim(Request("PROMOCODE"))) = "FREESB" Then
						sPromoCodeError = "<b><i>Please add a small salad, small cheezy breadsticks and a pizza to your order prior to entering this promo code.</i></b>"
					Else
						If UCase(Trim(Request("PROMOCODE"))) = "FREESB2" Then
							sPromoCodeError = "<b><i>Please add a small salad, small cheezy breadsticks, 2 liter and a pizza to your order prior to entering this promo code.</i></b>"
						Else
							sPromoCodeError = "<b><i>Please add a small salad, small cheezy breadsticks, and either a pizza or a sub to your order prior to entering this promo code.</i></b>"
						End If
					End If
				End If
			Else
				If UCase(Trim(Request("PROMOCODE"))) = "FREESB" Then
					sPromoCodeError = "<b><i>Please add a small salad, small cheezy breadsticks and a pizza to your order prior to entering this promo code.</i></b>"
				Else
					If UCase(Trim(Request("PROMOCODE"))) = "FREESB2" Then
						sPromoCodeError = "<b><i>Please add a small salad, small cheezy breadsticks, 2 liter and a pizza to your order prior to entering this promo code.</i></b>"
					Else
						sPromoCodeError = "<b><i>Please add a small salad, small cheezy breadsticks, and either a pizza or a sub to your order prior to entering this promo code.</i></b>"
					End If
				End If
			End If
		Else
			If IsPromoCodeSub(Session("DMA"), Trim(Request("PROMOCODE"))) Then
				If CInt(Session("NUMITEMS")) > 0 Then
					bSubPromoValid = FALSE
					
					If ValidateBunSubPromo(Session("ORDERID")) Then
						bSubPromoValid = TRUE
						
						If Len(Session("PROMOS")) = 0 Then
							Session("PROMOS") = "5898"
						Else
							bFoundPromo = FALSE
							naCurrentPromos = Split(Session("PROMOS"), ",")
							
							For i = 0 To UBound(naCurrentPromos)
								If CDbl(naCurrentPromos(i)) = 5898 Then
									bFoundPromo = TRUE
								End If
							Next
							
							If Not bFoundPromo Then
								Session("PROMOS") = Session("PROMOS") & ",5898"
							End If
						End If
					End If
					
					If ValidateFoldoverSubPromo(Session("ORDERID")) Then
						bSubPromoValid = TRUE
						
						If Len(Session("PROMOS")) = 0 Then
							Session("PROMOS") = "4532"
						Else
							bFoundPromo = FALSE
							naCurrentPromos = Split(Session("PROMOS"), ",")
							
							For i = 0 To UBound(naCurrentPromos)
								If CDbl(naCurrentPromos(i)) = 4532 Then
									bFoundPromo = TRUE
								End If
							Next
							
							If Not bFoundPromo Then
								Session("PROMOS") = Session("PROMOS") & ",4532"
							End If
						End If
					End If
					
					If ValidateWholeSubPromo(Session("ORDERID")) Then
						bSubPromoValid = TRUE
						
						If Len(Session("PROMOS")) = 0 Then
							Session("PROMOS") = "9236"
						Else
							bFoundPromo = FALSE
							naCurrentPromos = Split(Session("PROMOS"), ",")
							
							For i = 0 To UBound(naCurrentPromos)
								If CDbl(naCurrentPromos(i)) = 9236 Then
									bFoundPromo = TRUE
								End If
							Next
							
							If Not bFoundPromo Then
								Session("PROMOS") = Session("PROMOS") & ",9236"
							End If
						End If
					End If
					
					If ValidateWholeFoldoverPromo(Session("ORDERID")) Then
						bSubPromoValid = TRUE
						
						If Len(Session("PROMOS")) = 0 Then
							Session("PROMOS") = "5258"
						Else
							bFoundPromo = FALSE
							naCurrentPromos = Split(Session("PROMOS"), ",")
							
							For i = 0 To UBound(naCurrentPromos)
								If CDbl(naCurrentPromos(i)) = 5258 Then
									bFoundPromo = TRUE
								End If
							Next
							
							If Not bFoundPromo Then
								Session("PROMOS") = Session("PROMOS") & ",5258"
							End If
						End If
					End If
					
					If bSubPromoValid Then
						GetPricing Session("STORE"), Session("ORDERID"), Session("PROMOCODES"), Session("PROMOS")
					Else
						sPromoCodeError = "<b><i>Please add a whole sub or foldover to your order prior to entering this promo code.</i></b>"
					End If
				Else
					sPromoCodeError = "<b><i>Please add a whole sub or foldover to your order prior to entering this promo code.</i></b>"
				End If
			Else
				If IsPromoCodePizzaAndBread(Session("DMA"), Trim(Request("PROMOCODE"))) Then
					If CInt(Session("NUMITEMS")) > 0 Then
						If ValidatePizzaAndBread(Session("ORDERID")) Then
							If Len(Session("PROMOCODES")) = 0 Then
								Session("PROMOCODES") = UCase(Trim(Request("PROMOCODE")))
								
								GetPricing Session("STORE"), Session("ORDERID"), Session("PROMOCODES"), Session("PROMOS")
							Else
								bFoundPromo = FALSE
								saCurrentPromoCodes = Split(Session("PROMOCODES"), ",")
								
								For i = 0 To UBound(saCurrentPromoCodes)
									If UCase(saCurrentPromoCodes(i)) = UCase(Trim(Request("PROMOCODE"))) Then
										bFoundPromo = TRUE
									End If
								Next
								
								If bFoundPromo Then
									sPromoCodeError = "<b><i>That promo code has already been entered. Please ensure you have added to your order a large pizza and a small cheezy breadsticks.</i></b>"
								Else
									Session("PROMOCODES") = Session("PROMOCODES") & "," & UCase(Trim(Request("PROMOCODE")))
									
									GetPricing Session("STORE"), Session("ORDERID"), Session("PROMOCODES"), Session("PROMOS")
								End If
							End If
						Else
							sPromoCodeError = "<b><i>Please add a large pizza and a small cheezy breadsticks to your order prior to entering this promo code.</i></b>"
						End If
					Else
						sPromoCodeError = "<b><i>Please add a large pizza and a small cheezy breadsticks to your order prior to entering this promo code.</i></b>"
					End If
				Else
					If IsPromoCodeWithPizzaPurchase(Session("DMA"), Trim(Request("PROMOCODE"))) Then
						If CInt(Session("NUMITEMS")) > 0 Then
							If ValidatePizza(Session("ORDERID"), Trim(Request("PROMOCODE"))) Then
								If Len(Session("PROMOCODES")) = 0 Then
									Session("PROMOCODES") = UCase(Trim(Request("PROMOCODE")))
									
									GetPricing Session("STORE"), Session("ORDERID"), Session("PROMOCODES"), Session("PROMOS")
								Else
									bFoundPromo = FALSE
									saCurrentPromoCodes = Split(Session("PROMOCODES"), ",")
									
									For i = 0 To UBound(saCurrentPromoCodes)
										If UCase(saCurrentPromoCodes(i)) = "10FW" Or UCase(saCurrentPromoCodes(i)) = "SVBF" Or UCase(saCurrentPromoCodes(i)) = "FSCB" Then
											bFoundPromo = TRUE
										End If
									Next
									
									If bFoundPromo Then
										sPromoCodeError = "<b><i>A free item promo code has already been entered.</i></b>"
									Else
										Session("PROMOCODES") = Session("PROMOCODES") & "," & UCase(Trim(Request("PROMOCODE")))
										
										GetPricing Session("STORE"), Session("ORDERID"), Session("PROMOCODES"), Session("PROMOS")
									End If
								End If
							Else
								Select Case UCase(Trim(Request("PROMOCODE")))
									Case "10FW"
										sPromoCodeError = "<b><i>Please add a pizza and an order of 10 chicken wings to your order prior to entering this promo code.</i></b>"
									Case "SVBF"
										sPromoCodeError = "<b><i>Please add a pizza and a small Vito's Bread to your order prior to entering this promo code.</i></b>"
									Case "FSCB"
										sPromoCodeError = "<b><i>Please add a pizza and a small Cinnamon Breadsticks to your order prior to entering this promo code.</i></b>"
								End Select
							End If
						Else
							Select Case UCase(Trim(Request("PROMOCODE")))
								Case "10FW"
									sPromoCodeError = "<b><i>Please add a pizza and an order of 10 chicken wings to your order prior to entering this promo code.</i></b>"
								Case "SVBF"
									sPromoCodeError = "<b><i>Please add a pizza and a small Vito's Bread to your order prior to entering this promo code.</i></b>"
								Case "FSCB"
									sPromoCodeError = "<b><i>Please add a pizza and a small Cinnamon Breadsticks to your order prior to entering this promo code.</i></b>"
							End Select
						End If
					Else
						If IsPromoCodeWithPizzaOrSubPurchase(Session("DMA"), Trim(Request("PROMOCODE"))) Then
							If CInt(Session("NUMITEMS")) > 0 Then
								If ValidatePizzaOrSub(Session("ORDERID"), Trim(Request("PROMOCODE"))) Then
									If Len(Session("PROMOCODES")) = 0 Then
										Response.Redirect("customize.asp?pcode=" & UCase(Trim(Request("PROMOCODE"))) & "&Spec=97")
									Else
										bFoundPromo = FALSE
										saCurrentPromoCodes = Split(Session("PROMOCODES"), ",")
										
										For i = 0 To UBound(saCurrentPromoCodes)
											If UCase(saCurrentPromoCodes(i)) = "UTMAC" Then
												bFoundPromo = TRUE
											End If
										Next
										
										If bFoundPromo Then
											sPromoCodeError = "<b><i>That code has already been entered.</i></b>"
										Else
											Response.Redirect("customize.asp?pcode=" & UCase(Trim(Request("PROMOCODE"))) & "&Spec=97")
										End If
									End If
								Else
									Select Case UCase(Trim(Request("PROMOCODE")))
										Case "UTMAC"
											sPromoCodeError = "<b><i>Please add a pizza, sub or foldover to your order prior to entering this promo code.</i></b>"
									End Select
								End If
							Else
								Select Case UCase(Trim(Request("PROMOCODE")))
									Case "UTMAC"
										sPromoCodeError = "<b><i>Please add a pizza, sub or foldover to your order prior to entering this promo code.</i></b>"
								End Select
							End If
						Else
							If IsPromoCodeSpecificSpecialty(Session("DMA"), Trim(Request("PROMOCODE"))) Then
								If CInt(Session("NUMITEMS")) > 0 Then
									If ValidateSpecificSpecialty(Session("DMA"), Session("ORDERID"), Trim(Request("PROMOCODE"))) Then
										If Len(Session("PROMOCODES")) = 0 Then
											Session("PROMOCODES") = UCase(Trim(Request("PROMOCODE")))
											
											GetPricing Session("STORE"), Session("ORDERID"), Session("PROMOCODES"), Session("PROMOS")
										Else
											bFoundPromo = FALSE
											saCurrentPromoCodes = Split(Session("PROMOCODES"), ",")
											
											For i = 0 To UBound(saCurrentPromoCodes)
												If UCase(saCurrentPromoCodes(i)) = "FRVB" Or UCase(saCurrentPromoCodes(i)) = "FRFS" Or UCase(saCurrentPromoCodes(i)) = "FRCW" Or UCase(saCurrentPromoCodes(i)) = "FRSAL" Then
													bFoundPromo = TRUE
												End If
											Next
											
											If bFoundPromo Then
												sPromoCodeError = "<b><i>That promo code has already been entered.</i></b>"
											Else
												Session("PROMOCODES") = Session("PROMOCODES") & "," & UCase(Trim(Request("PROMOCODE")))
												
												GetPricing Session("STORE"), Session("ORDERID"), Session("PROMOCODES"), Session("PROMOS")
											End If
										End If
									Else
										Select Case GetPromoCodeCouponID(Session("DMA"), Trim(Request("PROMOCODE")))
											Case 199
												sPromoCodeError = "<b><i>Please add a small Pancho Vito Taco or Mediterranean pizza to your order prior to entering this promo code.</i></b>"
										End Select
									End If
								Else
									Select Case GetPromoCodeCouponID(Session("DMA"), Trim(Request("PROMOCODE")))
										Case 199
											sPromoCodeError = "<b><i>Please add a small Pancho Vito Taco or Mediterranean pizza to your order prior to entering this promo code.</i></b>"
									End Select
								End If
							Else
								If IsPromoCodeWithMinimumPurchase(Session("DMA"), Trim(Request("PROMOCODE"))) Then
									If CInt(Session("NUMITEMS")) > 0 Then
										If ValidateMinimumPurchase(Session("ORDERID"), Trim(Request("PROMOCODE")), CDbl(Session("GTOTAL"))) Then
											If Len(Session("PROMOCODES")) = 0 Then
												Response.Redirect("customize.asp?pcode=" & UCase(Trim(Request("PROMOCODE"))))
											Else
												bFoundPromo = FALSE
												saCurrentPromoCodes = Split(Session("PROMOCODES"), ",")
												
												For i = 0 To UBound(saCurrentPromoCodes)
													If UCase(saCurrentPromoCodes(i)) = UCase(Trim(Request("PROMOCODE"))) Then
														bFoundPromo = TRUE
													End If
												Next
												
												If bFoundPromo Then
													sPromoCodeError = "<b><i>That code has already been entered.</i></b>"
												Else
													Response.Redirect("customize.asp?pcode=" & UCase(Trim(Request("PROMOCODE"))))
												End If
											End If
										Else
											Select Case UCase(Trim(Request("PROMOCODE")))
												Case "LBREAD"
													sPromoCodeError = "<b><i>That promo code is only valid with a $10 purchase on 4/24/2013 or 4/25/2013.</i></b>"
												Case "FSSP"
													sPromoCodeError = "<b><i>That promo code is only valid with a $9 purchase every Monday and Tuesday in May.</i></b>"
												Case "LCINN"
													sPromoCodeError = "<b><i>That promo code is only valid with a $10 purchase every Wednesday and Thursday in June.</i></b>"
											End Select
										End If
									Else
										Select Case UCase(Trim(Request("PROMOCODE")))
											Case "LBREAD"
												sPromoCodeError = "<b><i>That promo code is only valid with a $10 purchase on 4/24/2013 or 4/25/2013.</i></b>"
											Case "FSSP"
												sPromoCodeError = "<b><i>That promo code is only valid with a $9 purchase every Monday and Tuesday in May.</i></b>"
											Case "LCINN"
												sPromoCodeError = "<b><i>That promo code is only valid with a $10 purchase every Wednesday and Thursday in June.</i></b>"
										End Select
									End If
								Else
									If IsPromoCodeTimeBased(Session("DMA"), Trim(Request("PROMOCODE"))) Then
										If ValidateTimeBased(Session("ORDERID"), Trim(Request("PROMOCODE"))) Then
											If Len(Session("PROMOCODES")) = 0 Then
												Response.Redirect("customize.asp?pcode=" & UCase(Trim(Request("PROMOCODE"))))
											Else
												bFoundPromo = FALSE
												saCurrentPromoCodes = Split(Session("PROMOCODES"), ",")
												
												For i = 0 To UBound(saCurrentPromoCodes)
													If UCase(saCurrentPromoCodes(i)) = UCase(Trim(Request("PROMOCODE"))) Then
														bFoundPromo = TRUE
													End If
												Next
												
												If bFoundPromo Then
													sPromoCodeError = "<b><i>That code has already been entered.</i></b>"
												Else
													Response.Redirect("customize.asp?pcode=" & UCase(Trim(Request("PROMOCODE"))))
												End If
											End If
										Else
											Select Case UCase(Trim(Request("PROMOCODE")))
												Case "5SS5", "5SR5"
													sPromoCodeError = "<b><i>That promo code is only valid before 5 PM on Mondays and Tuesdays in April 2013.</i></b>"
												Case "6SS5", "6SR5"
													sPromoCodeError = "<b><i>That promo code is only valid after 5 PM on Mondays and Tuesdays in April 2013.</i></b>"
											End Select
										End If
									Else
										If IsPromoCodePizzaFoldAndPop(Session("DMA"), Trim(Request("PROMOCODE"))) Then
											If CInt(Session("NUMITEMS")) > 0 Then
												If ValidatePizzaFoldAndPop(Session("ORDERID"), Trim(Request("PROMOCODE"))) Then
													If Len(Session("PROMOCODES")) = 0 Then
														Session("PROMOCODES") = UCase(Trim(Request("PROMOCODE")))
														
														GetPricing Session("STORE"), Session("ORDERID"), Session("PROMOCODES"), Session("PROMOS")
													Else
														bFoundPromo = FALSE
														saCurrentPromoCodes = Split(Session("PROMOCODES"), ",")
														
														For i = 0 To UBound(saCurrentPromoCodes)
															If UCase(saCurrentPromoCodes(i)) = UCase(Trim(Request("PROMOCODE"))) Then
																bFoundPromo = TRUE
															End If
														Next
														
														If bFoundPromo Then
															Select Case UCase(Trim(Request("PROMOCODE")))
																Case "6SCOMBO"
																	sPromoCodeError = "<b><i>That promo code has already been entered. Please ensure you have added to your order a small 1 item pizza and a 20oz beverage.</i></b>"
																Case "6FCOMBO"
																	sPromoCodeError = "<b><i>That promo code has already been entered. Please ensure you have added to your order a whole foldover and a 20oz beverage.</i></b>"
															End Select
														Else
															Session("PROMOCODES") = Session("PROMOCODES") & "," & UCase(Trim(Request("PROMOCODE")))
															
															GetPricing Session("STORE"), Session("ORDERID"), Session("PROMOCODES"), Session("PROMOS")
														End If
													End If
												Else
													Select Case UCase(Trim(Request("PROMOCODE")))
														Case "6SCOMBO"
															sPromoCodeError = "<b><i>Please add a small 1 item pizza and a 20oz beverage to your order prior to entering this promo code.</i></b>"
														Case "6FCOMBO"
															sPromoCodeError = "<b><i>Please add a whole foldover and a 20oz beverage to your order prior to entering this promo code.</i></b>"
													End Select
												End If
											Else
												Select Case UCase(Trim(Request("PROMOCODE")))
													Case "6SCOMBO"
														sPromoCodeError = "<b><i>Please add a small 1 item pizza and a 20oz beverage to your order prior to entering this promo code.</i></b>"
													Case "6FCOMBO"
														sPromoCodeError = "<b><i>Please add a whole foldover and a 20oz beverage to your order prior to entering this promo code.</i></b>"
												End Select
											End If
										Else
											If ValidatePromoCode(Session("DMA"), Session("STORE"), UCase(Trim(Request("PROMOCODE")))) Then
												If IsPromoCodeBOGO(UCase(Trim(Request("PROMOCODE")))) Then
													If Len(Session("PROMOCODES")) = 0 Then
														Session("PROMOCODES") = UCase(Trim(Request("PROMOCODE")))
														GetPricing Session("STORE"), Session("ORDERID"), Session("PROMOCODES"), Session("PROMOS")
													Else
														bFoundPromo = FALSE
														saCurrentPromoCodes = Split(Session("PROMOCODES"), ",")
														
														For i = 0 To UBound(saCurrentPromoCodes)
															If UCase(saCurrentPromoCodes(i)) = UCase(Trim(Request("PROMOCODE"))) Then
																bFoundPromo = TRUE
															End If
														Next
														
														If Not bFoundPromo Then
															Session("PROMOCODES") = Session("PROMOCODES") & "," & UCase(Trim(Request("PROMOCODE")))
															GetPricing Session("STORE"), Session("ORDERID"), Session("PROMOCODES"), Session("PROMOS")
														End If
													End If
													
													sPromoCodeError = "<b><i>Code accepted and will be reflected in pricing when all items are in your cart.</i></b>"
												Else
													Response.Redirect("customize.asp?pcode=" & UCase(Trim(Request("PROMOCODE"))))
												End If
											Else
												sPromoCodeError = "<b><i>Sorry, the promo code you entered is not valid.</i></b>"
											End If
										End If
									End If
								End If
							End If
						End If
					End If
				End If
			End If
		End If
	Else
		sPromoCodeError = "<b><i>Sorry, the promo code you entered is not valid.</i></b>"
	End If
End If

If Request("xcode").Count > 0 Then
	If Len(Session("PROMOCODES")) > 0 Then
		saCurrentPromoCodes = Split(Session("PROMOCODES"), ",")
		Session("PROMOCODES") = ""
		For i = 0 To UBound(saCurrentPromoCodes)
			If UCase(saCurrentPromoCodes(i)) <> UCase(Trim(Request("xcode"))) Then
				If Len(Session("PROMOCODES")) = 0 Then
					Session("PROMOCODES") = UCase(saCurrentPromoCodes(i))
				Else
					Session("PROMOCODES") = Session("PROMOCODES") & "," & UCase(saCurrentPromoCodes(i))
				End If
			End If
		Next
		
		If CInt(Session("NUMITEMS")) > 0 Then
			GetPricing Session("STORE"), Session("ORDERID"), Session("PROMOCODES"), Session("PROMOS")
		End If
	End If
End If

If Request("xpromo").Count > 0 Then
	If Len(Session("PROMOS")) > 0 Then
		naCurrentPromos = Split(Session("PROMOS"), ",")
		Session("PROMOS") = ""
		For i = 0 To UBound(naCurrentPromos)
			If CDbl(naCurrentPromos(i)) <> CDbl(Trim(Request("xpromo"))) Then
				If Len(Session("PROMOS")) = 0 Then
					Session("PROMOS") = naCurrentPromos(i)
				Else
					Session("PROMOS") = Session("PROMOS") & "," & naCurrentPromos(i)
				End If
			End If
		Next
		
		If CInt(Session("NUMITEMS")) > 0 Then
			GetPricing Session("STORE"), Session("ORDERID"), Session("PROMOCODES"), Session("PROMOS")
		End If
	End If
End If
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Welcome to Vito&#39;s Pizza Online Ordering</title>
<link rel="stylesheet" href="css/ordering2.css" type="text/css" />
</head>

<body bgcolor="#FFFFFF" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table id="Table_01" width="851" border="0" cellpadding="0" cellspacing="0" align="center">
	<tr>
		<td rowspan="8" background="images/template_01.jpg" width="1" height="647"></td>
		<td colspan="18" align="left" valign="top" background="images/template_02.jpg" width="804" height="133">
			&nbsp;<br />
			<table width="804" cellpadding="0" cellspacing="0" border="0">
				<tr>
					<td valign="top" width="254" align="center">
						<span class="total">TEST SYSTEM</span>
					</td>
					<td valign="top" width="170">
<%
sDisplayAddress = Session("ADDRESS")
If Len(Session("APT")) > 0 Then
	sDisplayAddress = sDisplayAddress & " #" & Session("APT")
End If
%>
						<strong>Your Location:</strong><br />
						<%=Session("FIRSTNAME")%>&nbsp;<%=Session("LASTNAME")%><br />
						<%=sDisplayAddress%><br />
						<%=Session("CITY")%>, <%=Session("STATE")%>&nbsp;<%=Session("ZIPCODE")%><br />
						<a href="register.asp"><img src="images/change.jpg" width="109" height="38" alt="Change" /></a>
					</td>
					<td valign="top" width="170">
<%
If GetStoreInfo(Session("STORE"), sName, sAddress1, sAddress2, sCity, sState, sPostalCode, sPhone, sFax, sHours) Then
	If Session("MODE") = "DELIVERY" Then
%>
						<strong>Delivering From:</strong><br />
<%
	Else
%>
						<strong>Pickup From:</strong><br />
<%
	End If
%>
						<%=sAddress1%><br />
<%
	If Not IsEmpty(sAddress2) And Not IsNull(sAddress2) Then
%>
						<%=sAddress2%><br />
<%
	End If
%>
						<%=sCity%>,&nbsp;<%=sState%>&nbsp;<%=sPostalCode%><br />
						<%=Left(sPhone, 3) & "-" & Mid(sPhone, 4, 3) & "-" & Mid(sPhone, 7)%><br />
<%
	If Session("MODE") = "DELIVERY" Then
%>
						<a href="pickup.asp?ACTION=PICKUP"><img src="images/pickup.jpg" width="118" height="36" alt="Switch to Pickup" /></a>
<%
	Else
		nTempStore = LocateStoreByAddress(Session("ZIPCODE"), Session("ADDRESS"), Session("APT"), Session("CITY"), Session("STATE"), nDelivery, nDrMoney)
		
		If nTempStore > 0 Then
%>
						<a href="deals.asp?ACTION=DELIVERY"><img src="images/delivery.jpg" width="124" height="35" alt="Switch to Delivery" /></a>
<%
		End If
	End If
End If
%>
					</td>
					<td valign="top" align="right" width="210"></td>
				</tr>
			</table>
		</td>
		<td align="left" valign="top" background="images/template_03.jpg" width="46" height="133"></td>
	</tr>
	<tr>
		<td colspan="2" align="left" valign="top" background="images/template_04.jpg" width="258" height="23"></td>
		<td align="left" valign="top" background="images/template_05.jpg" width="53" height="23">
		<img src="images/template_05.jpg" width="53" height="23" alt="Home" /></td>
		<td align="left" valign="top" background="images/template_06.jpg" width="12" height="23"></td>
		<td align="left" valign="top" background="images/template_07.jpg" width="49" height="23">
		<img src="images/template_07.jpg" width="49" height="23" alt="Menu" /></td>
		<td align="left" valign="top" background="images/template_08.jpg" width="15" height="23"></td>
		<td align="left" valign="top" background="images/template_09.jpg" width="74" height="23">
		<img src="images/template_09.jpg" width="74" height="23" alt="Coupons" /></td>
		<td align="left" valign="top" background="images/template_10.jpg" width="13" height="23"></td>
		<td colspan="3" align="left" valign="top" background="images/template_11.jpg" width="87" height="23">
		<img src="images/template_11.jpg" width="87" height="23" alt="Locations" /></td>
		<td align="left" valign="top" background="images/template_12.jpg" width="13" height="23"></td>
		<td align="left" valign="top" background="images/template_13.jpg" width="89" height="23">
		<img src="images/template_13.jpg" width="89" height="23" alt="Franchise" /></td>
		<td align="left" valign="top" background="images/template_14.jpg" width="13" height="23"></td>
		<td align="left" valign="top" background="images/template_15.jpg" width="41" height="23">
		<img src="images/template_15.jpg" width="41" height="23" alt="Jobs" /></td>
		<td align="left" valign="top" background="images/template_16.jpg" width="14" height="23"></td>
		<td colspan="2" align="left" valign="top" background="images/template_17.jpg" width="73" height="23">
		<img src="images/template_17.jpg" width="73" height="23" alt="Contact" /></td>
		<td align="left" valign="top" background="images/template_18.jpg" width="46" height="23"></td>
	</tr>
	<tr>
		<td colspan="19" align="left" valign="top" background="images/template_19.jpg" width="850" height="78">
			<div align="right" style="margin-right:24px; margin-top:4px">
				<font color="#FFFF00" size="4">
					<marquee bgcolor="#FF0000" direction="left" loop="-1" width="575">
						<strong><%=GetMarqueeText()%></strong></marquee>
				</font>
			</div>
		</td>
	</tr>
	<tr>
		<td align="left" valign="top" background="images/template_20.jpg" width="65" height="80"></td>
		<td colspan="18" align="left" valign="top" background="images/template_21.jpg" width="785" height="80">
			<table cellpadding="0" cellspacing="0">
				<tr>
					<td valign="top" background="images/navigation-left.jpg" width="27" height="64"></td>
<%
If GetUnits(Session("STORE"), saUnitName, naUnitNum, saUnitDesc, saCustomDesc) Then
	If Len(saUnitName(0)) > 0 Then
		Set oFS = CreateObject("Scripting.FileSystemObject")
		
		For i = 0 To UBound(saUnitName)
			sFileName = "images/navigation-unit" & naUnitNum(i) & ".jpg"
			
			If oFS.FileExists(Server.MapPath(sFileName)) Then
%>
					<td valign="top" background="<%=sFileName%>" height="64">
					<a href="unit.asp?uid=<%=naUnitNum(i)%>"><img src="<%=sFileName%>" height="64" alt="<%=saUnitName(i)%>" /></a></td>
					<td valign="top" background="images/navigation-spacer.jpg" width="6" height="64"></td>
<%
			End If
		Next
		
		Set oFS = Nothing
	End If
End If
%>
					<td valign="top" background="images/navigation-sides.jpg" width="129" height="64">
					<a href="sides.asp"><img src="images/navigation-sides.jpg" width="129" height="64" alt="Sides" /></a></td>
					<td valign="top" background="images/navigation-spacer.jpg" width="6" height="64"></td>
					<td valign="top" background="images/navigation-deals.jpg" width="58" height="64">
					<a href="deals.asp"><img src="images/navigation-deals.jpg" width="58" height="64" alt="Deals" /></a></td>
					<td valign="top" background="images/navigation-right.jpg" width="40" height="64"></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td align="left" valign="top" background="images/template_22.jpg" width="65" height="86"></td>
		<td colspan="8" rowspan="3" align="left" valign="top" background="images/template_23.jpg" width="434" height="246">
<%
Dim sDescription, nQty, nOrderItems

nOrderID = Session("ORDERID")

If Request.Form("ACTION") = "ADD" Then
	If Request("PROMO").Count > 0 Then
		If IsNumeric(Request("PROMO")) And Request("PROMO") <> "0" Then
			If Len(Session("PROMOS")) = 0 Then
				Session("PROMOS") = Request("PROMO")
			Else
				bFoundPromo = FALSE
				naCurrentPromos = Split(Session("PROMOS"), ",")
				
				For i = 0 To UBound(naCurrentPromos)
					If CDbl(naCurrentPromos(i)) = CDbl(Request("PROMO")) Then
						bFoundPromo = TRUE
					End If
				Next
				
				If Not bFoundPromo Then
					Session("PROMOS") = Session("PROMOS") & "," & Request("PROMO")
				End If
			End If
		End If
	End If
	
	If Len(Trim(Request("PROMOCODE"))) > 0 Then
		If ValidatePromoCode(Session("DMA"), Session("STORE"), UCase(Trim(Request("PROMOCODE")))) Then
			If Len(Session("PROMOCODES")) = 0 Then
				Session("PROMOCODES") = UCase(Trim(Request("PROMOCODE")))
			Else
				bFoundPromo = FALSE
				saCurrentPromoCodes = Split(Session("PROMOCODES"), ",")
				
				For i = 0 To UBound(saCurrentPromoCodes)
					If UCase(saCurrentPromoCodes(i)) = UCase(Trim(Request("PROMOCODE"))) Then
						bFoundPromo = TRUE
					End If
				Next
				
				If Not bFoundPromo Then
					Session("PROMOCODES") = Session("PROMOCODES") & "," & UCase(Trim(Request("PROMOCODE")))
				End If
			End If
		Else
			sPromoCodeError = "<b><i>Sorry, the promo code you entered is not valid.</i></b>"
		End If
	End If
	
	If nOrderID = 0 Then
		If Session("MODE") = "DELIVERY" Then
			nOrderID = CreateOrder(Session("STORE"), Session("CUSTOMERID"), 1, Session("DELIVERY"), Session("DRMONEY"), Session("FIRSTNAME") & " " & Session("LASTNAME"), Session("PHONE"), Session("ADDRESSID"), Session("SPECINST"))
		Else
			nOrderID = CreateOrder(Session("STORE"), Session("CUSTOMERID"), 2, 0.00, 0.00, Session("FIRSTNAME") & " " & Session("LASTNAME"), Session("PHONE"), Session("ADDRESSID"), Session("SPECINST"))
		End If
		
		Session("ORDERID") = nOrderID
	End If
	
	If nOrderID > 0 Then
		sDescription = ""
		If Len(Request.Form("SIZENAME")) > 0 Then
			sDescription = Request.Form("SIZENAME")
		End If
		If Len(Request.Form("CRUSTNAME")) > 0 Then
			sDescription = sDescription & " " & Request.Form("CRUSTNAME")
		End If
		If Len(Request.Form("SPECIALTY")) > 0 Then
			sDescription = sDescription & " " & GetSpecialtyName(Session("STORE"), Request.Form("UNITNUM"), Request.Form("SPECIALTY"))
		End If
		If Len(Request.Form("UNITNAME")) > 0 Then
			sDescription = sDescription & " " & Request.Form("UNITNAME")
		End If
		If Len(Request.Form("SAUCENAMEWHOLE")) > 0 Then
			sDescription = sDescription & " w/ " & Request.Form("SAUCENAMEWHOLE")
			If Len(Request.Form("SAUCEMODIERNAMEWHOLE")) > 0 Then
				sDescription = sDescription & " (" & Request.Form("SAUCEMODIFIERNAMEWHOLE") & ")"
			End If
		Else
			If Len(Request.Form("SAUCENAMEHALF1")) > 0 Then
				If Request.Form("SAUCENAMEHALF1") = Request.Form("SAUCENAMEHALF2") Then
					sDescription = sDescription & " w/ " & Request.Form("SAUCENAMEHALF1")
					If Len(Request.Form("SAUCEMODIFIERNAMEHALF1")) > 0 Or Len(Request.Form("SAUCEMODIFIERNAMEHALF2")) > 0 Then
						If Request.Form("SAUCEMODIFIERNAMEHALF1") = Request.Form("SAUCEMODIFIERNAMEHALF2") Then
							sDescription = sDescription & " (" & Request.Form("SAUCEMODIFIERNAMEHALF1") & ")"
						Else
							sDescription = sDescription & " ("
							If Len(Request.Form("SAUCEMODIFIERNAMEHALF1")) > 0 Then
								sDescription = sDescription & Request.Form("SAUCEMODIFIERNAMEHALF1") & " on first half"
								If Len(Request.Form("SAUCEMODIFIERNAMEHALF2")) > 0 Then
									sDescription = sDescription & " and "
								End If
							End If
							If Len(Request.Form("SAUCEMODIFIERNAMEHALF2")) > 0 Then
								sDescription = sDescription & Request.Form("SAUCEMODIFIERNAMEHALF2") & " on second half"
							End If
							sDescription = sDescription & ")"
						End If
					End If
				Else
					sDescription = sDescription & " w/ " & Request.Form("SAUCENAMEHALF1")
					If Len(Request.Form("SAUCEMODIFIERNAMEHALF1")) > 0 Then
						sDescription = sDescription & " (" & Request.Form("SAUCEMODIFIERNAMEHALF1") & ")"
					End If
					sDescription = sDescription & " on one half and " & Request.Form("SAUCENAMEHALF2")
					If Len(Request.Form("SAUCEMODIFIERNAMEHALF2")) > 0 Then
						sDescription = sDescription & " (" & Request.Form("SAUCEMODIFIERNAMEHALF2") & ")"
					End If
					sDescription = sDescription & " on other half"
				End If
			End If
		End If
		sDescription = sDescription & "<br/>"
		If Len(Request.Form("TOPWHOLENAME")) > 0 Then
			sDescription = sDescription & "Whole Toppings: " & Request.Form("TOPWHOLENAME")
			sDescription = sDescription & "<br/>"
		End If
		If Len(Request.Form("TOPHALF1NAME")) > 0 Then
			sDescription = sDescription & "1st Half Toppings: " & Request.Form("TOPHALF1NAME")
			sDescription = sDescription & "<br/>"
		End If
		If Len(Request.Form("TOPHALF2NAME")) > 0 Then
			sDescription = sDescription & "2nd Half Toppings: " & Request.Form("TOPHALF2NAME")
			sDescription = sDescription & "<br/>"
		End If
		If Len(Request.Form("CRUSTTOPNAME")) > 0 Then
			sDescription = sDescription & "Crust Toppers: " & Request.Form("CRUSTTOPNAME")
			sDescription = sDescription & "<br/>"
		End If
		If Len(Request.Form("INCLUDEDSIDENAME")) > 0 Then
			sDescription = sDescription & "Included Sides: " & Request.Form("INCLUDEDSIDENAME")
			sDescription = sDescription & "<br/>"
		End If
		If Len(Request.Form("ADDSIDENAME")) > 0 Then
			sDescription = sDescription & "Added Sides: " & Request.Form("ADDSIDENAME")
			sDescription = sDescription & "<br/>"
		End If
		If Len(Request.Form("QTY")) = 0 Then
			nQty = 1
		Else
			If Not IsNumeric(Request.Form("QTY")) Then
				nQty = 1
			Else
				nQty = CInt(Request.Form("QTY"))
			End If
		End If
		If Len(Request.Form("NOTES")) > 0 Then
			sDescription = sDescription & "Notes: " & Request.Form("NOTES")
			sDescription = sDescription & "<br/>"
		End If
		
		If AddToOrder(nOrderID, nQty, sDescription, Request.Form("UNITNUM"), Request.Form("SPECIALTY"), Request.Form("SIZE"), Request.Form("CRUST"), Request.Form("SAUCEWHOLE"), Request.Form("SAUCEHALF1"), Request.Form("SAUCEHALF2"), Request.Form("SAUCEMODIFIERWHOLE"), Request.Form("SAUCEMODIFIERHALF1"), Request.Form("SAUCEMODIFIERHALF2"), Request.Form("TOPWHOLE"), Request.Form("TOPHALF1"), Request.Form("TOPHALF2"), Request.Form("CRUSTTOP"), Request.Form("INCLUDEDSIDE"), Request.Form("ADDSIDE"), Request.Form("NOTES")) Then
			nOrderItems = Session("NUMITEMS") + nQty
			Session("NUMITEMS") = nOrderItems
			
			If Not GetPricing(Session("STORE"), nOrderID, Session("PROMOCODES"), Session("PROMOS")) Then
%>
			<strong>We apologize but our online ordering is temporarily unavailable (1). Please call our store at <%=Left(sPhone, 3) & "-" & Mid(sPhone, 4, 3) & "-" & Mid(sPhone, 7)%> to 
			complete your order.</strong>
<%
			End If
		Else
%>
			<strong>We apologize but our online ordering is temporarily unavailable (2). Please call our store at <%=Left(sPhone, 3) & "-" & Mid(sPhone, 4, 3) & "-" & Mid(sPhone, 7)%> to 
			complete your order.</strong>
<%
		End If
	Else
%>
			<strong>We apologize but our online ordering is temporarily unavailable (3). Please call our store at <%=Left(sPhone, 3) & "-" & Mid(sPhone, 4, 3) & "-" & Mid(sPhone, 7)%> to 
			complete your order.</strong>
<%
	End If
End If

If Request.Form("ACTION") = "REMOVE" And nOrderID > 0 Then
	If RemoveOrderItem(nOrderID, Request.Form("ORDERITEMID")) Then
		nOrderItems = Session("NUMITEMS") - 1
		If nOrderItems < 0 Then
			nOrderItems = 0
		End If
		Session("NUMITEMS") = nOrderItems
		
		If nOrderItems > 0 Then
			If GetPricing(Session("STORE"), nOrderID, Session("PROMOCODES"), Session("PROMOS")) Then
				dSubtotal = 0.00
				dTotal = 0.00
				
				nOrderID = Session("ORDERID")
				
				If GetOrder(nOrderID, dDelivery, dDrMoney, dTax, dTip) Then
					If GetOrderItems(nOrderID, anOrderItemID, anQty, asDescription, adPrice) Then
						For i = 0 To UBound(asDescription)
							dSubtotal = dSubtotal + adPrice(i)
						Next
						Session("GTOTAL") = dSubtotal
						Session("DELIVERY") = dDelivery
						Session("DRMONEY") = dDrMoney
						Session("TAX") = dTax
						
						dTotal = dSubtotal + dDelivery + dTax
						
						' Check that promo codes are still valid
						If Len(Session("PROMOCODES")) > 0 Then
							saCurrentPromoCodes = Split(Session("PROMOCODES"), ",")
							Session("PROMOCODES") = ""
							For i = 0 To UBound(saCurrentPromoCodes)
								bFoundPromo = TRUE
								
								If IsPromoCodeWithMinimumPurchase(Session("DMA"), saCurrentPromoCodes(i)) Then
									If CInt(Session("NUMITEMS")) > 0 Then
										If Not ValidateMinimumPurchase(Session("ORDERID"), saCurrentPromoCodes(i), dSubtotal) Then
											bFoundPromo = FALSE
										End If
									Else
										bFoundPromo = FALSE
									End If
								End If
								
								If bFoundPromo Then
									If Len(Session("PROMOCODES")) = 0 Then
										Session("PROMOCODES") = UCase(saCurrentPromoCodes(i))
									Else
										Session("PROMOCODES") = Session("PROMOCODES") & "," & UCase(saCurrentPromoCodes(i))
									End If
								End If
							Next
							
							If CInt(Session("NUMITEMS")) > 0 Then
								GetPricing Session("STORE"), Session("ORDERID"), Session("PROMOCODES"), Session("PROMOS")
							End If
						End If
					End If
				End If
			Else
%>
			<strong>We apologize but our online ordering is temporarily unavailable (5). Please call our store at <%=Left(sPhone, 3) & "-" & Mid(sPhone, 4, 3) & "-" & Mid(sPhone, 7)%> to 
			complete your order.</strong>
<%
			End If
		End If
	Else
%>
			<strong>We apologize but an error occured removing the item from your order (6). Please call our store at <%=Left(sPhone, 3) & "-" & Mid(sPhone, 4, 3) & "-" & Mid(sPhone, 7)%> to 
			complete your order.</strong>
<%
	End If
End If
%>
			<table width="434" cellpadding="0" cellspacing="0" border="0">
				<tr>
					<td valign="top" width="15"></td>
					<td valign="top" width="419" colspan="3">
						<img src="images/vitos-deals.jpg" width="258" height="27" alt="Vito's Deals" />
					</td>
				</tr>
				<tr>
					<td valign="top" width="15"></td>
					<td valign="top" width="419" colspan="3">&nbsp;</td>
				</tr>
				<tr>
					<td valign="top" width="15"></td>
					<td valign="top" width="265">
<%
Dim naPromoIDs(), saPromoNames(), naUnitSize(), nCurUnit, nCurSize, nColumn, saUnitSize(), bSidesShown

If GetCurrentPromos(Session("DMA"), Session("STORE"), naPromoIDs, saPromoNames, naUnitNum, naUnitSize, saUnitSize, saUnitName) Then
	If Len(saPromoNames(0)) > 0 Then
%>
						<table width="265" cellpadding="5" cellspacing="0" border="0">
<%
		Set oFS = CreateObject("Scripting.FileSystemObject")
		
		nCurUnit = 0
		nCurSize = 0
		nColumn = 1
		
		For i = 0 To UBound(saPromoNames)
			If CLng(naUnitNum(i)) = 1 Then
				If nCurUnit <> CLng(naUnitNum(i)) Then
					nCurUnit = CLng(naUnitNum(i))
					nCurSize = naUnitSize(i)
					
					If nColumn = 2 Then
%>
								<td valign="top" width="130"></td>
							</tr>
<%
						nColumn = 1
					End If
					
					sFileName = "images/deal-titles/" & naUnitNum(i) & "-" & naUnitSize(i) & ".jpg"
					If oFS.FileExists(Server.MapPath(sFileName)) Then
%>
							<tr>
								<td valign="top" colspan="2" align="center"><img src="<%=sFileName%>" width="258" height="29" alt="<%=saUnitSize(i)%> <%=saUnitName(i)%> Deals" /></td>
							</tr>
<%
					Else
%>
							<tr>
								<td valign="top" colspan="2" align="center"><%=saUnitSize(i)%>&nbsp;<%=saUnitName(i)%> Deals</td>
							</tr>
<%
					End If
				End If
				
				If nCurSize <> naUnitSize(i) Then
					nCurSize = naUnitSize(i)
					
					If nColumn = 2 Then
%>
								<td valign="top" width="130"></td>
							</tr>
<%
						nColumn = 1
					End If
					
					sFileName = "images/deal-titles/" & naUnitNum(i) & "-" & naUnitSize(i) & ".jpg"
					If oFS.FileExists(Server.MapPath(sFileName)) Then
%>
							<tr>
								<td valign="top" colspan="2" align="center"><img src="<%=sFileName%>" width="258" height="29" alt="<%=saUnitSize(i)%> <%=saUnitName(i)%> Deals" /></td>
							</tr>
<%
					Else
%>
							<tr>
								<td valign="top" colspan="2" align="center"><%=saUnitSize(i)%>&nbsp;<%=saUnitName(i)%> Deals</td>
							</tr>
<%
					End If
				End If
				
				If nColumn = 1 Then
%>
							<tr>
<%
				End If
				
				sFileName = "images/deal-images/" & naPromoIDs(i) & "-" & naUnitNum(i) & "-" & naUnitSize(i) & ".jpg"
				If oFS.FileExists(Server.MapPath(sFileName)) Then
%>
								<td valign="top" width="130">
								<a href="customize.asp?pid=<%=naPromoIDs(i)%>&uid=<%=naUnitNum(i)%>&sid=<%=naUnitSize(i)%>"><img src="<%=sFileName%>" width="130" height="97" alt="<%=saPromoNames(i)%>" /></a></td>
<%
				Else
%>
								<td valign="top" width="130">
								<a href="customize.asp?pid=<%=naPromoIDs(i)%>&uid=<%=naUnitNum(i)%>&sid=<%=naUnitSize(i)%>"><%=saPromoNames(i)%></a></td>
<%
				End If
				
				If nColumn = 2 Then
					nColumn = 1
%>
							</tr>
<%
				Else
					nColumn = nColumn + 1
				End If
			End If
		Next
		
		If nColumn = 2 Then
%>
								<td valign="top" width="130"></td>
							</tr>
<%
		End If
		
		Set oFS = Nothing
%>
						</table>
<%
	End If
End If
%>
					</td>
					<td valign="top" width="15"></td>
					<td valign="top" width="139">
<%
If GetCurrentPromos(Session("DMA"), Session("STORE"), naPromoIDs, saPromoNames, naUnitNum, naUnitSize, saUnitSize, saUnitName) Then
	If Len(saPromoNames(0)) > 0 Then
%>
						<table width="139" cellpadding="5" cellspacing="0" border="0">
<%
		Set oFS = CreateObject("Scripting.FileSystemObject")
		
		nCurUnit = 0
		nCurSize = 0
		bSidesShown = FALSE
		
		For i = 0 To UBound(saPromoNames)
			If CLng(naUnitNum(i)) <> 1 Then
				If CLng(nCurUnit) <> CLng(naUnitNum(i)) Then
					nCurUnit = CLng(naUnitNum(i))
					nCurSize = naUnitSize(i)
					
					sFileName = "images/deal-titles/" & naUnitNum(i) & "-" & naUnitSize(i) & ".jpg"
					If oFS.FileExists(Server.MapPath(sFileName)) Then
%>
							<tr>
								<td valign="top" align="center"><img src="<%=sFileName%>" width="129" height="29" alt="<%=saUnitSize(i)%> <%=saUnitName(i)%> Deals" /></td>
							</tr>
<%
					Else
						If Not bSidesShown Then
							bSidesShown = TRUE
%>
							<tr>
								<td valign="top" align="center"><img src="images/deal-titles/sides.jpg" width="129" height="29" alt="Sides Deals" /></td>
							</tr>
<%
						End If
					End If
				End If
				
				If nCurSize <> naUnitSize(i) Then
					nCurSize = naUnitSize(i)
					
					sFileName = "images/deal-titles/" & naUnitNum(i) & "-" & naUnitSize(i) & ".jpg"
					If oFS.FileExists(Server.MapPath(sFileName)) Then
%>
							<tr>
								<td valign="top" align="center"><img src="<%=sFileName%>" width="129" height="28" alt="<%=saUnitSize(i)%> <%=saUnitName(i)%> Deals" /></td>
							</tr>
<%
					Else
						If Not bSidesShown Then
							bSidesShown = TRUE
%>
							<tr>
								<td valign="top" align="center"><img src="images/deal-titles/sides.jpg" width="129" height="29" alt="Sides Deals" /></td>
							</tr>
<%
						End If
					End If
				End If
				
				sFileName = "images/deal-images/" & naPromoIDs(i) & "-" & naUnitNum(i) & "-" & naUnitSize(i) & ".jpg"
				If oFS.FileExists(Server.MapPath(sFileName)) Then
%>
							<tr>
								<td valign="top" width="130">
								<a href="customize.asp?pid=<%=naPromoIDs(i)%>&uid=<%=naUnitNum(i)%>&sid=<%=naUnitSize(i)%>"><img src="<%=sFileName%>" width="130" height="97" alt="<%=saPromoNames(i)%>" /></a></td>
							</tr>
<%
				Else
%>
							<tr>
								<td valign="top" width="130">
								<a href="customize.asp?pid=<%=naPromoIDs(i)%>&uid=<%=naUnitNum(i)%>&sid=<%=naUnitSize(i)%>"><%=saPromoNames(i)%></a></td>
							</tr>
<%
				End If
			End If
		Next
		
		Set oFS = Nothing
%>
						</table>
<%
	End If
End If
%>
					</td>
				</tr>
			</table>
		</td>
		<td align="left" valign="top" background="images/template_31.jpg" width="351" height="246" colspan="10" rowspan="3">
			<table width="351" cellpadding="0" cellspacing="0" border="0">
				<tr>
					<td align="left" valign="top" background="images/template_24.jpg" width="26" height="86"></td>
					<td align="left" valign="top" background="images/template_25.jpg" width="268" height="86">
						<table width="268" cellpadding="0" cellspacing="0" border="0">
							<tr>
								<td colspan="3" valign="top" align="center"><img src="images/yourorder.jpg" width="154" height="36" /></td>
							</tr>
							<tr>
								<td colspan="3" valign="top">&nbsp;</td>
							</tr>
							<tr>
								<td colspan="3" valign="top">
<%
dSubtotal = 0.00
dTotal = 0.00

nOrderID = Session("ORDERID")

If Session("NUMITEMS") = 0 Then
%>
									<strong>Your cart is currently empty.</strong><br />
<%
			If Len(Session("PROMOS")) > 0 Or Len(Session("PROMOCODES")) > 0 Then
				naPromos = Split(Session("PROMOS"), ",")
				naPromoCodes = Split(Session("PROMOCODES"), ",")
%>
									&nbsp;<br/>
									<table width="268" cellpadding="0" cellspacing="2">
										<tr>
											<td valign="top" colspan="3">Selected Deals:</td>
										</tr>
<%
					If Len(Session("PROMOS")) > 0 Then
						For i = 0 To UBound(naPromos)
%>
										<tr>
											<td valign="top" width="21"><a href="deals.asp?xpromo=<%=naPromos(i)%>"><img src="images/remove.jpg" width="21" height="21" border="0" alt="Remove" /></a></td>
											<td valign="top" colspan="2"><%=GetPromoName(Session("DMA"), naPromos(i))%></td>
										</tr>
<%
						Next
					End If
					If Len(Session("PROMOCODES")) > 0 Then
						For i = 0 To UBound(naPromoCodes)
							If naPromoCodes(i) = "FREESB" Then
%>
										<tr>
											<td valign="top" width="21"><a href="deals.asp?xcode=<%=naPromoCodes(i)%>"><img src="images/remove.jpg" width="21" height="21" border="0" alt="Remove" /></a></td>
											<td valign="top" colspan="2">Free Small Salad and Small Cheezy Breadsticks With Any Pizza</td>
										</tr>
<%
							Else
								If naPromoCodes(i) = "LETTER" Then
%>
										<tr>
											<td valign="top" width="21"><a href="deals.asp?xcode=<%=naPromoCodes(i)%>"><img src="images/remove.jpg" width="21" height="21" border="0" alt="Remove" /></a></td>
											<td valign="top" colspan="2">Free Small Salad and Small Cheezy Breadsticks With Any Pizza Or Sub</td>
										</tr>
<%
								Else
									If naPromoCodes(i) = "FREESB2" Then
%>
										<tr>
											<td valign="top" width="21"><a href="deals.asp?xcode=<%=naPromoCodes(i)%>"><img src="images/remove.jpg" width="21" height="21" border="0" alt="Remove" /></a></td>
											<td valign="top" colspan="2">Free Small Salad, Small Cheezy Breadsticks and 2 Liter With Any Pizza</td>
										</tr>
<%
									Else
%>
										<tr>
											<td valign="top" width="21"><a href="deals.asp?xcode=<%=naPromoCodes(i)%>"><img src="images/remove.jpg" width="21" height="21" border="0" alt="Remove" /></a></td>
											<td valign="top" colspan="2"><%=GetPromoCodeName(Session("DMA"), naPromoCodes(i))%></td>
										</tr>
<%
									End If
								End If
							End If
						Next
					End If
%>
									</table>
<%
			End If
Else
	If GetOrder(nOrderID, dDelivery, dDrMoney, dTax, dTip) Then
		If GetOrderItems(nOrderID, anOrderItemID, anQty, asDescription, adPrice) Then
%>
									<table width="268" cellpadding="0" cellspacing="2">
<%
			For i = 0 To UBound(asDescription)
				dSubtotal = dSubtotal + adPrice(i)
%>
										<tr>
											<td valign="top" width="21">
												<form method="post" action="deals.asp">
													<input type="hidden" name="ACTION" value="REMOVE" />
													<input type="hidden" name="ORDERITEMID" value="<%=anOrderItemID(i)%>" />
													<input type="image" src="images/remove.jpg" alt="Remove" />
												</form>
											</td>
											<td valign="top"><%=asDescription(i)%></td>
											<td valign="top" align="right"><%=FormatCurrency(adPrice(i))%></td>
										</tr>
										<tr>
											<td valign="top" width="21">&nbsp;</td>
											<td valign="top">&nbsp;</td>
											<td valign="top" align="right">&nbsp;</td>
										</tr>
<%
			Next
			
			If Len(Session("PROMOS")) > 0 Or Len(Session("PROMOCODES")) > 0 Then
				naPromos = Split(Session("PROMOS"), ",")
				naPromoCodes = Split(Session("PROMOCODES"), ",")
%>
										<tr>
											<td valign="top" colspan="3">Selected Deals:</td>
										</tr>
<%
					If Len(Session("PROMOS")) > 0 Then
						For i = 0 To UBound(naPromos)
%>
										<tr>
											<td valign="top" width="21"><a href="deals.asp?xpromo=<%=naPromos(i)%>"><img src="images/remove.jpg" width="21" height="21" border="0" alt="Remove" /></a></td>
											<td valign="top" colspan="2"><%=GetPromoName(Session("DMA"), naPromos(i))%></td>
										</tr>
<%
						Next
					End If
					If Len(Session("PROMOCODES")) > 0 Then
						For i = 0 To UBound(naPromoCodes)
							If naPromoCodes(i) = "FREESB" Then
%>
										<tr>
											<td valign="top" width="21"><a href="deals.asp?xcode=<%=naPromoCodes(i)%>"><img src="images/remove.jpg" width="21" height="21" border="0" alt="Remove" /></a></td>
											<td valign="top" colspan="2">Free Small Salad and Small Cheezy Breadsticks With Any Pizza</td>
										</tr>
<%
							Else
								If naPromoCodes(i) = "LETTER" Then
%>
										<tr>
											<td valign="top" width="21"><a href="deals.asp?xcode=<%=naPromoCodes(i)%>"><img src="images/remove.jpg" width="21" height="21" border="0" alt="Remove" /></a></td>
											<td valign="top" colspan="2">Free Small Salad and Small Cheezy Breadsticks With Any Pizza Or Sub</td>
										</tr>
<%
								Else
									If naPromoCodes(i) = "FREESB2" Then
%>
										<tr>
											<td valign="top" width="21"><a href="deals.asp?xcode=<%=naPromoCodes(i)%>"><img src="images/remove.jpg" width="21" height="21" border="0" alt="Remove" /></a></td>
											<td valign="top" colspan="2">Free Small Salad, Small Cheezy Breadsticks and 2 Liter With Any Pizza</td>
										</tr>
<%
									Else
%>
										<tr>
											<td valign="top" width="21"><a href="deals.asp?xcode=<%=naPromoCodes(i)%>"><img src="images/remove.jpg" width="21" height="21" border="0" alt="Remove" /></a></td>
											<td valign="top" colspan="2"><%=GetPromoCodeName(Session("DMA"), naPromoCodes(i))%></td>
										</tr>
<%
									End If
								End If
							End If
						Next
					End If
			End If
			
			Session("GTOTAL") = dSubtotal
			Session("DELIVERY") = dDelivery
			Session("DRMONEY") = dDrMoney
			Session("TAX") = dTax
			
			dTotal = dSubtotal + dDelivery + dTax
%>
										<tr>
											<td valign="top" width="21">&nbsp;</td>
											<td valign="top">&nbsp;</td>
											<td valign="top" align="right">&nbsp;</td>
										</tr>
										<tr>
											<td valign="top" width="21">&nbsp;</td>
											<td valign="top" align="right">Subtotal:&nbsp;&nbsp;</td>
											<td valign="top" align="right"><%=FormatCurrency(dSubtotal)%></td>
										</tr>
										<tr>
											<td valign="top" width="21">&nbsp;</td>
											<td valign="top">&nbsp;</td>
											<td valign="top" align="right">&nbsp;</td>
										</tr>
										<tr>
											<td valign="top" width="21">&nbsp;</td>
											<td valign="top" align="right">Tax:&nbsp;&nbsp;</td>
											<td valign="top" align="right"><%=FormatCurrency(dTax)%></td>
										</tr>
<%
			If Session("MODE") = "DELIVERY" Then
%>
										<tr>
											<td valign="top" width="21">&nbsp;</td>
											<td valign="top">&nbsp;</td>
											<td valign="top" align="right">&nbsp;</td>
										</tr>
										<tr>
											<td valign="top" width="21">&nbsp;</td>
											<td valign="top" align="right">Delivery:&nbsp;&nbsp;</td>
											<td valign="top" align="right"><%=FormatCurrency(dDelivery)%></td>
										</tr>
<%
			End If
%>
									</table>
<%
		End If
	End If
End If
%>
								</td>
							</tr>
							<tr>
								<td colspan="3" valign="top">&nbsp;</td>
							</tr>
							<tr>
								<td colspan="3" valign="top" align="center"><img src="images/total.jpg" width="56" height="14" alt="Total" /></td>
							</tr>
							<tr>
								<td valign="top" width="50">&nbsp;</td>
								<td valign="top" align="center" width="168" style="border: 2px solid #000000; padding: 5px 0px 5px 0px;">
								<span class="total"><%=FormatCurrency(dTotal)%></span>
								</td>
								<td valign="top" width="50">&nbsp;</td>
							</tr>
<%
'If dTotal > 0 Then
If Session("NUMITEMS") > 0 Then
%>
							<tr>
								<td colspan="3" valign="top" align="center">
<%
	dDeliveryMin = GetDeliveryMinimum(Session("STORE"))
	If Session("MODE") = "DELIVERY" And GetOrderTotalNoDiscount(nOrderID) < dDeliveryMin Then
%>
									Your order has not reached our minimum delivery of <%=FormatCurrency(dDeliveryMin)%>. 
									Please add more to your order or switch to pickup.
<%
	Else
%>
									<a href="checkout.asp"><img src="images/checkout.jpg" width="156" height="39" alt="Checkout" /></a>
<%
	End If
%>
								</td>
							</tr>
<%
End If
%>
							<tr>
								<td colspan="3" valign="top">&nbsp;</td>
							</tr>
							<tr>
								<td colspan="3" valign="top" align="center">
									<form method="post" action="deals.asp">
										<input type="hidden" name="ACTION" value="PROMOCODE" />
										Promo Code: <input type="text" name="PROMOCODE" id="PROMOCODE" style="width: 100px" value="" /><input type="submit" value="Submit" />
									</form>
									<%=sPromoCodeError%>
								</td>
							</tr>
						</table>
					</td>
					<td align="left" valign="top" background="images/template_26.jpg" width="11" height="86"></td>
					<td align="left" valign="top" background="images/template_27.jpg" width="46" height="86"></td>
				</tr>
				<tr>
					<td colspan="4" align="left" valign="top" background="images/template_29.jpg" width="351" height="20"></td>
				</tr>
				<tr>
					<td colspan="4" align="left" valign="top" background="images/template_31.jpg" width="351" height="140"></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td align="left" valign="top" background="images/template_28.jpg" width="65" height="20"></td>
	</tr>
	<tr>
		<td align="left" valign="top" background="images/template_30.jpg" width="65" height="140"></td>
	</tr>
	<tr>
		<td colspan="19" align="left" valign="top" background="images/template_32.jpg" width="850" height="87" class="copyright">
		&nbsp;<br />
		&nbsp;<br />
		&nbsp;<br />
		
		&copy; 2009-2011 Vito&#39;s Pizza Inc. All Rights Reserved</td>
	</tr>
	<tr>
		<td background="images/spacer.gif" width="1" height="1"></td>
		<td background="images/spacer.gif" width="65" height="1"></td>
		<td background="images/spacer.gif" width="193" height="1"></td>
		<td background="images/spacer.gif" width="53" height="1"></td>
		<td background="images/spacer.gif" width="12" height="1"></td>
		<td background="images/spacer.gif" width="49" height="1"></td>
		<td background="images/spacer.gif" width="15" height="1"></td>
		<td background="images/spacer.gif" width="74" height="1"></td>
		<td background="images/spacer.gif" width="13" height="1"></td>
		<td background="images/spacer.gif" width="25" height="1"></td>
		<td background="images/spacer.gif" width="26" height="1"></td>
		<td background="images/spacer.gif" width="36" height="1"></td>
		<td background="images/spacer.gif" width="13" height="1"></td>
		<td background="images/spacer.gif" width="89" height="1"></td>
		<td background="images/spacer.gif" width="13" height="1"></td>
		<td background="images/spacer.gif" width="41" height="1"></td>
		<td background="images/spacer.gif" width="14" height="1"></td>
		<td background="images/spacer.gif" width="62" height="1"></td>
		<td background="images/spacer.gif" width="11" height="1"></td>
		<td background="images/spacer.gif" width="46" height="1"></td>
	</tr>
</table>
</body>
</html>
<%
option explicit
Response.buffer = TRUE

If UCase(Request.ServerVariables("HTTPS")) <> "ON" Then
	Response.Redirect("https://www.vitos.com/orderdev/Default.asp")
End If
%>
<!-- #Include File="include/adovbs.asp" -->
<!-- #Include File="include/app-settings.asp" -->
<!-- #Include File="include/app-database.asp" -->
<!-- #Include File="include/app-ordering.asp" -->
<%
If Len(Session("ADDRESS")) = 0 Or Len(Session("ZIPCODE")) = 0 Or Len(Session("STORE")) = 0 Then
	Response.Redirect("Default.asp")
End If

If Not IsStoreEnabled(Session("STORE")) Then
	Response.Redirect("maintenance.asp")
End If
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Welcome to Vito&#39;s Pizza Online Ordering</title>
<link rel="stylesheet" href="css/ordering2.css" type="text/css" />
</head>

<%
Dim sName, sAddress1, sAddress2, sCity, sState, sPostalCode, sPhone, sFax, sHours, sDisplayAddress, nTempStore, nDelivery, nDrMoney
Dim saUnitName(), naUnitNum(), saUnitDesc(), saCustomDesc(), i, oFS, sFileName
Dim nOrderID, dDelivery, dDrMoney, dTax, dTip, anOrderItemID(), anQty(), asDescription(), adPrice(), dSubtotal, dTotal, dDeliveryMin, naPromos, naPromoCodes
Dim sPromoCodeError
%>

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
			<table width="434" cellpadding="0" cellspacing="0" border="0">
				<tr>
					<td valign="top" width="15"></td>
					<td valign="top" width="419"><img src="images/sides.jpg" width="115" height="27" /></td>
				</tr>
				<tr>
					<td valign="top" width="15"></td>
					<td valign="top" width="419">&nbsp;</td>
				</tr>
				<tr>
					<td valign="top" width="15"></td>
					<td valign="top" width="419">
<%
Dim nColumn

If Len(saUnitName(0)) > 0 Then
%>
						<table width="414" cellpadding="5" cellspacing="0" border="0">
<%
	Set oFS = CreateObject("Scripting.FileSystemObject")
	
	nColumn = 1
	
	For i = 0 To UBound(saUnitName)
		sFileName = "images/navigation-unit" & naUnitNum(i) & ".jpg"
		
		If Not oFS.FileExists(Server.MapPath(sFileName)) Then
			If nColumn = 1 Then
%>
							<tr>
<%
			End If
			
			sFileName = "images/side-thumbs/" & naUnitNum(i) & ".jpg"
			
			If naUnitNum(i) = 21 Then
				If oFS.FileExists(Server.MapPath(sFileName)) Then
%>
								<td valign="top" width="212">
								<a href="customize.asp?uid=<%=naUnitNum(i)%>&Spec=97"><img src="<%=sFileName%>" alt="<%=saUnitName(i)%>" /></a></td>
<%
				Else
%>
								<td valign="top" width="212">
								<a href="customize.asp?uid=<%=naUnitNum(i)%>&Spec=97"><%=saUnitName(i)%></a><br /><%=saUnitDesc(i)%><br />&nbsp;<br /></td>
<%
				End If
			Else
				If oFS.FileExists(Server.MapPath(sFileName)) Then
%>
								<td valign="top" width="212">
								<a href="customize.asp?uid=<%=naUnitNum(i)%>"><img src="<%=sFileName%>" alt="<%=saUnitName(i)%>" /></a></td>
<%
				Else
%>
								<td valign="top" width="212">
								<a href="customize.asp?uid=<%=naUnitNum(i)%>"><%=saUnitName(i)%></a><br /><%=saUnitDesc(i)%><br />&nbsp;<br /></td>
<%
				End If
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
								<td valign="top" width="212"></td>
							</tr>
<%
	End If
%>
						</table><br />
<%
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
If dTotal > 0 Then
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
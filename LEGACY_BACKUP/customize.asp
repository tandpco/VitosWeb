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
<!-- #Include File="include/fsovbs.asp" -->
<!-- #Include File="include/imgsz.asp" -->
<%
Dim sName, sAddress1, sAddress2, sCity, sState, sPostalCode, sPhone, sFax, sHours, sDisplayAddress, nTempStore, nDelivery, nDrMoney
Dim saUnitName(), naUnitNum(), saUnitDesc(), saCustomDesc(), i, j, oFS, sFileName
Dim nOrderID, dDelivery, dDrMoney, dTax, dTip, anOrderItemID(), anQty(), asDescription(), adPrice(), dSubtotal, dTotal, dDeliveryMin, naPromos, naPromoCodes
Dim nStore
Dim sAddress, sApt
Dim nAddressID

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

If Request("ACTION") = "PICKUP" Then
	nStore = Request.Form("STORE")
	
	If GetStoreInfo(nStore, sName, sAddress1, sAddress2, sCity, sState, sPostalCode, sPhone, sFax, sHours) Then
		Session("STORE") = nStore
		
		UpdateActivityStore Session("ACTIVITYID"), nStore, 2
		
		If Session("ORDERID") > 0 Then
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
		Else
			Session("MODE") = "PICKUP"
			Session("DELIVERY") = CDbl(0.00)
			Session("DRMONEY") = CDbl(0.00)
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

If Request("uid").Count = 0 And Request("pid").Count = 0 And Request("pcode").Count = 0 Then
	Response.Redirect("deals.asp")
End If

If Request("uid").Count <> 0 And Not IsNumeric(Request("uid")) Then
	Response.Redirect("deals.asp")
End If

If Request("pid").Count <> 0 Then
	If Not IsNumeric(Request("pid")) Then
		Response.Redirect("deals.asp")
	Else
		If Request("uid").Count = 0 Or Request("sid").Count = 0 Or (Request("sid").Count <> 0 And Not IsNumeric(Request("sid"))) Then
			Response.Redirect("deals.asp")
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
			<table width="434" cellpadding="0" cellspacing="0" border="0">
				<tr>
					<td valign="top" width="15"></td>
					<td valign="top" width="419" class="customize">
<%
Dim sItemList, sItemListName, sItemNumList, bAllowHalf, nInclSideCount, sInclSideList, bIgnoreSpecialtySides, nSpecCrust, nSpecSauce, sDescription
Dim saItemName(), naItemNum(), saUnitSize(), naUnitSizeNum(), saCrust(), naCrustNum(), saTopper(), naTopperNum(), saSauce(), naSauceNum()
Dim saSauceModifier(), naSauceModifierNum(), saSide(), saSideID(), saDefaultSide(), saDefaultSideID(), naDefaultSideCount()
Dim saSpecialtySide(), saSpecialtySideID(), naSpecialtySideCount(), saNotes()
Dim saSpecItemName(), naSpecItemNum(), saSpecSide(), naSpecSideNum(), saInclSide(), naInclSideNum()
Dim sSpecDesc, sSpecImage, nWidth, nHeight, nDepth, sType
Dim nUID, sSpecialty, sUnitName, nSize, nPromo, sPromoCode, anSize()
Dim saSpecial(), saSpecialDesc(), saSpecialID()
Dim sPromoName
Dim naCrustPrice()
Dim sPromoSpecialty
Dim saSideGroup(), naSideGroupID(), saSideGroupSide(), naSideGroupSideID(), baSideGroupSideIsDefault()

sItemList = ""
sItemListName = ""
sItemNumList = ""
bAllowHalf = FALSE
nInclSideCount = 0
sInclSideList = ""
bIgnoreSpecialtySides = FALSE
nPromo = 0
sPromoCode = ""
sPromoSpecialty = ""

If Request("pid").Count > 0 Then
	nPromo = CLng(Request("pid"))
	nUID = CLng(Request("uid"))
	nSize = CLng(Request("sid"))
Else
	If Request("pcode").Count > 0 Then
		If GetPromoCodeUnitSizeSpecialty(Session("DMA"), Session("STORE"), Request("pcode"), nUID, anSize, sPromoSpecialty) Then
			sPromoCode = Request("pcode")
			nSize = anSize(0)
		Else
			ReDim anSize(0)
			
			nUID = 1
			anSize(0) = 1
			nSize = 1
		End If
	Else
		If Request("uid").Count > 0 Then
			nUID = CInt(Request("uid"))
			nSize = 1
		Else
			nUID = 1
			nSize = 1
		End If
	End If
End If

If Request("spec").Count > 0 Then
	sSpecialty = CLng(Request("spec"))
Else
	sSpecialty = 0
End If

sUnitName = GetUnitName(Session("STORE"), nUID)

If GetItems(Session("STORE"), nUID, saItemName, naItemNum, bAllowHalf) Then
	If GetUnitSizes(Session("STORE"), nUID, saUnitSize, naUnitSizeNum) Then
		If GetCrusts(Session("STORE"), nUID, 1, saCrust, naCrustNum, naCrustPrice) Then
			If GetToppers(Session("STORE"), nUID, saTopper, naTopperNum) Then
				If GetSauces(Session("STORE"), nUID, saSauce, naSauceNum) Then
					If GetSauceModifiers(Session("STORE"), nUID, saSauceModifier, naSauceModifierNum) Then
						If GetSides(Session("STORE"), nUID, saSide, saSideID) Then
							If GetDefaultSides(Session("STORE"), nUID, nSize, saDefaultSideID, naDefaultSideCount) Then
								If GetSpecialtySides(Session("STORE"), nUID, nSize, sSpecialty, saSpecialtySideID, naSpecialtySideCount) Then
									If GetSideGroups(Session("STORE"), nUID, saSideGroup, naSideGroupID, saSideGroupSide, naSideGroupSideID, baSideGroupSideIsDefault) Then
											If sSpecialty > 0 Then
												If GetDefaultItems(Session("STORE"), nUID, sSpecialty, saSpecItemName, naSpecItemNum) Then
													If Len(saSpecItemName(0)) > 0 Then
														For i = 0 To UBound(saSpecItemName)
															If i = 0 Then
																sItemList = "<a href=""javascript:RemoveWholeTopping(" & i & ")"">" & saSpecItemName(i) & "</a>"
																sItemListName = saSpecItemName(i)
																sItemNumList = naSpecItemNum(i)
															Else
																sItemList = sItemList & ", <a href=""javascript:RemoveWholeTopping(" & i & ")"">" & saSpecItemName(i) & "</a>"
																sItemListName = sItemListName & ", " & saSpecItemName(i)
																sItemNumList = sItemNumList & "," & naSpecItemNum(i)
															End If
														Next
													End If
												End If
											End If
											
											If sSpecialty > 0 Then
												nSpecCrust = GetDefaultCrust(Session("STORE"), nUID, sSpecialty)
												nSpecSauce = GetDefaultSauce(Session("STORE"), nUID, sSpecialty)
											Else
												nSpecCrust = 0
												nSpecSauce = naSauceNum(0)
											End If
											
											sDescription = GetFullDescription(Session("STORE"), nUID, sSpecialty)
											
%>
						<form method="post" action="customize2.asp" name="customize" id="customize">
							<input type="hidden" name="uid" id="uid" value="<%=nUID%>">
							<input type="hidden" name="pid" id="pid" value="<%=nPromo%>">
							<input type="hidden" name="pcode" id="pcode" value="<%=sPromoCode%>">
<%
											If nPromo <> "0" Then
												sPromoName = GetPromoName(Session("DMA"), nPromo)
												Set oFS = CreateObject("Scripting.FileSystemObject")
												
												sFileName = "images/deal-images/" & nPromo & "-" & nUID & "-" & nSize & ".jpg"
												If oFS.FileExists(Server.MapPath(sFileName)) Then
%>
							<img src="<%=sFileName%>" width="130" height="97" alt="<%=sPromoName%>" /><br />
<%
												Else
%>
							<%=sPromoName%><br />&nbsp;<br />
<%
												End If
												
												Set oFS = Nothing
											Else
												If Len(sPromoCode) > 0 Then
													sPromoName = GetPromoCodeName(Session("DMA"), sPromoCode)
													Set oFS = CreateObject("Scripting.FileSystemObject")
													
													sFileName = "deals/" & sPromoCode & ".jpg"
													If oFS.FileExists(Server.MapPath(sFileName)) Then
%>
							<img src="<%=sFileName%>" width="130" height="97" alt="<%=sPromoName%>" /><br />
<%
													Else
%>
							<%=sPromoName%><br />&nbsp;<br />
<%
													End If
													
													Set oFS = Nothing
												Else
													If sSpecialty > 0 Then
														If GetSpecialtyInfo(Session("STORE"), nUID, sSpecialty, sSpecDesc) Then
															Set oFS = CreateObject("Scripting.FileSystemObject")
															
															sFileName = "images/special-images/" & nUID & "-" & sSpecialty & ".jpg"
															If oFS.FileExists(Server.MapPath(sFileName)) Then
'																If gfxSpex(Server.MapPath(sFileName), nWidth, nHeight, nDepth, sType) Then
																	' TODO NOTE: FOR WHATEVER REASON RETRIEVING THE SIZE PERIODICALLY FAILS SO I'VE REMOVED IT FOR NOW
%>
							<img src="<%=sFileName%>" alt="<%=sSpecDesc%>">
							<%=sSpecDesc%><br />&nbsp;<br />
<%
'																End If
															Else
%>
							<strong><%=GetSpecialtyName(Session("STORE"), nUID, sSpecialty)%>&nbsp;<%=sUnitName%></strong> - <%=sSpecDesc%><br />&nbsp;<br />
<%
															End If
														Else
%>
							<strong><%=GetSpecialtyName(Session("STORE"), nUID, sSpecialty)%>&nbsp;<%=sUnitName%></strong> - <%=sDescription%><br />&nbsp;<br />
<%
														End If
													Else
														Set oFS = CreateObject("Scripting.FileSystemObject")
														
														sFileName = "images/special-images/" & nUID & ".jpg"
														If oFS.FileExists(Server.MapPath(sFileName)) Then
'															If gfxSpex(Server.MapPath(sFileName), nWidth, nHeight, nDepth, sType) Then
																' TODO NOTE: FOR WHATEVER REASON RETRIEVING THE SIZE PERIODICALLY FAILS SO I'VE REMOVED IT FOR NOW
%>
							<img src="<%=sFileName%>" alt="<%=sDescription%>">
							<%=sDescription%><br />&nbsp;<br />
<%
'															End If
														Else
%>
							<strong><%=sUnitName%></strong> - <%=sDescription%><br />&nbsp;<br />
<%
														End If
													End If
												End If
											End If
											
%>
							<img src="images/custom-size.jpg" width="78" height="34">
<%
											If nPromo = "0" And Len(sPromoCode) = 0 Then
%>
							<select name="SIZE" id="SIZE" onmousewheel="return(false);" onkeydown="return(false);">
<%
												For i = 0 To UBound(saUnitSize)
													If i = (nSize - 1) Then
%>
								<option value="<%=naUnitSizeNum(i)%>" selected><%=saUnitSize(i)%></option>
<%
													Else
%>
								<option value="<%=naUnitSizeNum(i)%>"><%=saUnitSize(i)%></option>
<%
													End If
												Next
%>
							</select><br />&nbsp;<br />
<%
											Else
												If Len(sPromoCode) > 0 Then
													If UBound(anSize) = 0 Then
%>
							<input type="hidden" name="SIZE" id="SIZE" value="<%=nSize%>">
<%
														For i = 0 To UBound(naUnitSizeNum)
															If naUnitSizeNum(i) = nSize Then
%>
							<%=saUnitSize(i)%><br />&nbsp;<br />
<%
																Exit For
															End If
														Next
													Else
%>
							<select name="SIZE" id="SIZE" onmousewheel="return(false);" onkeydown="return(false);">
<%
														For j = 0 To UBound(anSize)
															For i = 0 To UBound(naUnitSizeNum)
																If naUnitSizeNum(i) = anSize(j) Then
																	If j = 0 Then
%>
								<option value="<%=naUnitSizeNum(i)%>" selected><%=saUnitSize(i)%></option>
<%
																	Else
%>
								<option value="<%=naUnitSizeNum(i)%>"><%=saUnitSize(i)%></option>
<%
																	End If
																End If
															Next
														Next
%>
							</select><br />&nbsp;<br />
<%
													End If
												Else
%>
							<input type="hidden" name="SIZE" id="SIZE" value="<%=nSize%>">
<%
													For i = 0 To UBound(naUnitSizeNum)
														If naUnitSizeNum(i) = nSize Then
%>
							<%=saUnitSize(i)%><br />&nbsp;<br />
<%
															Exit For
														End If
													Next
												End If
											End If
											
											If nPromo <> "0" Or Len(sPromoCode) > 0 Then
												If GetSpecials(Session("STORE"), nUID, saSpecial, saSpecialDesc, saSpecialID) Then
													If Len(saSpecial(0)) > 0 Then
														Set oFS = CreateObject("Scripting.FileSystemObject")
														
														sFileName = "images/unit-titles/select" & nUID & ".jpg"
														If oFS.FileExists(Server.MapPath(sFileName)) Then
%>
							<img src="<%=sFileName%>" alt="<%=sUnitName%>">
<%
														Else
%>
							<p><b>Select Your <%=sUnitName%></b></p>
<%
														End If
														
														If Len(sPromoSpecialty) > 0 Then
%>
							<input type="hidden" name="spec" id="spec" value="<%=sPromoSpecialty%>">
							<%=GetSpecialtyName(Session("STORE"), nUID, sPromoSpecialty)%><br />&nbsp;<br />
<%
														Else
%>
							<select name="spec" id="spec" onmousewheel="return(false);" onkeydown="return(false);">
								<option value="" selected>Create Your Own</option>
<%
															For i = 0 To UBound(saSpecial)
%>
								<option value="<%=saSpecialID(i)%>"><%=saSpecial(i)%></option>
<%
															Next
%>
							</select><br />&nbsp;<br />
<%
														End If
													End If
												End If
											Else
%>
							<input type="hidden" name="spec" id="spec" value="<%=sSpecialty%>">
<%
											End If
%>
							<input type="image" src="images/next.jpg" name="submit" />
						</form>
<%
									Else
%>
						<strong>We apologize but our online ordering is temporarily unavailable (10).</strong>
<%
									End If
								Else
%>
						<strong>We apologize but our online ordering is temporarily unavailable (9).</strong>
<%
								End If
							Else
%>
						<strong>We apologize but our online ordering is temporarily unavailable (8).</strong>
<%
							End If
						Else
%>
						<strong>We apologize but our online ordering is temporarily unavailable (7).</strong>
<%
						End If
					Else
%>
						<strong>We apologize but our online ordering is temporarily unavailable (6).</strong>
<%
					End If
				Else
%>
						<strong>We apologize but our online ordering is temporarily unavailable (5).</strong>
<%
				End If
			Else
%>
						<strong>We apologize but our online ordering is temporarily unavailable (4).</strong>
<%
			End If
		Else
%>
						<strong>We apologize but our online ordering is temporarily unavailable (3).</strong>
<%
		End If
	Else
%>
						<strong>We apologize but our online ordering is temporarily unavailable (2).</strong>
<%
	End If
Else
%>
						<strong>We apologize but our online ordering is temporarily unavailable (1).</strong>
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
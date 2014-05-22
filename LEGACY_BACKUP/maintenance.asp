<%
option explicit
Response.buffer = TRUE

If UCase(Request.ServerVariables("HTTPS")) <> "ON" Then
	Response.Redirect("https://www.vitos.com/orderdev/Default.asp")
End If

If Len(Session("ZIPCODE")) = 0 Then
	Response.Redirect("Default.asp")
End If
%>
<!-- #Include File="include/adovbs.asp" -->
<!-- #Include File="include/app-settings.asp" -->
<!-- #Include File="include/app-database.asp" -->
<!-- #Include File="include/app-ordering.asp" -->
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
		<td rowspan="5" background="images/template2_01.jpg" width="1" height="400"></td>
		<td colspan="15" align="left" valign="top" background="images/template_02.jpg" width="804" height="133">
						<span class="total">TEST SYSTEM</span>
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
		<td align="left" valign="top" background="images/template_11.jpg" width="87" height="23">
		<img src="images/template_11.jpg" width="87" height="23" alt="Locations" /></td>
		<td align="left" valign="top" background="images/template_12.jpg" width="13" height="23"></td>
		<td align="left" valign="top" background="images/template_13.jpg" width="89" height="23">
		<img src="images/template_13.jpg" width="89" height="23" alt="Franchise" /></td>
		<td align="left" valign="top" background="images/template_14.jpg" width="13" height="23"></td>
		<td align="left" valign="top" background="images/template_15.jpg" width="41" height="23">
		<img src="images/template_15.jpg" width="41" height="23" alt="Jobs" /></td>
		<td align="left" valign="top" background="images/template_16.jpg" width="14" height="23"></td>
		<td align="left" valign="top" background="images/template_17.jpg" width="73" height="23">
		<img src="images/template_17.jpg" width="73" height="23" alt="Contact" /></td>
		<td align="left" valign="top" background="images/template_18.jpg" width="46" height="23"></td>
	</tr>
	<tr>
		<td colspan="16" align="left" valign="top" background="images/template2_19.jpg" width="850" height="88">
			<div align="right" style="margin-right:24px; margin-top:4px">
				<font color="#FFFF00" size="4">
					<marquee bgcolor="#FF0000" direction="left" loop="-1" width="575">
						<strong><%=GetMarqueeText()%></strong></marquee>
				</font>
			</div>
		</td>
	</tr>
	<tr>
		<td align="left" valign="top" background="images/template2_20.jpg" width="81" height="70"></td>
		<td colspan="13" align="left" valign="top" background="images/template2_21.jpg" width="650" height="70">
			<img alt="Location" src="images/location.jpg" width="204" height="28"><br>
			Sorry, the store you selected is currently closed or we are performing system maintenance.<br>&nbsp;<br>
<%
Dim aStore(), aName(), aAddress(), aAddress2(), aCity(), aState(), aPostalCode(), aPhone(), aFax(), aHours(), i

If LocateStoresByPostalCode(Session("ZIPCODE"), aStore, aName, aAddress, aAddress2, aCity, aState, aPostalCode, aPhone, aFax, aHours) Then
	Session("MODE") = "PICKUP"
	Session("DELIVERY") = CDbl(0.00)
	Session("DRMONEY") = CDbl(0.00)
%>
			Please check back later or select one of our other restaurants for 
			pick up service:.<br>&nbsp;<br>
<%
	Dim sFormAction2
	
	For i = 1 To UBound(aName)
		If CLng(aStore(i)) < 17 And CLng(aStore(i)) > 2 And CLng(aStore(i)) <> 5 And CLng(aStore(i)) <> 15 And CLng(aStore(i)) <> 13 Then
			If Right(LCase(Request.ServerVariables("SERVER_NAME")), 9) = "vitos.com" Then
				If InStr(UCase(Request.ServerVariables("URL")), "ORDERTESTNEW") = 0 Then
					sFormAction2 = "https://www.vitos.com/ordering/deals.asp"
				Else
					sFormAction2 = "https://www.vitos.com/ordertest/deals.asp"
				End If
			Else
				sFormAction2 = "http://www.arlglobal.com/ordering2/deals.asp"
			End If
%>
			<form method="post" action="<%=sFormAction2%>">
				<input type="hidden" name="SWITCHSYS" value="YES" />
				<input type="hidden" name="SWITCHSYS-RefID" value="<%=SESSION("RefID")%>" />
				<input type="hidden" name="SWITCHSYS-EMAIL" value="<%=SESSION("EMAIL")%>" />
				<input type="hidden" name="SWITCHSYS-ADDRESS" value="<%=SESSION("ADDRESS")%>" />
				<input type="hidden" name="SWITCHSYS-APT" value="<%=SESSION("APT")%>" />
				<input type="hidden" name="SWITCHSYS-ZIPCODE" value="<%=SESSION("ZIPCODE")%>" />
				<input type="hidden" name="ACTION" value="PICKUP" />
				<input type="hidden" name="STORE" value="<%=aStore(i)%>" />
<%
			If Request("PROMOCODE").Count > 0 Then
%>
				<input type="hidden" name="PROMOCODE" value="<%=Request("PROMOCODE")%>" />
<%
			End If
%>
				<%=aName(i)%><br>
				<%=aAddress(i)%><br>
<%
			If Not IsEmpty(aAddress2(i)) And Not IsNull(aAddress2(i)) Then
%>
				<%=aAddress2(i)%><br>
<%
			End If
%>
				<%=aCity(i)%>,&nbsp;<%=aState(i)%>&nbsp;<%=aPostalCode(i)%><br>
				<%=Left(aPhone(i), 3) & "-" & Mid(aPhone(i), 4, 3) & "-" & Mid(aPhone(i), 7)%><br>
<%
			If Not IsEmpty(aFax(i)) And Not IsNull(aFax(i)) Then
%>
				<%=aFax(i)%><br>
<%
			End If
%>
				Hours: <%=aHours(i)%><br>
				<span class="auto-style1"><strong>PLEASE NOTE:
				This store utilizes our old online ordering system. Switching to 
				this store will clear you current order.</strong></span><br />
				<input name="submit" type="image" src="images/go.jpg" />
			</form>
			&nbsp;<br>
<%
		Else
%>
			<form method="post" action="deals.asp">
				<input type="hidden" name="ACTION" value="PICKUP">
				<input type="hidden" name="STORE" value="<%=aStore(i)%>">
				<%=aName(i)%><br>
				<%=aAddress(i)%><br>
<%
			If Not IsEmpty(aAddress2(i)) And Not IsNull(aAddress2(i)) Then
%>
				<%=aAddress2(i)%><br>
<%
			End If
%>
				<%=aCity(i)%>,&nbsp;<%=aState(i)%>&nbsp;<%=aPostalCode(i)%><br>
				<%=Left(aPhone(i), 3) & "-" & Mid(aPhone(i), 4, 3) & "-" & Mid(aPhone(i), 7)%><br>
<%
			If Not IsEmpty(aFax(i)) And Not IsNull(aFax(i)) Then
%>
				<%=aFax(i)%><br>
<%
			End If
%>
				Hours: <%=aHours(i)%><br>
				<input name="submit" type="image" src="images/go.jpg" />
			</form>
			&nbsp;<br>
<%
		End If
	Next
Else
%>
			No stores found.
			<%=gs_ErrorMsg%><br>
<%
End If
%>
		</td>
		<td colspan="2" align="left" valign="top" background="images/template2_22.jpg" width="119" height="70"></td>
	</tr>
	<tr>
		<td colspan="16" align="left" valign="top" background="images/template2_23.jpg" width="850" height="86" class="copyright">
		&nbsp;<br />
		&nbsp;<br />
		&nbsp;<br />
		
		&copy; 2009-2011 Vito&#39;s Pizza Inc. All Rights Reserved</td>
	</tr>
	<tr>
		<td background="images/spacer.gif" width="1" height="1"></td>
		<td background="images/spacer.gif" width="81" height="1"></td>
		<td background="images/spacer.gif" width="177" height="1"></td>
		<td background="images/spacer.gif" width="53" height="1"></td>
		<td background="images/spacer.gif" width="12" height="1"></td>
		<td background="images/spacer.gif" width="49" height="1"></td>
		<td background="images/spacer.gif" width="15" height="1"></td>
		<td background="images/spacer.gif" width="74" height="1"></td>
		<td background="images/spacer.gif" width="13" height="1"></td>
		<td background="images/spacer.gif" width="87" height="1"></td>
		<td background="images/spacer.gif" width="13" height="1"></td>
		<td background="images/spacer.gif" width="89" height="1"></td>
		<td background="images/spacer.gif" width="13" height="1"></td>
		<td background="images/spacer.gif" width="41" height="1"></td>
		<td background="images/spacer.gif" width="14" height="1"></td>
		<td background="images/spacer.gif" width="73" height="1"></td>
		<td background="images/spacer.gif" width="46" height="1"></td>
	</tr>
</table>
</body>
</html>

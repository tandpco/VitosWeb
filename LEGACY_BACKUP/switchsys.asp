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
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Welcome to Vito&#39;s Pizza Online Ordering</title>
<link rel="stylesheet" href="css/ordering2.css" type="text/css" />
<style type="text/css">
.auto-style1 {
	color: #FF0000;
}
</style>
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
<%
Dim sName, sAddress1, sAddress2, sCity, sState, sPostalCode, sPhone, sFax, sHours

GetStoreInfo CLng(Request("store")), sName, sAddress1, sAddress2, sCity, sState, sPostalCode, sPhone, sFax, sHours
%>
			<img alt="Location" src="images/location.jpg" width="204" height="28"><br>
			<span class="auto-style1"><strong>PLEASE NOTE:
			This store utilizes our old online ordering system. Switching to 
			this store will clear you current order. Or <a href="deals.asp">
			click here</a> to keep your order as pickup.</strong></span><br />&nbsp;<br>
<%
Dim sFormAction2

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
				<input type="hidden" name="ACTION" value="DELIVERY" />
				<input type="hidden" name="STORE" value="<%=Request("store")%>" />
<%
If Request("PROMOCODE").Count > 0 Then
%>
				<input type="hidden" name="PROMOCODE" value="<%=Request("PROMOCODE")%>" />
<%
End If
%>
				<%=sName%><br>
				<%=sAddress1%><br>
<%
If Not IsEmpty(sAddress2) And Not IsNull(sAddress2) Then
%>
				<%=sAddress2%><br>
<%
End If
%>
				<%=sCity%>,&nbsp;<%=sState%>&nbsp;<%=sPostalCode%><br>
				<%=Left(sPhone, 3) & "-" & Mid(sPhone, 4, 3) & "-" & Mid(sPhone, 7)%><br>
<%
If Not IsEmpty(sFax) And Not IsNull(sFax) Then
%>
				<%=sFax%><br>
<%
End If
%>
				Hours: <%=sHours%><br>
				<input name="submit" type="image" src="images/go.jpg" />
			</form>
			&nbsp;<br>
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

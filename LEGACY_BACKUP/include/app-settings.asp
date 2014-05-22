<%
' **************************************************************************
' File: cm-settings.asp
' Purpose: Include file containing necessary global settings.
' Created: 7/18/2007 - TAM
'
' Revision History:
' 7/18/2007 - Created
' **************************************************************************

Dim gs_ErrorMsg, gb_SystemActive
Dim gs_DBProvider, gs_DBFile, gn_DBMode, gs_SQLServerHost, gs_SQLServerDatabase, gs_SQLServerUserID, gs_SQLServerPassword
Dim gs_MailSystem
Dim gs_PaymentGWURL, gs_PaymentGWReturnURL

gs_ErrorMsg = ""

' Test/Devel
gb_SystemActive = TRUE

' gs_DBProvider - valid values are "Microsoft.Jet.OLEDB.4.0" and "SQLOLEDB"
gs_DBProvider = "SQLOLEDB"

' The following values are only for provider "Microsoft.Jet.OLEDB.4.0"
'gs_DBFile = "../../db/webdocs.mdb"
''gn_DBMode - valid values are adModeReadWrite and adModeRead
'gn_DBMode = adModeReadWrite

' The following values are only for provider "SQLOLEDB"
gs_SQLServerHost = "websql.vitos.com"
gs_SQLServerDatabase = "vitostest"
gs_SQLServerUserID = "webtest"
gs_SQLServerPassword = "T3st4Th3W3b"

' The following specified the SMTP server for mail
gs_MailSystem = "mail-fwd"

' Payment Gateway
gs_PaymentGWURL = "https://hps.webportal.test.secureexchange.net/PaymentMain.aspx"
gs_PaymentGWReturnURL = "https://www.vitos.com/orderdev/gwresult.asp"
%>

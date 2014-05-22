<%
Const cdoSendUsingPort = 2
'*******************************************************
' Function SendMail
' Sends a mail message.
' Returns TRUE or FALSE
'*********************************************************
Function SendMail(ByVal sFrom, ByVal sTo, ByVal sCC, ByVal sBCC, ByVal sSubject, ByVal sBody, ByVal bHTML)
	Dim cdoMessage, cdoConfig
	
       set cdoMessage = Server.CreateObject("CDO.Message")
       set cdoConfig = Server.CreateObject("CDO.Configuration")
       cdoConfig.Fields("http://schemas.microsoft.com/cdo/configuration/sendusing") = 2
       cdoConfig.Fields("http://schemas.microsoft.com/cdo/configuration/smtpserver") = gs_MailSystem
       cdoConfig.Fields.Update
       set cdoMessage.Configuration = cdoConfig
       cdoMessage.From =  sFrom
       cdoMessage.ReplyTo = sFrom
       cdoMessage.To = sTo
       If Not IsEmpty(sCC) Then
	       cdoMessage.Cc = sCC
       End If
       If Not IsEmpty(sBCC) Then
	       cdoMessage.Bcc = sBCC
       End If
       cdoMessage.Subject = sSubject
       cdoMessage.HtmlBody = sBody
       on error resume next
       cdoMessage.Send
       if Err.Number <> 0 then
         SendMail = FALSE
       else
         SendMail = TRUE
       end if
       set cdoMessage = Nothing
       set cdoConfig = Nothing
End Function
%>
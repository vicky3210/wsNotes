
>SOAP（Simple Object Access Protocol ）简单对象访问协议是在分散或分布式的环境中交换信息的简单的协议，是一个基于XML的协议，它包括四个部分：SOAP封装(envelop)，SOAP编码规则（encoding rules），SOAP RPC表示(RPC representation，SOAP绑定（binding）


```powershell
function Execute-SOAPRequest
(
        [Xml]    $SOAPRequest,
        [String] $URL
)
{
        write-host "Sending SOAP Request To Server: $URL"
        $soapWebRequest = [System.Net.WebRequest]::Create($URL)
        $soapWebRequest.Headers.Add("SOAPAction","`"http://www.facilities.co.za/valid8service/valid8service/Valid8Address`"")
        $soapWebRequest.ContentType = "text/xml;charset=`"utf-8`""
        $soapWebRequest.Accept      = "text/xml"
        $soapWebRequest.Method      = "POST"

        write-host "Initiating Send."
        $requestStream = $soapWebRequest.GetRequestStream()
        $SOAPRequest.Save($requestStream)
        $requestStream.Close()

        write-host "Send Complete, Waiting For Response."
        $resp = $soapWebRequest.GetResponse()
        $responseStream = $resp.GetResponseStream()
        $soapReader = [System.IO.StreamReader]($responseStream)
        $ReturnXml = [Xml] $soapReader.ReadToEnd()
        $responseStream.Close()

        write-host "Response Received."
        return $ReturnXml
}
$url = 'http://www.facilities.co.za/valid8service/valid8service.asmx'
$soap = [xml]@'
<?xml version="1.0" encoding="utf-8"?>
<soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">
  <soap12:Body>
    <Valid8Address xmlns="http://www.facilities.co.za/valid8service/valid8service">
      <ID>string</ID>
      <Address1></Address1>
      <Address2></Address2>
      <Address3></Address3>
      <Address4></Address4>
      <Address5></Address5>
      <Address6></Address6>
      <PostCode></PostCode>
    </Valid8Address>
  </soap12:Body>
</soap12:Envelope>
'@
$ret = Execute-SOAPRequest $soap $url
```

在这里得到的`$ret`变量中存储的是`System.Xml.XmlDocument`对象，如果需要查看其中的具体内容可以通过`Export-Clixml`这个cmdlet将其输出到本地文件中查看。

这是一段程序代码。

复制代码 代码如下:

```
$ret | Export-Clixml  c:\1.xml;Get-Content c:\1.xml
```

function FindProxyForURL(url, host)
{
  if(isPlainHostName(host)){
    return "DIRECT";
  }else if(dnsDomainIs(host,".borg-ibk.local")){
    return "DIRECT";
  }else if(host.substring(0,4)=="127."){
    return "DIRECT";
  }else if(host.substring(0,8)=="192.168."){
    return "DIRECT";
  }else if (shExpMatch(url,"https://www.borg-ibk.ac.at")) {
    return "PROXY 172.16.1.36; DIRECT";
  }else if (shExpMatch(url,"https://www.borg-ibk.tsn.at")) {
    return "PROXY 172.16.1.36; DIRECT";
  }else if (shExpMatch(url,"https://wiki.borg-ibk.tsn.at")) {
    return "PROXY 172.16.1.37; DIRECT";
  }else if(url.substring(0,5)=="http:"){
    return "PROXY 192.168.200.210:8080; DIRECT";
  }else if(url.substring(0,6)=="https:"){
    return "PROXY 192.168.200.210:8080; DIRECT";
  }else if(url.substring(0,4)=="ftp:"){
    return "PROXY 192.168.200.210:8080; DIRECT";
  }else{
    return "DIRECT";
  }
}

# escape=`
FROM microsoft/aspnet:3.5-windowsservercore-10.0.14393.1715
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

RUN Remove-Website 'Default Web Site';

# Set up website: Default Web Site
RUN New-Item -Path 'C:\inetpub\wwwroot' -Type Directory -Force; 

RUN New-Website -Name 'Default Web Site' -PhysicalPath 'C:\inetpub\wwwroot' -Port 80 -ApplicationPool '.NET v2.0' -Force; 

EXPOSE 80

COPY ["wwwroot", "/inetpub/wwwroot"]

RUN $path='C:\inetpub\wwwroot'; `
    $acl = Get-Acl $path; `
    $newOwner = [System.Security.Principal.NTAccount]('BUILTIN\IIS_IUSRS'); `
    $acl.SetOwner($newOwner); `
    dir -r $path | Set-Acl -aclobject  $acl

# Set up website: SmartHotelWCF
RUN New-Item -Path 'C:\inetpub\SmartHotelWCF' -Type Directory -Force; 

RUN New-Website -Name 'SmartHotelWCF' -PhysicalPath 'C:\inetpub\SmartHotelWCF' -Port 8088 -ApplicationPool '.NET v2.0' -Force; 

EXPOSE 8088

COPY ["SmartHotelWCF", "/inetpub/SmartHotelWCF"]

RUN $path='C:\inetpub\SmartHotelWCF'; `
    $acl = Get-Acl $path; `
    $newOwner = [System.Security.Principal.NTAccount]('BUILTIN\IIS_IUSRS'); `
    $acl.SetOwner($newOwner); `
    dir -r $path | Set-Acl -aclobject  $acl

# Set up website: SmartHotelWeb
RUN New-Item -Path 'C:\inetpub\SmartHotelWeb' -Type Directory -Force; 

RUN New-Website -Name 'SmartHotelWeb' -PhysicalPath 'C:\inetpub\SmartHotelWeb' -Port 80 -ApplicationPool '.NET v2.0' -Force; 

EXPOSE 80

COPY ["SmartHotelWeb", "/inetpub/SmartHotelWeb"]

RUN $path='C:\inetpub\SmartHotelWeb'; `
    $acl = Get-Acl $path; `
    $newOwner = [System.Security.Principal.NTAccount]('BUILTIN\IIS_IUSRS'); `
    $acl.SetOwner($newOwner); `
    dir -r $path | Set-Acl -aclobject  $acl

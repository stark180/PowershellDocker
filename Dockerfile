# Use a base image with PowerShell installed
FROM mcr.microsoft.com/powershell:latest

COPY Fibonacci.ps1 /app/

WORKDIR /app/

CMD ["pwsh", "-File", "./Fibonacci.ps1"]

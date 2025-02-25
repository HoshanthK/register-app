# Use Windows Server Core base image
FROM mcr.microsoft.com/windows/servercore:ltsc2019

# Set environment variables for Python version
ENV PYTHON_VERSION 3.7.6
ENV PYTHON_HOME C:\Python${PYTHON_VERSION}

# Install necessary components
RUN powershell -Command \
    # Install Python 3.7.6+
    Invoke-WebRequest -Uri https://www.python.org/ftp/python/3.7.6/python-3.7.6.exe -OutFile python-installer.exe; \
    Start-Process -Wait -FilePath python-installer.exe -ArgumentList "/quiet InstallAllUsers=1 PrependPath=1 Include_pip=1" ; \
    Remove-Item -Force python-installer.exe; \
    # Install Firefox
    Invoke-WebRequest -Uri https://download.mozilla.org/?product=firefox-latest&os=win64&lang=en-US -OutFile firefox-installer.exe; \
    Start-Process -Wait -FilePath firefox-installer.exe -ArgumentList "/silent"; \
    Remove-Item -Force firefox-installer.exe; \
    # Install .NET Framework 4.6.1
    Invoke-WebRequest -Uri https://go.microsoft.com/fwlink/?LinkId=533210 -OutFile dotnet-installer.exe; \
    Start-Process -Wait -FilePath dotnet-installer.exe -ArgumentList "/q"; \
    Remove-Item -Force dotnet-installer.exe; \
    # Install C++ Build Tools (MSVC v142)
    Invoke-WebRequest -Uri https://aka.ms/vs/16/release/vs_installer.exe -OutFile vs_installer.exe; \
    Start-Process -Wait -FilePath vs_installer.exe -ArgumentList "--quiet --wait --norestart --add Microsoft.VisualCpp --path cache=C:\VS_installer_cache"; \
    Remove-Item -Force vs_installer.exe;

# Set up working directory
WORKDIR C:/IPAQAAutomation/WebAppScrape

# Copy requirements.txt into the container
COPY requirements.txt C:/IPAQAAutomation/WebAppScrape/

# Install Python dependencies
RUN pip install --trusted-host pypi.org --trusted-host files.pythonhosted.org pip setuptools -r requirements.txt

# Expose any necessary ports (optional)
# EXPOSE 8080

# Default command to launch the automation tool
CMD ["cmd", "/c", "start IPA Automation Tool"]

# This PowerShell script is inteded to be run at startup to open
# Microsoft Edge in fullscreen mode.
# It was created to work with a Ping Monitor application running on localhost.

# Wait for a few seconds to make sure Ping Monitor has started
Start-Sleep -Seconds 30

# Define the path to the Edge executable
$edgePath = "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"

# Define the URL to open
$url = "http://localhost:4811/monitor?timezone=Europe%2fLondon"

# Start Edge
Start-Process -FilePath $edgePath -ArgumentList $url

# Wait for a few seconds to make sure Edge has started
Start-Sleep -Seconds 1

# Load the necessary .NET assembly
Add-Type -TypeDefinition @"
    using System;
    using System.Runtime.InteropServices;

    public class Keyboard {
        [DllImport("user32.dll")]
        public static extern void keybd_event(byte bVk, byte bScan, uint dwFlags, int dwExtraInfo);
    }
"@

# Define the key code for F11
$f11KeyCode = 0x7A

# Simulate pressing the F11 key
[Keyboard]::keybd_event($f11KeyCode, 0, 0, 0)

# Simulate releasing the F11 key
[Keyboard]::keybd_event($f11KeyCode, 0, 2, 0)

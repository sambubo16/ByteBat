param (
    [int]$x,
    [int]$y,
    [int]$width,
    [int]$height,
    [string]$url
)

# Create a new Internet Explorer COM object
$ie = New-Object -ComObject InternetExplorer.Application

# Set properties to make the window resizable and draggable
$ie.ToolBar = $false
$ie.StatusBar = $false
$ie.MenuBar = $false
$ie.AddressBar = $false
$ie.Resizable = $true
$ie.Visible = $true

# Navigate to the specified URL
$ie.Navigate2($url)

# Wait for the page to load
while ($ie.Busy) {
    Start-Sleep -Milliseconds 100
}

# Get the window handle
$hwnd = $ie.HWND

# Import user32.dll functions
Add-Type @"
    using System;
    using System.Runtime.InteropServices;
    public class User32 {
        [DllImport("user32.dll", SetLastError = true)]
        public static extern int SetWindowLong(IntPtr hWnd, int nIndex, int dwNewLong);
        [DllImport("user32.dll", SetLastError = true)]
        public static extern bool SetWindowPos(IntPtr hWnd, IntPtr hWndInsertAfter, int X, int Y, int cx, int cy, uint uFlags);
        [DllImport("user32.dll", SetLastError = true)]
        public static extern int GetWindowLong(IntPtr hWnd, int nIndex);
        [DllImport("user32.dll", SetLastError = true)]
        public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
        [DllImport("user32.dll", SetLastError = true)]
        public static extern bool PostMessage(IntPtr hWnd, uint Msg, IntPtr wParam, IntPtr lParam);
    }
"@

# Constants
$GWL_STYLE = -16
$WS_CAPTION = 0x00C00000
$WS_THICKFRAME = 0x00040000
$HWND_TOPMOST = -1
$SWP_NOMOVE = 0x0002
$SWP_NOSIZE = 0x0001
$SWP_NOACTIVATE = 0x0010
$SWP_SHOWWINDOW = 0x0040
$SW_HIDE = 0
$SW_SHOW = 5
$GWL_EXSTYLE = -20
$WS_EX_TOOLWINDOW = 0x00000080
$WM_CLOSE = 0x0010

# Remove the title bar and make the window topmost
$style = [User32]::GetWindowLong($hwnd, $GWL_STYLE)
$style = $style -band -bnot ($WS_CAPTION -bor $WS_THICKFRAME)
[User32]::SetWindowLong($hwnd, $GWL_STYLE, $style)
[User32]::SetWindowPos($hwnd, $HWND_TOPMOST, $x, $y, $width, $height, $SWP_SHOWWINDOW)

# Make the window not visible on the taskbar
$exStyle = [User32]::GetWindowLong($hwnd, $GWL_EXSTYLE)
$exStyle = $exStyle -bor $WS_EX_TOOLWINDOW
[User32]::SetWindowLong($hwnd, $GWL_EXSTYLE, $exStyle)
[User32]::ShowWindow($hwnd, $SW_SHOW)

# Function to close the window


